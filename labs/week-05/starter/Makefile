# The forge -- Work Order No. 1851-05, twin-looms.
#
#   make            cast twin-looms
#   make clean      break up the casting
#
# -pthread links the two looms; -Wall -Wextra keep the compiler talking.
# No -O flag, on purpose: this week the race depends on the increment
# staying exactly as slow, and exactly as visible, as it is written.

CC     = gcc
CFLAGS = -Wall -Wextra -pthread

all: twin-looms

twin-looms: twin-looms.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f twin-looms

.PHONY: all clean
