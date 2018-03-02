NODE_VER := v9.7.1

INFO_COLOR=\033[1;34m
RESET=\033[0m
BOLD=\033[1m

nodebrew:
	@echo "$(INFO_COLOR)==> $(RESET)$(BOLD)Installing nodebrew$(RESET)"
	brew install nodebrew
	nodebrew setup
	echo 'export PATH=$$HOME/.nodebrew/current/bin:$$PATH' >> ~/.bashrc

info:
	@echo "$(INFO_COLOR)==> $(RESET)$(BOLD)Showing node or npm information$(RESET)"
	@type node
	@type npm && npm -v

vendor:
	@echo "$(INFO_COLOR)==> $(RESET)$(BOLD)Installing node packages$(RESET)"
	git checkout package-lock.json
	rm -rf node_modules
	npm install

deps:
	@echo "$(INFO_COLOR)==> $(RESET)$(BOLD)Installing Dependencies$(RESET)"
	@brew ls nodebrew >/dev/null 2>&1 || $(MAKE) nodebrew
	nodebrew selfupdate
	@nodebrew ls | grep $(NODE_VER) || nodebrew install-binary $(NODE_VER)
	nodebrew use $(NODE_VER)
	npm install -g npm
	@$(MAKE) info
	@$(MAKE) vendor
