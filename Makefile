CACHE     := $(HOME)/.cache
CONFIG    := $(HOME)/.config

HOME_FILES             := $(wildcard home/*)
HOME_CONFIG_FILES      := $(filter-out %_configure.sh,$(wildcard config_home/*))
HOME_REMOVE_FILES      := bash_login Xresources gitconfig inputrc tmux.conf vimrc

CONFIG_FILES           := $(wildcard config/*/*)
CONFIG_CONFIG_FILES    := $(filter-out %_configure.sh,$(wildcard config_config/*/*))
CONFIG_REMOVE_FILES    :=

LOCAL_BIN_FILES        := $(wildcard local/bin/*.sh)
LOCAL_BIN_CONFIG_FILES := $(filter-out %_configure.sh,$(wildcard config_local/bin/*.sh))

.PHONY: all
all: remove just_copy configure_and_copy

.PHONY: just_copy
just_copy: $(patsubst home/%,$(HOME)/.%,$(HOME_FILES)) \
	$(patsubst %,$(HOME)/.%,$(CONFIG_FILES) $(LOCAL_BIN_FILES)) \

.PHONY: configure_and_copy
configure_and_copy: $(patsubst config_home/%,$(HOME)/.%,$(HOME_CONFIG_FILES)) \
	$(patsubst config_%,$(HOME)/.%,$(CONFIG_CONFIG_FILES) $(LOCAL_BIN_CONFIG_FILES))

.PHONY: remove
remove: $(patsubst %,remove_%,$(HOME_REMOVE_FILES) $(CONFIG_REMOVE_FILES))

.PHONY: restore
restore: $(patsubst %,restore_%,$(HOME_FILES) $(HOME_REMOVE_FILES) \
	$(CONFIG_FILES) $(CONFIG_CONFIG_FILES) $(LOCAL_BIN_FILES) \
	$(LOCAL_BIN_CONFIG_FILES))

define MAKE_COPY_RULE

ifeq "$(4)" "t"
# Remove rule
.PHONY: remove_$(2)
remove_$(2):
	@[ -f $(1) ] && printf "REMOVE  $(1)\n" || true
	@[ -f $(1) ] && rm $(1) || true
else
ifeq "$(3)" "t"
$(CACHE)/$(2)_extra: $(2)_configure.sh
	@printf "EXEC    $(2)_configure.sh\n"
	@./$(2)_configure.sh
endif

# Save and copy rule
ifeq "$(3)" "t"
$(1): $(2) $(CACHE)/$(2)_extra
else
$(1): $(2)
endif
	@[ ! -d `dirname $$@` ] && printf "MKDIR   `dirname $$@`\n" || true
	@[ ! -d `dirname $$@` ] && mkdir -p `dirname $$@` || true
	@[ ! -d `dirname $$(CACHE)/$$<` ] && printf "MKDIR   `dirname $$(CACHE)/$$<`\n" || true
	@[ ! -d `dirname $$(CACHE)/$$<` ] && mkdir -p `dirname $$(CACHE)/$$<` || true
	@[ -f $$@ ] && printf "SAVE    $$@ $$(CACHE)/$$<.old\n" || true
	@[ -f $$@ ] && cp $$@ $(CACHE)/$$<.old || true
	@printf "CP      $$< $$@\n"
	@cp $$< $$@
ifeq "$(3)" "t"
	@printf "CAT     $(CACHE)/$(2)_extra >> $$@\n"
	@cat $(CACHE)/$(2)_extra >> $$@
endif
endif

# Restore rule
.PHONY: restore_$(2)
restore_$(2):
	@[ -f $$(CACHE)/$(2).old ] && printf "RESTORE $$(CACHE)/$(2).old to $(1)\n" || printf "SKIP    $$(CACHE)/$(2).old\n"
	@[ -f $$(CACHE)/$(2).old ] && cp $$(CACHE)/$(2).old $(1) || true

endef

# Files found in home directory
$(foreach i,$(HOME_FILES),$(eval $(call MAKE_COPY_RULE,$(patsubst home/%,$(HOME)/.%,$(i)),$(i),f,f)))
$(foreach i,$(HOME_CONFIG_FILES),$(eval $(call MAKE_COPY_RULE,$(patsubst config_home/%,$(HOME)/.%,$(i)),$(i),t,f)))
$(foreach i,$(HOME_REMOVE_FILES),$(eval $(call MAKE_COPY_RULE,$(HOME)/.$(i),$(i),f,t)))

# Files found in .config directory
$(foreach i,$(CONFIG_FILES),$(eval $(call MAKE_COPY_RULE,$(HOME)/.$(i),$(i),f,f)))
$(foreach i,$(CONFIG_CONFIG_FILES),$(eval $(call MAKE_COPY_RULE,$(patsubst config_%,$(HOME)/.%,$(i)),$(i),t,f)))
$(foreach i,$(CONFIG_REMOVE_FILES),$(eval $(call MAKE_COPY_RULE,$(CONFIG)/$(i),$(i),f,t)))

# Files found in the .local/bin directory
$(foreach i,$(LOCAL_BIN_FILES),$(eval $(call MAKE_COPY_RULE,$(HOME)/.$(i),$(i),f,f)))
