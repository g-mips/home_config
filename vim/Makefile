CONFIG = $(HOME)/.config/vim
CACHE = $(HOME)/.cache/vim

$(shell mkdir -p $(CONFIG))
$(shell mkdir -p $(CACHE))

.PHONY: all
all: package_loading $(CONFIG)/vimrc

.PHONY: package_loading
package_loading:
	-mkdir -p $(CONFIG)/bundle $(CONFIG)/autoload
	curl -LSso $(CONFIG)/autoload/pathogen.vim https://tpo.pe/pathogen.vim
	./clone-bundles.sh

$(CONFIG)/vimrc: vimrc
	@printf "Copying $? to $@\n"
	@-[ -f $@ ] && cp $@ $(CACHE)/vimrc.old || :
	cp $? $@
