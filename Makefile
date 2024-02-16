PKGSRC  := $(shell basename `pwd`)
RM = rm -rf
RCMD = R --vanilla CMD
RSCRIPT = Rscript --vanilla

all: sysdata clean

sysdata:
	@ $(RSCRIPT) create-lref-sysdata.R

clean:
	@ git clean -dfn
