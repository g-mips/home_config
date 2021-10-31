include config.mk

define MAKE_RULE

.PHONY: $(1)
$(1):
	@printf '\033[0;32m   -- Installing $(1) configuration --\033[0m\n\n'
	@$(MAKE) -C $(1) all

.PHONY: restore_$(1)
restore_$(1):
	@printf '\033[0;32m   -- Restoring files in $(1) --\033[0m\n\n'
	@$(MAKE) -C $(1) restore
endef

.PHONY: all
all: $(CONFIG_EDITOR) term

.PHONY: restore
restore: $(CONFIG_EDITOR) term
