ROOT := $(shell echo $(CURDIR))

.PHONY: all
all: $(HOME)/.Xresources clean

$(HOME)/.Xresources: $(ROOT)/.Xresources
	cp $(ROOT)/.Xresources.default $(ROOT)/.Xresources.default.tmp
	sed -i "s|USER|$(USER)|" $(ROOT)/.Xresources.default.tmp
	cp $(ROOT)/.Xresources.default.tmp $(HOME)/.Xresources
	xrdb $(HOME)/.Xresources

.PHONY: clean
clean:
	-rm $(ROOT)/.Xresources.default.tmp
