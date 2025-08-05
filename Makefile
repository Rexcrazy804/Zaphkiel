HOST=$(shell hostname)
REBUILD_ATTR=nixosConfigurations.$(HOST)
REBUILD_LOGFMT=bar
REBUILD_ARGS=--log-format $(REBUILD_LOGFMT) --no-reexec --file . -A $(REBUILD_ATTR)
REBUILD=nixos-rebuild $(REBUILD_ARGS)

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
.PHONEY: fmt build repl switch test boot dry-build help clean
.SILENT: $(MAKECMDGOALS)

fmt:
	echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Formatting$(COLOR_END)"
	alejandra . &> /dev/null
	git diff
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

dry-build:
	echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Dry Building$(COLOR_END) $(ECHO_HOSTNAME)"
	sudo $(REBUILD) dry-build
	echo -e "$(ECHO_DONE)"

test:
	echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Testing$(COLOR_END) $(ECHO_HOSTNAME)"
	sudo $(REBUILD) test
	echo -e "$(ECHO_DONE)"

boot:
	echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Testing$(COLOR_END) $(ECHO_HOSTNAME)"
	sudo $(REBUILD) boot
	echo -e "$(ECHO_DONE)"

clean:
	echo -e "$(ECHO_MAKE) $(COLOR_BLUE)Cleaning$(COLOR_END)"
	rm ./result 2> /dev/null || echo -e "$(ECHO_MAKE) Nothing to clean"
	echo -e "$(ECHO_DONE)"
