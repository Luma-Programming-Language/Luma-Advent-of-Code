LUMA = luma

STD = /usr/local/lib/luma/std
STD_LIBS = $(STD)/string.lx \
           $(STD)/memory.lx \
           $(STD)/time.lx \
           $(STD)/sys.lx \
           $(STD)/io.lx

.DEFAULT_GOAL := help

# Build only the requested .lx
%: %.lx
	@echo "Building '$@'..."
	$(LUMA) $@.lx -name $@ -l $(STD_LIBS)
	@echo "Build complete: $@"

# Build-and-run convenience: make run-<name>
.PHONY: run-%
run-%: %
	@echo "Running '$*'..."
	./$*

.PHONY: clean
clean:
	@echo "Cleaning..."
	rm -f *

.PHONY: help
help:
	@echo "Usage:"
	@echo "  make <name>        Build <name>.lx only"
	@echo "  make run-<name>    Build <name>.lx and run the binary"
	@echo ""
	@echo "Examples:"
	@echo "  make part_1"
	@echo "  make run-part_1"
