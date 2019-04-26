.PHONY: all
all: load_vim clean

load_vim: /home/$(USER)/.config/vim/.vimrc
	cp /home/$(USER)/.config/vim/.vimrc.default /home/$(USER)/.config/vim/.vimrc.default.tmp
	sed -i 's|USER|$(USER)|' /home/$(USER)/.config/vim/.vimrc.default.tmp
	cp /home/$(USER)/.config/vim/.vimrc.default.tmp /home/$(USER)/.vimrc

.PHONY: clean
clean:
	rm /home/$(USER)/.config/vim/.vimrc.default.tmp
