DC?=$(shell which ldc2)

BIN:=./
MAIN:=range_test

DFILES+=$(addsuffix .d,$(MAIN))

DFLAGS+=-preview=dip1000

all:
	@$(DC) $(DFLAGS) $(DFILES)


run: all
	$(BIN)/$(MAIN)


env:
	@echo DFILES=$(DFILES)

clean:
	rm -f $(MAIN)
	rm -f *.o

