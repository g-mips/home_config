include config.mk

define MAKE_RULE

.PHONY: $(1)
$(1):
	@printf '\033[0;32m   -- Installing $(1) configuration --\033[0m\n\n'
	@$(MAKE) -C $(1) all

endef

.PHONY: all
all: $(SHELL) $(EMULATOR) $(MULTIPLEXER) $(OTHER)

$(foreach i,$(SHELL) $(EMULATOR) $(MULTIPLEXER) $(OTHER),$(eval $(call MAKE_RULE,$(i))))
