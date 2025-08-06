# DEFAULTS
PKG = kurukurubar
HOST = $(shell hostname)

REBUILD_ATTR = nixosConfigurations.$(HOST)
REBUILD_LOGFMT = bar
REBUILD_ARGS = --log-format $(REBUILD_LOGFMT) --no-reexec --file . -A $(REBUILD_ATTR)
REBUILD = nixos-rebuild $(REBUILD_ARGS)
# only for recusrive rebuild call
REBLD_REC_COMMON = @$(MAKE) MAKEFLAGS+=--no-print-directory rebuild

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

.PHONY: boot build fmt help pkg rebuild repl switch test time

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

# Tree sitter? What's that?
# TODO: pre-commit + efficient git based formatting
# could probably add git integration by only formatting the files that were
# modified making this more efficent
fmt:
	$(call ECHO_TARGET,Formatting)
	@alejandra -q .
	@cd ./users/dots/quickshell/kurukurubar/; qmlformat -i $$(find . -name '*.qml')
	@mbake format --config ./users/dots/formatters/bake.toml ./Makefile
	@lua-format -c ./users/dots/formatters/luafmt.yaml -i $$(find ./users/dots/ -name '*.lua')
	@mdformat --exclude '**/preview.md' $$(find . -name '*.md')
	@git -P diff --stat
	$(ECHO_DONE)

rebuild:
	$(call ECHO_TARGET,$(REBLD_COMMENT),$(HOST))
	@$(SUDO) $(REBUILD) $(REBLD_COMMAND)
	$(ECHO_DONE)

repl:
	$(REBLD_REC_COMMON) REBLD_COMMAND=$@ REBLD_COMMENT=Repl

build:
	$(REBLD_REC_COMMON) REBLD_COMMAND=$@ REBLD_COMMENT=Building SUDO=sudo

switch:
	$(REBLD_REC_COMMON) REBLD_COMMAND=$@ REBLD_COMMENT=Switching SUDO=sudo

dry:
	$(REBLD_REC_COMMON) REBLD_COMMAND=dry-build REBLD_COMMENT='Dry Building'

test:
	$(REBLD_REC_COMMON) REBLD_COMMAND=$@ REBLD_COMMENT=Testing SUDO=sudo

boot:
	$(REBLD_REC_COMMON) REBLD_COMMAND=$@ REBLD_COMMENT=Booting SUDO=sudo
