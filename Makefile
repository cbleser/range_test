.SUFFIXES:
.ONESHELL:

EMPTY=
SPACE=$(EMPTY) $(EMPTY)
ifdef ENV
PRECMD=@echo$(SPACE)
run: env
else
PRECMD=@
endif

DC?=$(shell which ldc2)

BIN:=.
MAIN:=range_test

DFILES+=$(addsuffix .d,$(MAIN))

DFLAGS+=-preview=dip1000

run-final-o: DFLAGS+=-O3
run-final: DFLAGS+=--d-version=FINAL

run-final-o: run-final

run-final: run

all:
	$(PRECMD)$(DC) $(DFLAGS) $(DFILES)

run: all
	$(PRECMD)$(BIN)/$(MAIN)


env:
	@echo DFILES=$(DFILES)
	@echo DFLAGS=$(DFLAGS)

clean:
	rm -f $(MAIN)
	rm -f *.o

