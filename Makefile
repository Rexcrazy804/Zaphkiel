# DEFAULTS
PKG = kurukurubar
HOST = $(shell hostname)

ifneq ($(FMT_ALL),)
  FILES_GIT = $(shell git ls-tree -r HEAD --name-only | paste -sd " ")
endif
FILES_GIT ?= $(shell git status --porcelain | awk '/^ +?[M\?]/{ print $$2 }')
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
ECHO_DONE = @echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Done >w<$(COLOR_END)"
define ECHO_TARGET =
@echo -e "$(ECHO_MAKE) $(COLOR_BLUE)$(1)$(COLOR_END) $(COLOR_PURPLE)$(2)$(COLOR_END)"
endef

.PHONY: boot build chk fmt help pkg rebuild repl switch test time

# TODO: complete the help
help:
	$(call ECHO_TARGET,"hi there cutie pie :P")

# "But you can't use make as just a command runner"
# Oh yes I can darling ~

time:
	$(call ECHO_TARGET,Timing,$(HOST))
	@time $(EVAL)
	$(ECHO_DONE)

pkg:
	$(call ECHO_TARGET,Building,$(PKG))
	@$(BUILD) 2> /dev/null || (echo -e "$(ECHO_MAKE) $(COLOR_RED)Package not found$(COLOR_END)"; exit 1)
	$(ECHO_DONE)

clean:
	$(call ECHO_TARGET,Cleaning)
	@(rm -v ./result 2> /dev/null && $(ECHO_DONE)) || echo -e "$(ECHO_MAKE) Nothing to clean"

# mother bake is stupid where there is a colon in the middle
# bake-format off
chk:
ifneq ($(FILES_NIX),)
	$(call ECHO_TARGET,Checking,$(words $(FILES_NIX)) nix files)
	@$(foreach FILE,$(FILES_NIX),git show :$(FILE) | alejandra --check -q - > /dev/null)
endif
ifneq ($(FILES_LUA),)
	$(call ECHO_TARGET,Checking,$(words $(FILES_LUA)) lua files)
	@$(foreach FILE,$(FILES_LUA),git show :$(FILE) | lua-format --check -c ./users/dots/formatters/luafmt.yaml)
endif
ifneq ($(FILES_MK),)
	$(call ECHO_TARGET,$(COLOR_YELLOW)Cannot check makefiles :<)
endif
ifneq ($(FILES_MD),)
	$(call ECHO_TARGET,Checking,$(words $(FILES_MD)) md files)
	@$(foreach FILE,$(FILES_MD),git show :$(FILE) | mdformat --check --exclude '**/preview.md' - &> /dev/null)
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
	@mdformat $(if $(CHECK),--check) --exclude '**/preview.md' $(FILES_MD)
endif
ifneq ($(FILES_GIT),)
	$(ECHO_DONE)
else
	$(call ECHO_TARGET,Nothing to format >.<)
endif

rebuild:
	$(call ECHO_TARGET,$(REBLD_COMMENT),$(HOST))
	@$(if $(SUDO),sudo) $(REBUILD) $(REBLD_COMMAND)
	$(ECHO_DONE)

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
