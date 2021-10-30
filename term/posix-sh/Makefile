LOCAL_BIN := $(HOME)/.local/bin
SCRIPTS = $(wildcard suppliments/*.sh)
LOCAL_BIN_SCRIPTS = $(patsubst suppliments/%.sh, $(LOCAL_BIN)/%.sh, $(SCRIPTS))
CACHE = $(HOME)/.cache/posix-sh

$(shell mkdir -p $(CACHE))

.PHONY: all
all: $(HOME)/.profile $(LOCAL_BIN_SCRIPTS)

$(HOME)/.profile: profile.sh
	@printf "Installing $? to $@\n"
	-[ -f $@ ] && cp $@ $(CACHE)/.profile.old || :
	cp $? $@

$(LOCAL_BIN)/%.sh: suppliments/%.sh
	@printf "Installing $? to $@\n"
	cp $? $@

.PHONY: restore
restore:
	@printf "Restoring old .inputrc file from $(CACHE)/.profile.old\n"
	-[ -f $(CACHE)/.profile.old ] && cp $(CACHE)/.profile.old $(HOME)/.profile
