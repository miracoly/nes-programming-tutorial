CA = ca65
LD = ld65
EMU = fceux

#CAFLAGS =
LDFLAGS = -C nes.cfg
#EMUFLAGS =

.PHONY all:
all:
	@echo "TODO"

exercise_sources := $(wildcard exercises/*.s)
exercise_objects := $(exercise_sources:.s=.o)

exercise: $(exercise_objects)
	@echo "Building exercise .nes files"
	@$(MAKE) $(patsubst exercises/%.o, exercises/%.nes, $(exercise_objects))

exercises/%.nes: exercises/%.o
	@$(LD) $(LDFLAGS) $< -o $@

%.o: %.s
	@echo $@
	@$(CA) $(CAFLAGS) $< -o $@

nes-graphics.nes: nes-graphics.o nes.cfg
	@$(LD) $(LDFLAGS) nes-graphics/nes-graphics.o -o nes-graphics/nes-graphics.nes

nes-graphics.o: nes-graphics/nes-graphics.s
	@$(CA) $(CAFLAGS) nes-graphics/nes-graphics.s -o nes-graphics/nes-graphics.o

clearmem.nes: clearmem.o nes.cfg
	@$(LD) $(LDFLAGS) clearmem/clearmem.o -o clearmem/clearmem.nes

clearmem.o: clearmem/clearmem.s
	@$(CA) $(CAFLAGS) clearmem/clearmem.s -o clearmem/clearmem.o

.PHONY: clean
clean:
	rm -rf **/*.o **/*.out **/*.out.dSYM **/*.dbg **/*.nes