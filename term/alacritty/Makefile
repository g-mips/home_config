CACHE = $(HOME)/.cache/alacritty
CONFIG = $(HOME)/.config/alacritty
CONFIG_FILE = alacritty.yml

.PHONY: all
all: $(CONFIG)/$(CONFIG_FILE)

$(shell mkdir -p $(CACHE))
$(shell mkdir -p $(CONFIG))

$(CONFIG)/$(CONFIG_FILE): $(CONFIG_FILE)
	@printf "Copying $? to $@\n"
	@-[ -f $@ ] && cp $@ $(CACHE)/$(CONFIG_FILE).old || :
	cp $? $@

.PHONY: restore
restore:
	@printf "Restoring old $(CONFIG)/$(CONFIG_FILE) file from $(CACHE)/$(CONFIG_FILE).old\n"
	-[ -f $(CACHE)/$(CONFIG_FILE).old ] && cp $(CACHE)/$(CONFIG_FILE).old $(CONFIG)/$(CONFIG_FILE)
