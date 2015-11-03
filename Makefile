FUNCTIONS_SRC := rvm.fish
FUNCTIONS_DST := ~/.config/fish/config/rvm.fish
PATCH_TARGET := ~/.config/fish/config.fish
PATCH_DIFF := config.fish.patch


PHONY += default
default:
	@echo 1>&2 "Usage: make install|uninstall"


install: functions patch

uninstall: unfunctions


PHONY += functions
functions: $(FUNCTIONS_DST)

$(FUNCTIONS_DST): $(FUNCTIONS_SRC)
	dirname $@ | xargs mkdir -p
	cp $< $@

PHONY += unfunctions
unfunctions:
	rm -f -- $(FUNCTIONS_DST)



PHONY += patch
patch: $(PATCH_DIFF)
	touch $(PATCH_TARGET)
	@patch -NRsr /dev/null --dry-run <$< $(PATCH_TARGET) >/dev/null || $(MAKE) force-patch

PHONY += force-patch
force-patch: $(PATCH_DIFF)
	patch -Nsr /dev/null <$< $(PATCH_TARGET)

PHONY += unpatch
unpatch: $(PATCH_DIFF)
	@patch -NRsr /dev/null --dry-run <$< $(PATCH_TARGET) >/dev/null && $(MAKE) force-unpatch || true

PHONY += force-unpatch
force-unpatch:
	patch -NRsr /dev/null <$(PATCH_DIFF) $(PATCH_TARGET)



.PHONY: $(PHONY)
