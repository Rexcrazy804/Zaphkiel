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
define ECHO_TARGET =
echo -e "$(ECHO_MAKE) $(COLOR_BLUE)$(1)$(COLOR_END) $(COLOR_PURPLE)$(2)$(COLOR_END)"
endef

help:
	$(call ECHO_TARGET,"hi there cutie pie :P")
	# TODO: complete the help

# "But you can't use make as just a command runner"
# Oh yes I can darling ~
.PHONEY: time pkg fmt clean repl build switch test boot dry help
.SILENT: $(MAKECMDGOALS)

time:
	$(call ECHO_TARGET,Timing,$(HOST))
	time $(EVAL)
	echo -e "$(ECHO_DONE)"

pkg:
	$(call ECHO_TARGET,Building,$(PKG))
	$(BUILD) 2> /dev/null || (echo -e "$(ECHO_MAKE) $(COLOR_RED)Package not found$(COLOR_END)"; exit 1)
	echo -e "$(ECHO_DONE)"

clean:
	$(call ECHO_TARGET,Cleaning,$(HOST))
	(rm -v ./result 2> /dev/null && echo -e "$(ECHO_DONE)") || echo -e "$(ECHO_MAKE) Nothing to clean"

fmt:
	$(call ECHO_TARGET,Formatting)
	alejandra . &> /dev/null
	cd ./users/dots/quickshell/kurukurubar/; qmlformat -i $$(find . -name '*.qml')
	git diff --stat
	echo -e "$(ECHO_DONE)"

repl:
	$(call ECHO_TARGET,Repl,$(HOST))
	$(REBUILD) repl
	echo -e "$(ECHO_DONE)"

build:
	$(call ECHO_TARGET,BUILDING,$(HOST))
	$(REBUILD) build
	echo -e "$(ECHO_DONE)"

switch:
	$(call ECHO_TARGET,Switching,$(HOST))
	sudo $(REBUILD) switch
	echo -e "$(ECHO_DONE)"

dry:
	$(call ECHO_TARGET,Dry Building,$(HOST))
	sudo $(REBUILD) dry-build
	echo -e "$(ECHO_DONE)"

test:
	$(call ECHO_TARGET,Testing,$(HOST))
	sudo $(REBUILD) test
	echo -e "$(ECHO_DONE)"

boot:
	$(call ECHO_TARGET,Booting,$(HOST))
	sudo $(REBUILD) boot
	echo -e "$(ECHO_DONE)"
