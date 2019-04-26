.PHONY: all
all: load_xresources clean

load_xresources: /home/$(USER)/.config/xwindowsystem/.Xresources
	cp /home/$(USER)/.config/xwindowsystem/.Xresources.default /home/$(USER)/.config/xwindowsystem/.Xresources.default.tmp
	sed -i "s|USER|$(USER)|" /home/$(USER)/.config/xwindowsystem/.Xresources.default.tmp
	cp /home/$(USER)/.config/xwindowsystem/.Xresources.default.tmp /home/$(USER)/.Xresources
	xrdb /home/$(USER)/.Xresources

.PHONY: clean
clean:
	rm /home/$(USER)/.config/xwindowsystem/.Xresources.default.tmp
