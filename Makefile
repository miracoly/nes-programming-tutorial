CA = ca65
LD = ld65
EMU = fceux

CAFLAGS = -g

LDFLAGS = -Ln $@.0
LDFLAGS += -C nes.cfg

.PHONY all:
all: main.nes

main.nes: main.o nes.cfg
	@echo "Link main.nes"
	@$(LD) $(LDFLAGS) main.o -o main.nes
	@echo "Start converting symbols"
	@ca65-symbls-to-nl --file $@.0 && rm $@.0
	@echo "Success!"

main.o: main.s
	@echo "Build main.o"
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
	rm -rf *.o **/*.o *.out **/*.out **/*.out.dSYM *.dbg **/*.dbg *.nes **/*.nes *.nes.* **/*.nes.*