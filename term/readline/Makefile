CACHE = $(HOME)/.cache/readline
CONFIG = $(HOME)/.config/readline

.PHONY: all
all: $(CONFIG)/inputrc.conf

$(shell mkdir -p $(CACHE))
$(shell mkdir -p $(CONFIG))

$(CONFIG)/inputrc.conf: inputrc.conf
	@printf "Copying $? to $@\n"
	@-[ -f $@ ] && cp $@ $(CACHE)/inputrc.conf.old || :
	cp $? $@

.PHONY: restore
restore:
	@printf "Restoring old inputrc.conf file from $(CACHE)/inputrc.conf.old\n"
	-[ -f $(CACHE)/inputrc.conf.old ] && cp $(CACHE)/inputrc.conf.old $(CONFIG)/inputrc.conf
