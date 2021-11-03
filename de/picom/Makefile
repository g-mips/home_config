CONFIG = $(HOME)/.config/picom
CACHE = $(HOME)/.cache/picom

$(shell mkdir -p $(CONFIG))
$(shell mkdir -p $(CACHE))

.PHONY: all
all: $(CONFIG)/picom.conf

$(CONFIG)/picom.conf: picom.conf
	@printf "Copying $? to $@\n"
	@-[ -f $@ ] && cp $@ $(CACHE)/$?.old || :
	cp $? $@

.PHONY: restore
restore:
	@-[ -f $(CACHE)/picom.conf.old ] && printf "Restoring old $(CONFIG)/picom.conf file from $(CACHE)/picom.conf.old\n"
	-[ -f $(CACHE)/picom.conf.old ] && cp $(CACHE)/picom.conf.old $(CONFIG)/picom.conf
