BASE := $(shell dirname $(CURDIR))
ROOT = $(BASE)/vim

.PHONY: all
all: package_loading load_vim clean

.PHONY: package_loading
package_loading:
	-mkdir -p $(HOME)/.vim/bundle $(HOME)/.vim/autoload
	curl -LSso $(HOME)/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
	./clone-bundles.sh


load_vim: $(ROOT)/.vimrc $(ROOT)/.vimrc.default
	cp $(ROOT)/.vimrc.default $(ROOT)/.vimrc.default.tmp
	sed -i 's|BASE|$(BASE)|' $(ROOT)/.vimrc.default.tmp
	cp $(ROOT)/.vimrc.default.tmp $(HOME)/.vimrc

.PHONY: clean
clean:
	-rm $(ROOT)/.vimrc.default.tmp
