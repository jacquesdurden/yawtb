#
# This Makefile is needed to compile all the file necessary to interface
# the SpharmonicKit with Matlab
#
############################################################################

# Directory where to find the .o and .h of S2kit
SKDIR = /users/fyma/wave/ljacques/matlab/misc/s2kit10

# define WALLCLOCK on the CFLAGS line if want to time
# walltime and not cpu time (cpu time is default); also
# define optimization flags suitable for your platform

# define for fftw
## FFTWINC = -I/net/misc/geelong/local/linux/include
## FFTWLIB = -L/net/misc/geelong/local/linux/lib -lfftw3
FFTWINC = 
FFTWLIB = -lfftw3

# Mex Compiler
MEX = mex

# Flags for the MEX matlab compiler
MEXFLAGS = -cxx -I$(SKDIR)/ ${FFTWINC}

LDFLAGS = -lm

# for semi-naive
SEMIOBJ = $(SKDIR)/pmls.o $(SKDIR)/cospmls.o $(SKDIR)/seminaive.o \
	$(SKDIR)/csecond.o $(SKDIR)/primitive.o $(SKDIR)/makeweights.o

# seminaive spherical transform and convolution
FSTSEMIOBJ = $(SEMIOBJ) $(SKDIR)/naive_synthesis.o

CONVSEMIOBJ = $(FSTSEMIOBJ)


###################################################################
##################################################################
######
######              things that can be made
######
##################################################################
##################################################################

# first some shortcuts

all:
	make \
	matlab

matlab:
	make \
	s2fst \
	s2ifst

clean: 
	rm *.o *.mexglx

# now the make definitions for the individual executables
s2fst: s2fst.o
	$(MEX) $(MEXFLAGS) $(FSTSEMIOBJ) $(SKDIR)/FST_semi_fly.o s2fst.o \
	${FFTWLIB} $(LDFLAGS) -o s2fst

s2ifst: s2ifst.o
	$(MEX) $(MEXFLAGS) $(FSTSEMIOBJ) $(SKDIR)/FST_semi_fly.o s2ifst.o \
	${FFTWLIB} $(LDFLAGS) -o s2ifst

# and now for LOTS OF dependencies ...

# DO NOT DELETE THIS LINE -- make depend depends on it.

s2fst.o: 
	$(MEX) $(MEXFLAGS) -c s2fst.c -lm -lfftw3 ${FFTWLIB} $(LDFLAGS)

s2ifst.o: 
	$(MEX) $(MEXFLAGS) -c s2ifst.c -lm -lfftw3 ${FFTWLIB} $(LDFLAGS)
