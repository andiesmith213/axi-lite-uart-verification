
export VERILATOR_VERSION=5.054

.PHONY: BUILD_VERILATOR CHECK_VERILATOR_INSTALL

BUILD_VERILATOR:
	echo $(VERILATOR_PATH)
	echo $(VERILATOR_VERSION)
	unset VERILATOR_ROOT
	cd $(VERILATOR_PATH) && \
    git checkout v$(VERILATOR_VERSION) && \
    autoconf && \
    ./configure && \
    make && \
    sudo make install
	$(MAKE) CHECK_VERILATOR_INSTALL

CHECK_VERILATOR_INSTALL:
	@verilator_path="$$(command -v verilator)"; \
    if [ -n "$$verilator_path" ]; then \
        echo "Verilator was successfully installed at $$verilator_path"; \
    else \
        echo "There was a problem installing Verilator" >&2; \
        exit 1; \
    fi