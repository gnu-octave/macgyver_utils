# handcrafted Makefile

TARGETS = grab.oct peakdet.oct crc16.oct

all: $(TARGETS)

%.oct: %.cc
	mkoctfile -v $^

clean:
	rm -f $(TARGETS) *.o
