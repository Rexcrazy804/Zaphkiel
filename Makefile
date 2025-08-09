# DEFAULTS
HOST = $(shell hostname)

ifdef FILES_ALL
  FILES_GIT = $(shell git ls-tree -r HEAD --name-only)
endif
ifdef FILES_STAGED
	FILES_GIT ?= $(shell git diff --staged --name-only)
endif
FILES_GIT ?= $(shell git status --porcelain | awk '/[M\?]+/ { print $2 }')
FILES_NIX = $(filter %.nix,$(FILES_GIT))
FILES_LUA = $(filter %.lua,$(FILES_GIT))
FILES_MK = $(filter Makefile,$(FILES_GIT))
FILES_MD = $(filter %.md,$(FILES_GIT))

REBUILD_ATTR = nixosConfigurations.$(HOST)
REBUILD_LOGFMT = bar
REBUILD_ARGS = --log-format $(REBUILD_LOGFMT) --no-reexec --file . -A $(REBUILD_ATTR)
REBUILD = nixos-rebuild $(REBUILD_ARGS)
# only for recusrive rebuild call
REBLD_REC_COMMON = @$(MAKE) --no-print-directory rebuild

BUILD_ATTR = packages.$(PKG)
BUILD_FILE = ./default.nix
BUILD_ARGS = $(BUILD_FILE) -A $(BUILD_ATTR)
BUILD = nix-build $(BUILD_ARGS)

EVAL_ATTR = nixosConfigurations.$(HOST).config.system.build.toplevel
EVAL_FILE = ./default.nix
EVAL_OPTS = --substituters "" --option eval-cache false --raw --read-only
EVAL_ARGS = --file $(EVAL_FILE) $(EVAL_ATTR) $(EVAL_OPTS)
EVAL = nix eval $(EVAL_ARGS)

COLOR_GREEN = \e[0;32m
COLOR_RED = \e[0;31m
COLOR_BLUE = \e[0;34m
COLOR_YELLOW = \e[0;33m
COLOR_PURPLE = \e[0;35m
COLOR_END = \e[0m

ECHO_MAKE = $(COLOR_GREEN)[MAKE]$(COLOR_END)
ECHO_DONE = echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Done >w<$(COLOR_END)"
define ECHO_TARGET =
@echo -e "$(ECHO_MAKE) $(COLOR_BLUE)$(1)$(COLOR_END) $(COLOR_PURPLE)$(2)$(COLOR_END)"
endef
define ECHO_HELP =
@echo -e "$(COLOR_YELLOW)$(1)$(COLOR_END) $(2)"
endef
define ECHO_NEWLINE


endef

.PHONY: boot build chk fmt help pkg rebuild repl switch test time

# "But you can't use make as just a command runner"
# Oh yes I can darling ~
help:
	@echo -e "# $(COLOR_BLUE)Zaphkiel's little helper$(COLOR_END)"
	@echo ""
	$(call ECHO_HELP,help,          display this help)
	@echo ""
	$(call ECHO_HELP,pkg,           build packages either from $(COLOR_PURPLE)\$$PKG$(COLOR_END) or from $(COLOR_PURPLE)\$$PKG_PATH$(COLOR_END))
	$(call ECHO_HELP,clean,         removes the result symlink)
	@echo ""
	$(call ECHO_HELP,chk,           checks changed files with formatters. set $(COLOR_PURPLE)\$$FILES_STAGED$(COLOR_END) for staged files only)
	$(call ECHO_HELP,fmt,           formats changed files set $(COLOR_PURPLE)\$$FILES_ALL$(COLOR_END) for formatting all files)
	@echo ""
	$(call ECHO_HELP,rebuild,       $(COLOR_RED)for internal recursive use only$(COLOR_END))
	$(call ECHO_HELP,repl build,    | used to perform repsective)
	$(call ECHO_HELP,boot switch,   > nixos-rebuild subcommands.)
	$(call ECHO_HELP,test dry,      | $(COLOR_PURPLE)\$$HOST$(COLOR_END) can be used to specify host)
	$(call ECHO_HELP,time,          benchmark evaluation time for nixos configuraiton)

time:
	$(call ECHO_TARGET,Timing,$(HOST))
	@time $(EVAL)
	@$(ECHO_DONE)

# can be passed a path to build the file with callPackage
pkg:
ifdef PKG
	$(call ECHO_TARGET,Building,$(PKG))
	@$(BUILD) || (echo -e "$(ECHO_MAKE) $(COLOR_RED)Failed to build Package$(COLOR_END)" && exit 1)
else
ifdef PKG_PATH
	$(call ECHO_TARGET,Calling Package,$(PKG_PATH))
	@nix-build --expr 'with import <nixpkgs> {}; callPackage $(PKG_PATH) {$(PKG_ATTRS)}' ||\
		(echo -e "$(ECHO_MAKE) $(COLOR_RED)Cannot build $(PKG_PATH) $(COLOR_END)" && exit 1)
else
	@echo -e "$(ECHO_MAKE) $(COLOR_RED)Neither $(COLOR_PURPLE)\$$PKG$(COLOR_RED) nor $(COLOR_PURPLE)\$$PKG_PATH$(COLOR_RED) was set$(COLOR_END)" && exit 1
endif
endif
	@$(ECHO_DONE)

clean:
	$(call ECHO_TARGET,Cleaning)
	@if rm -v ./result* 2> /dev/null;\
		then $(ECHO_DONE);\
		else echo -e "$(ECHO_MAKE) $(COLOR_YELLOW)Nothing to clean >.<$(COLOR_END)"; fi

# mbake is stupid where there is a colon in the middle
# bake-format off
chk:
ifneq ($(FILES_NIX),)
	$(call ECHO_TARGET,Checking,$(words $(FILES_NIX)) nix files)
	@$(foreach FILE,$(FILES_NIX),git show :$(FILE) | alejandra --check -q - &> /dev/null $(ECHO_NEWLINE))
endif
ifneq ($(FILES_LUA),)
	$(call ECHO_TARGET,Checking,$(words $(FILES_LUA)) lua files)
	@$(foreach FILE,$(FILES_LUA),git show :$(FILE) | lua-format --check -c ./users/dots/formatters/luafmt.yaml $(ECHO_NEWLINE))
endif
ifneq ($(FILES_MK),)
	$(call ECHO_TARGET,Checking,$(words $(FILES_MK)) make files)
	@$(foreach FILE,$(FILES_MK),git show :$(FILE) | mbake format --stdin --check --config ./users/dots/formatters/bake.toml &> /dev/null $(ECHO_NEWLINE))
endif
ifneq ($(FILES_MD),)
	$(call ECHO_TARGET,Checking,$(words $(FILES_MD)) md files)
	@$(foreach FILE,$(FILES_MD),git show :$(FILE) | mdformat --check - &> /dev/null; $(ECHO_NEWLINE))
endif
	$(call ECHO_TARGET,Checks passed >w<)
#bake-format on

# Tree sitter? What's that?
fmt:
ifneq ($(FILES_NIX),)
	$(call ECHO_TARGET,Formatting,$(words $(FILES_NIX)) nix files)
	@alejandra -q $(FILES_NIX)
endif
ifneq ($(FILES_LUA),)
	$(call ECHO_TARGET,Formatting,$(words $(FILES_LUA)) lua files)
	@lua-format -c ./users/dots/formatters/luafmt.yaml -i $(FILES_LUA)
endif
ifneq ($(FILES_MK),)
	$(call ECHO_TARGET,Formatting,$(words $(FILES_MK)) make files)
	@mbake format $(if $(CHECK),--check) --config ./users/dots/formatters/bake.toml $(FILES_MK)
endif
ifneq ($(FILES_MD),)
	$(call ECHO_TARGET,Formatting,$(words $(FILES_MD)) md files)
	@mdformat $(if $(CHECK),--check) $(FILES_MD)
endif
ifneq ($(FILES_GIT),)
	@$(ECHO_DONE)
else
	$(call ECHO_TARGET,Nothing to format >.<)
endif

rebuild:
	$(call ECHO_TARGET,$(REBLD_COMMENT),$(HOST))
	@$(if $(SUDO),sudo) $(REBUILD) $(REBLD_COMMAND)
	@$(ECHO_DONE)

repl:
	$(REBLD_REC_COMMON) REBLD_COMMAND=$@ REBLD_COMMENT=Repl

build:
	$(REBLD_REC_COMMON) REBLD_COMMAND=$@ REBLD_COMMENT=Building SUDO=1

switch:
	$(REBLD_REC_COMMON) REBLD_COMMAND=$@ REBLD_COMMENT=Switching SUDO=1

dry:
	$(REBLD_REC_COMMON) REBLD_COMMAND=dry-build REBLD_COMMENT='Dry Building'

test:
	$(REBLD_REC_COMMON) REBLD_COMMAND=$@ REBLD_COMMENT=Testing SUDO=1

boot:
	$(REBLD_REC_COMMON) REBLD_COMMAND=$@ REBLD_COMMENT=Booting SUDO=1
