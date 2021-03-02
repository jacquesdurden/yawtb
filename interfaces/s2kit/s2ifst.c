/* s2ifst: fast spherical transform
 *
 * The documentation is available in the corresponding M-file.
 *
 * \mansec{License}
 *
 * This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
 * You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
 *
 * $Header: /home/cvs/yawtb/interfaces/s2kit/s2ifst.c,v 1.2 2004-11-22 17:02:28 ljacques Exp $
 *
 * Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with this library)
 * (See the notice at the end of the file.) */

/* Classical Libraries */
#include <errno.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

/* Matlab Libraries */
#include <mex.h>
#include "matrix.h"

/* FFTW Library */
#include "fftw3.h"

/* S2KIT Libraries */
#include "makeweights.h"
#include "FST_semi_fly.h"
#include "csecond.h"

#define max(A, B) ((A) > (B) ? (A) : (B))

/* MATLAB data definings */
/* Input data */

#define i_coeffs   prhs[0] 
#define i_narg  1

/* Output data */

#define o_result   plhs[0] 

/**************************************************************/
/**************************************************************/

/* Mexfunction == main(int argc, char **argv) */
void  mexFunction ( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])  
{
  int i, bw, bw2_1, size;
  int cutoff ;
  int rank, howmany_rank ;
  double *rresult, *iresult, *rcoeffs, *icoeffs;
  double *workspace, *weights;

  fftw_plan idctPlan;
  fftw_plan ifftPlan;
  fftw_iodim dims[1], howmany_dims[1];

  mxArray *dup_i_coeffs;


  /* ### 1. INITIALIZATIONS (+ input checkings) ### */

  if (nrhs != i_narg)
    {
      print_usage();
      return;
    }

  /* Bandwidth is set to the half of the number of rows in the data */
  bw = mxGetM(i_coeffs);
  bw2_1 = bw*bw - 1;
  size = 2*bw;

  /*** ASSUMING WILL SEMINAIVE ALL ORDERS ***/
  cutoff = bw ; 

  /* coeffs must be square */
  if (bw != mxGetN(i_coeffs))
    {
      print_usage();
      mexErrMsgTxt("Error: coeffs must be a square matrix.");
    }


  /* ### 2. MEMORY ALLOCATION (+ matlab pointers import) ### */

  /* Duplicate matlab data for computation */
  if (! mxIsDouble(i_coeffs) ) 
    {
      print_usage();
      mexErrMsgTxt("Error: input coeffs must be recorded as double (real or complex).");
    }

  /* Duplicate matlab input data for computation */
  dup_i_coeffs = mxDuplicateArray(i_coeffs);
  rcoeffs = mxGetPr(dup_i_coeffs);
  icoeffs = mxGetPi(dup_i_coeffs);
  
  /* Transposing matrices for matlab matrix representation compatibility */
  transpose(rcoeffs, bw);

  if (icoeffs == NULL)
    {
      icoeffs = (double *) mxMalloc(sizeof(double) * bw * bw);
      for (i = bw2_1; i >= 0; icoeffs[i] = 0, i--);
    }
  else
    {
      transpose(icoeffs, bw);
    }

  /* Matlab outputs */
  o_result = mxCreateDoubleMatrix (size, size, mxCOMPLEX);
  rresult = mxGetPr(o_result);
  iresult = mxGetPi(o_result);
  
  /* S2kit allocations */
  workspace = (double *) mxMalloc(sizeof(double) * 
				  ((10 * (bw*bw)) + 
				   (24 * bw)));

  /* make array for weights */
  weights = (double *) malloc(sizeof(double) * 4 * bw);


  /****
    At this point, check to see if all the memory has been
    allocated. If it has not, there's no point in going further.
    ****/
  if ( (rcoeffs == NULL) || (icoeffs == NULL) ||
       (rresult == NULL) || (iresult == NULL) ||
       (workspace == NULL) || (weights == NULL) )
    {
      mexErrMsgTxt("Error in allocating memory");
    }

  /*
    construct fftw plans
  */

  /* make DCT plans -> note that I will be using the GURU
     interface to execute these plans within the routines*/

  /* inverse DCT */
  idctPlan = fftw_plan_r2r_1d( 2*bw, weights, rresult,
			       FFTW_REDFT01, FFTW_ESTIMATE );
      
  /*
    now plan for inverse fft - note that this plans assumes
    that I'm working with a transposed array, e.g. the inputs
    for a length 2*bw transform are placed every 2*bw apart,
    the output will be consecutive entries in the array
  */
  rank = 1 ;
  dims[0].n = 2*bw ;
  dims[0].is = 2*bw ;
  dims[0].os = 1 ;
  howmany_rank = 1 ;
  howmany_dims[0].n = 2*bw ;
  howmany_dims[0].is = 1 ;
  howmany_dims[0].os = 2*bw ;

  /* inverse fft */
  ifftPlan = fftw_plan_guru_split_dft( rank, dims,
				       howmany_rank, howmany_dims,
				       rresult, iresult,
				       workspace, workspace+(4*bw*bw),
				       FFTW_ESTIMATE );
  
  /* now make the weights */
  makeweights( bw, weights );


  /* ### 3. Fast Inverse Spherical Transform Computation ### */
  InvFST_semi_fly(rcoeffs, icoeffs,
		  rresult, iresult,
		  bw,
		  workspace,
		  0,
		  cutoff,
		  &idctPlan,
		  &ifftPlan );

  /* destroy fftw plans */
  fftw_destroy_plan( ifftPlan );
  fftw_destroy_plan( idctPlan );

  transpose(rresult, size);
  if (iresult != NULL)
    {
      transpose(iresult, size);
    }

}

int print_usage()
{
  mexPrintf("Usage: sph_data = s2ifst(sph_harm_coeff)\n");
}

/* A simple function to transpose elements of matrix 'mat' of size n*n 
 * Optimizations: 
 *    - loop test are realized in comparison with 0;
 *    - use of temporary recorded position for quick matrix element selection */
int transpose(double* mat, int n)
{
  int i, j, pos, tpos;
  double tmp;

  for( i = n-1; i >= 0; i--)
    {
      for (j = i-1; j >= 0; j--)
	{
	  tmp = *(mat + (pos=(i + n*j)));
	  *(mat + pos) = *(mat + (tpos=(j + n*i)));
	  *(mat + tpos) = tmp;
	}
    }
}

/*  This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
