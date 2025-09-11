ifdef FILES_ALL
FILES_GIT = $(shell git ls-tree -r HEAD --name-only)
endif
ifdef FILES_STAGED
FILES_GIT ?= $(shell git status --porcelain | awk '/^[MA]/ { print $2 }')
endif
FILES_GIT ?= $(shell git status --porcelain | awk '/[MA\?]+/ { print $2 }')
FILES_NIX = $(filter %.nix,$(FILES_GIT))
FILES_QML = $(filter users/dots/quickshell/kurukurubar/%.qml,$(FILES_GIT))
FILES_LUA = $(filter %.lua,$(FILES_GIT))
FILES_MD = $(filter %.md,$(FILES_GIT))

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
	$(call ECHO_HELP,help,          Display this help)
	$(call ECHO_HELP,chk,           Checks changed files with formatters. Set $(COLOR_PURPLE)\$$FILES_STAGED$(COLOR_END) for staged files only)
	$(call ECHO_HELP,fmt,           Formats changed files set $(COLOR_PURPLE)\$$FILES_ALL$(COLOR_END) for formatting all files)

time:
	$(call ECHO_TARGET,Timing,$(HOST))
	@time $(EVAL)
	@$(ECHO_DONE)

pkg:
ifdef PKG
	$(call ECHO_TARGET,Building,$(PKG))
	@$(BUILD_OVERRIDES) $(BUILD) || (echo -e "$(ECHO_MAKE) $(COLOR_RED)Failed to build Package$(COLOR_END)" && exit 1)
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

chk:
ifneq ($(FILES_NIX),)
	$(call ECHO_TARGET,Checking,$(words $(FILES_NIX)) nix files)
	@$(foreach FILE,$(FILES_NIX),git show :$(FILE) | alejandra --check -q - &> /dev/null $(ECHO_NEWLINE))
endif
ifneq ($(FILES_QML),)
	$(call ECHO_TARGET,Checking,$(words $(FILES_QML)) qml files)
	@$(foreach FILE,$(FILES_QML),git show :$(FILE) | qmlcheck $(ECHO_NEWLINE))
endif
ifneq ($(FILES_LUA),)
	$(call ECHO_TARGET,Checking,$(words $(FILES_LUA)) lua files)
	@$(foreach FILE,$(FILES_LUA),git show :$(FILE) | lua-format --check -c ./pkgs/formatters/luafmt.yaml $(ECHO_NEWLINE))
endif
ifneq ($(FILES_MD),)
	$(call ECHO_TARGET,Checking,$(words $(FILES_MD)) md files)
	@$(foreach FILE,$(FILES_MD),git show :$(FILE) | mdformat --check - &> /dev/null; $(ECHO_NEWLINE))
endif
	$(call ECHO_TARGET,Checks passed >w<)

# Tree sitter? What's that?
fmt:
ifneq ($(FILES_NIX),)
	$(call ECHO_TARGET,Formatting,$(words $(FILES_NIX)) nix files)
	@alejandra -q $(FILES_NIX)
endif
ifneq ($(FILES_QML),)
	$(call ECHO_TARGET,Formatting,$(words $(FILES_QML)) qml files)
	@qmlformat -w 2 -l native -n --objects-spacing --functions-spacing -i $(FILES_QML)
endif
ifneq ($(FILES_LUA),)
	$(call ECHO_TARGET,Formatting,$(words $(FILES_LUA)) lua files)
	@lua-format -c ./pkgs/formatters/luafmt.yaml -i $(FILES_LUA)
endif
ifneq ($(FILES_MD),)
	$(call ECHO_TARGET,Formatting,$(words $(FILES_MD)) md files)
	@mdformat $(FILES_MD)
endif
ifneq ($(FILES_GIT),)
	@$(ECHO_DONE)
else
	$(call ECHO_TARGET,Nothing to format >.<)
endif
