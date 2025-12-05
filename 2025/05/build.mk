LUMA = luma
NAME = main

MAIN = main.lx
SRCS = $(filter-out $(MAIN), $(wildcard *.lx))
STD = /usr/local/lib/luma/std

STD_LIBS = $(STD)/string.lx \
           $(STD)/memory.lx \
		   $(STD)/time.lx \
		   $(STD)/sys.lx \
		   $(STD)/io.lx 

ALL_SRCS = $(MAIN) $(SRCS) $(STD_LIBS)

EXE_EXT :=
RM := rm -f
MKDIR := mkdir -p build
SEP := ;
RUN_PREFIX := ./

TARGET = $(NAME)$(EXE_EXT)

.PHONY: all
all: $(TARGET)

$(TARGET): $(ALL_SRCS)
	@echo "Building..."
	$(LUMA) $(MAIN) -name $(NAME) -l $(SRCS) $(STD_LIBS)
	@echo "Build complete: $(TARGET)"

.PHONY: run
run: $(TARGET)
	@echo "Starting..."
	$(RUN_PREFIX)$(TARGET)

.PHONY: valgrind
valgrind: $(TARGET)
	@echo "Running valgrind..."
	valgrind --leak-check=full --show-leak-kinds=all ./$(TARGET)

.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	-$(RM) $(TARGET)
	-$(RM) obj\*.o 2>nul || true
	-$(RM) obj/*.o 2>/dev/null || true

.PHONY: rebuild
rebuild: clean all

.PHONY: list
list:
	@echo "Main file:"
	@echo "  $(MAIN)"
	@echo ""
	@echo "sources:"
	@for src in $(SRCS); do echo "  $$src"; done
	@echo ""
	@echo "Standard library:"
	@for lib in $(STD_LIBS); do echo "  $$lib"; done

.PHONY: help
help:
	@echo "Build System"
	@echo ""
	@echo "Build Targets:"
	@echo "  all        - Build the project (default)"
	@echo "  rebuild    - Clean and rebuild"
	@echo ""
	@echo "Run Targets:"
	@echo "  run        - Build and run"
	@echo "  valgrind   - Run with memory leak detection (Linux only)"
	@echo ""
	@echo "Development:"
	@echo "  list       - Show all source files"
	@echo "  clean      - Remove build artifacts"



