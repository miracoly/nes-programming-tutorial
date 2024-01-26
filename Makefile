CA = ca65
LD = ld65

#CAFLAGS =

LDFLAGS = -C nes.cfg

.PHONY all:
all:
	@echo "TODO"

clearmem.nes: clearmem.o
	@$(LD) $(LDFLAGS) clearmem/clearmem.o -o clearmem/clearmem.nes

clearmem.o: clearmem/clearmem.s
	@$(CA) $(CAFLAGS) clearmem/clearmem.s -o clearmem/clearmem.o

.PHONY: clean
clean:
	rm -rf **/*.o **/*.out **/*.out.dSYM **/*.dbg **/*.nes