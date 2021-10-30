CACHE = $(HOME)/.cache/readline

.PHONY: all
all: $(HOME)/.inputrc

$(shell mkdir -p $(CACHE))

$(HOME)/.inputrc: inputrc.readline
	@printf "Copying $? to $@\n"
	-[ -f $@ ] && cp $@ $(CACHE)/.inputrc.old || :
	cp $? $@

.PHONY: restore
restore:
	@printf "Restoring old .inputrc file from $(CACHE)/.inputrc.old\n"
	-[ -f $(CACHE)/.inputrc.old ] && cp $(CACHE)/.inputrc.old $(HOME)/.inputrc
