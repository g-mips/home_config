CACHE = $(HOME)/.cache/bash

$(shell mkdir -p $(CACHE))

define RESTORE_RULE

.PHONY: restore_$(1)
restore_$(1):
	@-[ -f $(CACHE)/.$(1).old ] && printf "Restoring old $(HOME)/.$(1) file from $(CACHE)/.$(1).old\n"
	-[ -f $(CACHE)/.$(1).old ] && cp $(CACHE)/.$(1).old $(HOME)/.$(1)

endef

.PHONY: all
all: $(HOME)/.bashrc $(HOME)/.bash_profile $(HOME)/.bash_logout
	@printf "Removing $(HOME)/.bash_login if exists"
	-[ -f $(HOME)/.bash_login ] && cp $(HOME)/.bash_login $(CACHE)/.bash_login.old || :
	@-rm -f $(HOME)/.bash_login

$(HOME)/.bashrc: bashrc.sh
	@printf "Copying $? to $@\n"
	-[ -f $@ ] && cp $@ $(CACHE)/.bashrc.old || :
	cp $? $@

$(HOME)/.bash_profile: bash_profile.sh
	@printf "Copying $? to $@\n"
	-[ -f $@ ] && cp $@ $(CACHE)/.bash_profile.old || :
	cp $? $@

$(HOME)/.bash_logout: bash_logout.sh
	@printf "Copying $? to $@\n"
	-[ -f $@ ] && cp $@ $(CACHE)/.bash_logout.old || :
	cp $? $@

.PHONY: restore
restore: restore_bashrc restore_bash_profile restore_bash_logout restore_bash_login

$(call RESTORE_RULE,bashrc)
$(call RESTORE_RULE,bash_profile)
$(call RESTORE_RULE,bash_logout)
$(call RESTORE_RULE,bash_login)
