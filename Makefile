CA = ca65
LD = ld65
EMU = fceux

#CAFLAGS =
LDFLAGS = -C nes.cfg
#EMUFLAGS =

.PHONY all:
all: main.o nes.cfg
	@$(LD) $(LDFLAGS) main.o -o main.nes

main.o: main.s
	@$(CA) $(CAFLAGS) main.s -o main.o

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

.PHONY: clean
clean:
	rm -rf **/*.o **/*.out **/*.out.dSYM **/*.dbg **/*.nes