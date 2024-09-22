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

ifdef DMD
DC?=$(shell which dmd)
OPT=-O
FINAL=-version=FINAL
else
DC?=$(shell which ldc2)
OPT=-O3
FINAL=--d-version=FINAL
endif


BIN:=.
MAIN:=range_test

DFILES+=$(addsuffix .d,$(MAIN))

DFLAGS+=-preview=dip1000

run-final-o: DFLAGS+=$(OPT)
run-final: DFLAGS+=$(FINAL)
run-o: DFLAGS+=$(OPT)

run-final-o: run-final

run-final: run

run-o: run

all:
	$(PRECMD)$(DC) $(DFLAGS) $(DFILES)

run: all
	$(PRECMD)echo
	$(PRECMD)$(DC) --version|head -1
	$(PRECMD)$(BIN)/$(MAIN)


env:
	@echo DFILES=$(DFILES)
	@echo DFLAGS=$(DFLAGS)

clean:
	@rm -f $(MAIN)
	@rm -f *.o

