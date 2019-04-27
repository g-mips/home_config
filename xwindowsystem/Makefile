BASE := $(shell dirname $(CURDIR))
ROOT = $(BASE)/xwindowsystem

.PHONY: all
all: $(HOME)/.Xresources clean

$(HOME)/.Xresources: $(ROOT)/.Xresources $(ROOT)/.Xresources.default
	cp $(ROOT)/.Xresources.default $(ROOT)/.Xresources.default.tmp
	sed -i "s|BASE|$(BASE)|" $(ROOT)/.Xresources.default.tmp
	cp $(ROOT)/.Xresources.default.tmp $(HOME)/.Xresources
	xrdb $(HOME)/.Xresources

.PHONY: clean
clean:
	-rm $(ROOT)/.Xresources.default.tmp
