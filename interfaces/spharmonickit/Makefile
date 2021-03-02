#
# This Makefile is needed to compile all the file necessary to interface
# the SpharmonicKit with Matlab
#
############################################################################


# Directory where to find the .o and .h of SpharmonicKit
SKDIR = /users/fyma/wave/ljacques/matlab/misc/SpharmonicKit27

# Compiler
MEX = mex

# Flags for the MEX matlab compiler
MEXFLAGS = -cxx -I$(SKDIR)/

# FFTFLAGS = -L/net/puddleby/geelong/prcstmp/modified_fftpack -lfftpack
FFTFLAGS =

# for naive
NAIVEOBJ = $(SKDIR)/naive_synthesis.o $(SKDIR)/weights.o $(SKDIR)/csecond.o


# for semi-naive
SEMIOBJ = $(SKDIR)/OURperms.o $(SKDIR)/OURmods.o $(SKDIR)/newFCT.o $(SKDIR)/weights.o \
	$(SKDIR)/cospmls.o $(SKDIR)/seminaive.o $(SKDIR)/oddweights.o \
	$(SKDIR)/csecond.o $(SKDIR)/primitive.o

# for FLT_classic
FLTCLASSICOBJ = $(SKDIR)/OURperms.o $(SKDIR)/OURmods.o $(SKDIR)/weights.o \
	  $(SKDIR)/primitive.o $(SKDIR)/precomp_flt_classic.o \
	  $(SKDIR)/newFCT.o $(SKDIR)/flt_classic.o \
	  $(SKDIR)/csecond.o

# for FLT_dhmid
FLTDHMIDOBJ = $(SKDIR)/OURperms.o $(SKDIR)/OURmods.o $(SKDIR)/weights.o \
	  $(SKDIR)/primitive.o $(SKDIR)/precomp_flt_dhmid.o \
	  $(SKDIR)/newFCT.o $(SKDIR)/flt_dhmid.o \
	  $(SKDIR)/csecond.o

# for use with FLT_hybrid
FLTHYBRIDOBJ = $(SEMIOBJ) \
	$(SKDIR)/precomp_flt_hybrid.o $(SKDIR)/flt_hybrid.o 


# seminaive spherical transform and convolution
FSTSEMIOBJ = $(SEMIOBJ) $(SKDIR)/naive_synthesis.o \
	$(SKDIR)/primitive_FST.o $(SKDIR)/permroots.o $(SKDIR)/indextables.o $(SKDIR)/FFTcode.o \
	$(SKDIR)/fft_grids.o

CONVSEMIOBJ = $(FSTSEMIOBJ) $(SKDIR)/MathFace.o


# hybrid/seminaive spherical transform and convolution
FSTHYBRIDOBJ = $(FLTHYBRIDOBJ) \
	  $(SKDIR)/primitive_FST.o $(SKDIR)/permroots.o $(SKDIR)/indextables.o $(SKDIR)/FFTcode.o \
	  $(SKDIR)/fft_grids.o

FSTHYBRIDXOBJ = $(FLTHYBRIDOBJ) \
	  $(SKDIR)/primitive_FST.o $(SKDIR)/permroots.o $(SKDIR)/indextables.o $(SKDIR)/FFTcode.o \
	  $(SKDIR)/fft_grids.o

CONVHYBRIDOBJ = $(FSTHYBRIDOBJ) \
	  $(SKDIR)/MathFace.o


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
	skfst \
	skifst \
	convsph \
	writemath \
	readmath

clean: 
	rm *.o
	rm *.mexglx

# now the make definitions for the individual executables
skfst: skfst.o
	$(MEX) $(MEXFLAGS) \
	$(FSTSEMIOBJ) $(SKDIR)/FST_semi_fly.o skfst.o \
	$(FFTFLAGS) $(LDFLAGS) -o skfst

skifst: skifst.o
	$(MEX) $(MEXFLAGS) \
	$(FSTSEMIOBJ) $(SKDIR)/FST_semi_fly.o skifst.o \
	$(FFTFLAGS) $(LDFLAGS) -o skifst

convsph: convsph.o
	$(MEX) $(MEXFLAGS) \
	$(CONVHYBRIDOBJ) $(SKDIR)/FST_hybrid_memo.o convsph.o \
	$(FFTFLAGS) $(LDFLAGS) -o convsph

readmath: 
	$(MEX) $(MEXFLAGS) readmath.c $(SKDIR)/MathFace.o

writemath:
	$(MEX) $(MEXFLAGS) writemath.c $(SKDIR)/MathFace.o


# and now for LOTS OF dependencies ...

# DO NOT DELETE THIS LINE -- make depend depends on it.
convsph.o: 
	$(MEX) $(MEXFLAGS) -c convsph.c $(SKDIR)/FST_hybrid_memo.h \
	 $(SKDIR)/cospmls.h $(SKDIR)/precomp_flt_hybrid.h

skfst.o:
	$(MEX) $(MEXFLAGS) -c skfst.c $(SKDIR)/FST_semi_fly.h \
	$(SKDIR)/cospmls.h $(SKDIR)/csecond.h $(SKDIR)/seminaive.h $(SKDIR)/primitive_FST.h

skifst.o:
	$(MEX) $(MEXFLAGS) -c skifst.c $(SKDIR)/FST_semi_fly.h \
	$(SKDIR)/cospmls.h $(SKDIR)/csecond.h $(SKDIR)/seminaive.h $(SKDIR)/primitive_FST.h
