CONFIG_FILE = /home/$(USER)/.config/git/configuration

ifeq ("","$(wildcard $(CONFIG_FILE))")
$(error "Please run ./configure first")
endif

include $(CONFIG_FILE)

.PHONY: all
all: /home/$(USER)/.gitconfig clean

/home/$(USER)/.gitconfig: /home/$(USER)/.config/git/.gitconfig
	cp /home/$(USER)/.config/git/.gitconfig.default \
	/home/$(USER)/.config/git/.gitconfig.default.tmp
	sed -i "s|USER|$(USER)|" /home/$(USER)/.config/git/.gitconfig.default.tmp
	sed -i "s|EMAIL|$(EMAIL)|" /home/$(USER)/.config/git/.gitconfig.default.tmp
	sed -i "s|NAME|$(NAME)|" /home/$(USER)/.config/git/.gitconfig.default.tmp
	cp /home/$(USER)/.config/git/.gitconfig.default.tmp \
	/home/$(USER)/.gitconfig

.PHONY: clean
clean:
	-rm /home/$(USER)/.config/git/.gitconfig.default.tmp

.PHONY: hard_clean
hard_clean: clean
	-rm $(CONFIG_FILE)
