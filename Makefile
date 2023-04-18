# ------------------------------------------------
# Windows/Linux Makefile
#
# Author: xahlicem@gmail.com
# Date  : 2022-11-30
#
# Changelog :
#   2022-11-30 - first version
# ------------------------------------------------

# project name (generate executable with this name)
TARGET   = pixel5-cc

ZIP      = zip
ZIPFLAGS   = -r -9

all: $(TARGET).zip

SOURCES    := $(wildcard *.sh) $(wildcard */*.sh) $(wildcard *.prop)

$(TARGET).zip: $(SOURCES)
	@$(ZIP) $(ZIPFLAGS) $@ $(SOURCES) META-INF
	@echo "zipping $@ complete!"

.PHONY: clean
clean:
	@rm -f $(TARGET).zip
	@echo "Cleanup complete!"