# DEFAULTS
PKG=kurukurubar
HOST=$(shell hostname)

REBUILD_ATTR=nixosConfigurations.$(HOST)
REBUILD_LOGFMT=bar
REBUILD_ARGS=--log-format $(REBUILD_LOGFMT) --no-reexec --file . -A $(REBUILD_ATTR)
REBUILD=nixos-rebuild $(REBUILD_ARGS)

BUILD_ATTR=packages.$(PKG)
BUILD_FILE=./default.nix
BUILD_ARGS= $(BUILD_FILE) -A $(BUILD_ATTR)
BUILD=nix-build $(BUILD_ARGS)

EVAL_ATTR=nixosConfigurations.$(HOST).config.system.build.toplevel
EVAL_FILE=./default.nix
EVAL_OPTS=--substituters "" --option eval-cache false --raw --read-only
EVAL_ARGS=--file $(EVAL_FILE) $(EVAL_ATTR) $(EVAL_OPTS)
EVAL=nix eval $(EVAL_ARGS)


COLOR_GREEN=\e[0;32m
COLOR_RED=\e[0;31m
COLOR_BLUE=\e[0;34m
COLOR_YELLOW=\e[0;33m
COLOR_PURPLE=\e[0;35m
COLOR_END=\e[0m

ECHO_MAKE=$(COLOR_GREEN)[MAKE]$(COLOR_END)
ECHO_DONE=$(ECHO_MAKE) $(COLOR_BLUE)Done >w<$(COLOR_END)
ECHO_HOSTNAME=$(COLOR_PURPLE)$(HOST)$(COLOR_END)

help:
	echo "hi there cutie pie :P"
	# TODO: complete the help

# "But you can't use make as just a command runner"
# Oh yes I can darling ~
.PHONEY: time pkg fmt build repl switch test boot dry help clean
.SILENT: $(MAKECMDGOALS)

time:
	echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Timing$(COLOR_END) $(ECHO_HOSTNAME)"
	time $(EVAL)
	echo -e "$(ECHO_DONE)"

pkg:
	echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Building Package$(COLOR_END) $(COLOR_PURPLE)$(PKG)$(COLOR_END)"
	$(BUILD) 2> /dev/null || (echo -e "$(ECHO_MAKE) $(COLOR_RED)Package not found$(COLOR_END)"; exit 1)
	echo -e "$(ECHO_DONE)"

fmt:
	echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Formatting$(COLOR_END)"
	alejandra . &> /dev/null
	git diff --stat
	echo -e "$(ECHO_DONE)"

build:
	echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Building$(COLOR_END) $(ECHO_HOSTNAME)"
	$(REBUILD) build
	echo -e "$(ECHO_DONE)"

repl:
	echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Repl$(COLOR_END) $(ECHO_HOSTNAME)"
	$(REBUILD) repl
	echo -e "$(ECHO_DONE)"

switch:
	echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Switching$(COLOR_END) $(ECHO_HOSTNAME)"
	sudo $(REBUILD) switch
	echo -e "$(ECHO_DONE)"

dry:
	echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Dry Building$(COLOR_END) $(ECHO_HOSTNAME)"
	sudo $(REBUILD) dry-build
	echo -e "$(ECHO_DONE)"

test:
	echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Testing$(COLOR_END) $(ECHO_HOSTNAME)"
	sudo $(REBUILD) test
	echo -e "$(ECHO_DONE)"

boot:
	echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Booting$(COLOR_END) $(ECHO_HOSTNAME)"
	sudo $(REBUILD) boot
	echo -e "$(ECHO_DONE)"

clean:
	echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Cleaning$(COLOR_END)"
	rm ./result 2> /dev/null || echo -e "$(ECHO_MAKE) Nothing to clean"
	echo -e "$(ECHO_DONE)"
