#
# This Makefile is needed to compile all the file necessary to interface
# the SOFT (http://www.cs.dartmouth.edu/~geelong/soft/index.html) with Matlab
#
############################################################################

# Directory where to find the .o and .h of SOFT
SOFTDIR = /users/fyma/wave/ljacques/matlab/misc/soft-1.0

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
MEXFLAGS = -cxx -I$(SOFTDIR)/ ${FFTWINC}

LDFLAGS = -lm

# LOT OF DEPENDENCIES

GENWIGOBJ = $(SOFTDIR)/utils_so3.o $(SOFTDIR)/makeWigner.o

WIGFFTWOBJ = $(GENWIGOBJ) $(SOFTDIR)/weights.o \
	$(SOFTDIR)/utils_vec_cx.o $(SOFTDIR)/wignerTransforms_fftw.o

SOFTFFTW2OBJ = $(WIGFFTWOBJ) $(SOFTDIR)/soft_fftw.o $(SOFTDIR)/indextables.o \
	$(SOFTDIR)/permroots.o $(SOFTDIR)/FFTcode.o $(SOFTDIR)/fft_grids_so3.o \

COR2FFTWOBJ = $(SOFTFFTW2OBJ) $(SOFTDIR)/primitive_FST.o $(SOFTDIR)/so3_correlate_fftw.o \
	$(SOFTDIR)/OURperms.o $(SOFTDIR)/OURmods.o $(SOFTDIR)/newFCT.o $(SOFTDIR)/cospmls.o \
	$(SOFTDIR)/seminaive.o $(SOFTDIR)/oddweights.o \
	$(SOFTDIR)/primitive.o $(SOFTDIR)/FST_semi_memo.o $(SOFTDIR)/fft_grids.o \
	$(SOFTDIR)/naive_synthesis.o


###################################################################
##################################################################
######
######              things that can be made
######
##################################################################
##################################################################

# first some shortcuts

all:	matlab

matlab:	softcorr

clean: 
	rm *.o *.mexglx

# now the make definitions for the individual executables
softcorr: softcorr.o
	$(MEX) $(MEXFLAGS) $(COR2FFTWOBJ) $(SOFTDIR)/csecond.o softcorr.o \
	${FFTWLIB} $(LDFLAGS) -o softcorr

# and now for LOTS OF dependencies ...

# DO NOT DELETE THIS LINE -- make depend depends on it.
softcorr.o: 
	$(MEX) $(MEXFLAGS) -c softcorr.c ${FFTWLIB} $(LDFLAGS)
