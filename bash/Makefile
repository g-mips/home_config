BASE := $(shell dirname $(CURDIR))
ROOT = $(BASE)/bash
CACHE = $(XDG_CACHE_HOME)/bash

$(shell mkdir -p $(CACHE))

.PHONY: all
all: $(HOME)/.bashrc $(HOME)/.inputrc $(HOME)/.profile $(HOME)/.bash_profile $(HOME)/.bash_logout
	@echo "*** Getting rid of unnecessary files ***"
	-[ -f $(HOME)/.bash_login ] && cp $(HOME)/.bash_login $(CACHE)/.bash_login.old || :
	@-rm -f $(HOME)/.bash_login

$(HOME)/.bashrc: $(CACHE)/bashrc.default
	@echo "*** making $@ ***"
	-[ -f $@ ] && cp $@ $(CACHE)/.bashrc.old || :
	cp $(CACHE)/bashrc.default $(HOME)/.bashrc
	@echo "Please run '. $@' or close and reopen terminal"

$(HOME)/.inputrc: $(CACHE)/inputrc.default
	@echo "*** making $@ ***"
	-[ -f $@ ] && cp $@ $(CACHE)/.inputrc.old || :
	cp $(CACHE)/inputrc.default $(HOME)/.inputrc
	@echo "Please run 'bind -f $@' or close and reopen terminal"

$(HOME)/.profile: $(CACHE)/profile.default
	@echo "*** making $@ ***"
	-[ -f $@ ] && cp $@ $(CACHE)/.profile.old || :
	cp $(CACHE)/profile.default $(HOME)/.profile
	@echo "Please run '. $@' or close and reopen terminal"

$(HOME)/.bash_profile: $(ROOT)/.bash_profile
	@echo "*** making $@ ***"
	-[ -f $@ ] && cp $@ $(CACHE)/.bash_profile.old || :
	ln -f -s $(ROOT)/.bash_profile $@
	@echo "Please run '. $@' or close and reopen terminal"

$(HOME)/.bash_logout: $(ROOT)/.bash_logout
	@echo "*** making $@ ***"
	-[ -f $@ ] && cp $@ $(CACHE)/.bash_logout.old || :
	cp $(ROOT)/.bash_logout $@

.PHONY: clean
clean:
	-rm $(CACHE)/bashrc.default
	-rm $(CACHE)/inputrc.default
	-rm $(CACHE)/profile.default
