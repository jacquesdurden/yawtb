/* softcorr: Spherical Correlation on SO(3) of two functions in S^2
 *
 * The documentation is available in the corresponding M-file.
 *
 * \mansec{License}
 *
 * This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
 * You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
 *
 * $$
 *
 * Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with this library)
 * (See the notice at the end of the file.) */

/* Classical Libraries */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

/* Matlab Libraries */
#include <mex.h>
#include "matrix.h"

/* FFTW Library */
#include "fftw3.h"

/* SOFT Libraries */
#include "complex.h" 
#include "csecond.h"
#include "so3_correlate_fftw.h"
#include "soft_fftw.h"

/* MATLAB data definings */
/* Input data */

/* Fourier transform of the first and second functions */
/* The returning data are complex and defined on a grid LxL */
#define i_coeffs1 prhs[0] 
#define i_coeffs2 prhs[1] 
#define i_narg  2

/* Output data */

/* The SO(3) function of size (2L)^3 ! */
#define o_result   plhs[0] 

/* Extra */
#define DEBUG 0

/* Mexfunction == main(int argc, char **argv) */
void  mexFunction ( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])  
{
  int bw, bw2_1;
  double *rresult, *iresult, *rcoeffs1, *icoeffs1, *rcoeffs2, *icoeffs2;
  int result_dims[3];
  mxArray *dup_i_coeffs1, *dup_i_coeffs2;

  int i;
  int n, bwIn, bwOut, degLim ;
  double tstart, tstop ;
  fftw_complex *workspace1, *workspace2  ;
  REAL *workspace3 ;

  fftw_complex *so3Sig, *so3Coef ;
  fftw_plan p1 ;

  int na[2], inembed[2], onembed[2] ;
  int rank, howmany, istride, idist, ostride, odist ;

  /* ### 1. INITIALIZATIONS (+ input checkings) ### */

  if (nrhs != i_narg)
    {
      print_usage();
      return;
    }

  /* Bandwidth is set to the half of the number of rows in the data */
  bw = mxGetM(i_coeffs1);

  if (bw != mxGetM(i_coeffs2))
    {
      print_usage();
      mexPrintf("coeffs1 and coeffs2 must have the same bandwidth!\n");
      return;
    }

  if ( (mxGetN(i_coeffs1) != mxGetN(i_coeffs2)) ||
       (mxGetN(i_coeffs1) != bw ) )
    {
      print_usage();
      mexPrintf("coeffs1 and coeffs2 must square and with the same size!\n");
      return;
    }

  bw2_1 = bw*bw - 1;
 
  /* ### 2. MEMORY ALLOCATION (+ matlab pointers import) ### */

  if ( (! mxIsDouble(i_coeffs1) ) ||
       (! mxIsDouble(i_coeffs2) ) )
    {
      print_usage();
      mexErrMsgTxt("Error: input coeffs must be recorded as double (real or complex).");
    }

  /* Duplicate matlab input data for computation */
  /* mexPrintf("Duplicate matlab input data for computation\n"); */
  dup_i_coeffs1 = mxDuplicateArray(i_coeffs1);
  dup_i_coeffs2 = mxDuplicateArray(i_coeffs2);

  rcoeffs1 = mxGetPr(dup_i_coeffs1);
  icoeffs1 = mxGetPi(dup_i_coeffs1);

  rcoeffs2 = mxGetPr(dup_i_coeffs2);
  icoeffs2 = mxGetPi(dup_i_coeffs2);
  
  /* Transposing matrices for matlab matrix representation compatibility */
  mytranspose(rcoeffs1, bw);
  mytranspose(rcoeffs2, bw);

  if (icoeffs1 == NULL)
    {
      icoeffs1 = (double *) mxMalloc(sizeof(double) * bw * bw);
      for (i = bw2_1; i >= 0; icoeffs1[i] = 0, i--);
    }
  else
    {
      mytranspose(icoeffs1, bw);
    }

  if (icoeffs2 == NULL)
    {
      icoeffs2 = (double *) mxMalloc(sizeof(double) * bw * bw);
      for (i = bw2_1; i >= 0; icoeffs2[i] = 0, i--);
    }
  else
    {
      mytranspose(icoeffs2, bw);
    }

  /* Matlab outputs */
  result_dims[0] = result_dims[1]= result_dims[2] = 2*bw;
  o_result = mxCreateNumericArray(3, result_dims, mxDOUBLE_CLASS, mxCOMPLEX);
  rresult = mxGetPr(o_result);
  iresult = mxGetPi(o_result);

  for (i = 8*bw*bw*bw - 1; i >= 0; i--)
    {
      *(rresult + i) = *(iresult + i) = 0;
    }
  
  /* SOFT allocations */  

  bwIn = bw;
  bwOut = bw;
  degLim = bw - 1;

  n = 2 * bwIn ;

  /* mexPrintf("Some allocation\n"); */
  workspace3 = (REAL *) mxMalloc( sizeof(REAL) * (12*n + n*bwIn));

  /* mexPrintf("Some fftw allocation\n"); */
  so3Sig = fftw_malloc( sizeof(fftw_complex) * (8*bwOut*bwOut*bwOut) );
  so3Coef = fftw_malloc( sizeof(fftw_complex) * ((4*bwOut*bwOut*bwOut-bwOut)/3) ) ;
  
  workspace1 = fftw_malloc( sizeof(fftw_complex) * (8*bwOut*bwOut*bwOut) );
  workspace2 = fftw_malloc( sizeof(fftw_complex) * ((14*bwIn*bwIn) + (48 * bwIn)));


  /****
       At this point, check to see if all the memory has been
       allocated. If it has not, there's no point in going further.
  ****/

  if ( (so3Coef == NULL) || (so3Sig == NULL) ||
       (workspace1 == NULL) || (workspace2 == NULL) || (workspace3 == NULL) )
    {
      mexPrintf("Error in allocating memory");
      return;
    }


  /* create plan for inverse SO(3) transform */
  /* mexPrintf("create plan for inverse SO(3) transform\n"); */

  n = 2 * bwOut ;
  howmany = n*n ;
  idist = n ;
  odist = n ;
  rank = 2 ;
  inembed[0] = n ;
  inembed[1] = n*n ;
  onembed[0] = n ;
  onembed[1] = n*n ;
  istride = 1 ;
  ostride = 1 ;
  na[0] = 1 ;
  na[1] = n ;

  p1 = fftw_plan_many_dft( rank, na, howmany,
			   workspace1, inembed,
			   istride, idist,
			   so3Sig, onembed,
			   ostride, odist,
			   FFTW_FORWARD, FFTW_ESTIMATE );


  /* combine coefficients */
  /* mexPrintf("about to combine coefficients\n"); */

  so3CombineCoef_fftw( bwIn, bwOut, degLim,
		       rcoeffs1, icoeffs1,
		       rcoeffs2, icoeffs2,
		       so3Coef ) ;
  

  /* now inverse so(3) */
  /* mexPrintf("about to inverse so(3) transform\n"); */
  Inverse_SO3_Naive_fftw( bwOut,
			  so3Coef,
			  so3Sig,
			  workspace1,
			  workspace2,
			  workspace3,
			  &p1,
			  0 );

  /* now save data */
  /* mexPrintf("Now save data\n"); */
  for( i = 0 ; i < 8*bwOut*bwOut*bwOut ; i++ )
    {
      rresult[i] = so3Sig[i][0];
      iresult[i] = so3Sig[i][1];
    }

  /* mexPrintf("Now transpose 3D result\n"); */
  mytranspose3(rresult, 2*bw);
  mytranspose3(iresult, 2*bw);


  /* mexPrintf("Free memory\n"); */

  fftw_free( so3Coef );
  mxFree( workspace3 );
  fftw_free( workspace2 );
  fftw_free( workspace1 );
  fftw_free( so3Sig );

}


int print_usage()
{
  mexPrintf("Usage: so3_data = softcorr(data_sh_coeffs, filter_sh_coeffs)\n");
}


/* A simple function to transpose elements of matrix 'mat' of size n*n 
 * Optimizations: 
 *    - loop test are realized in comparison with 0;
 *    - use of temporary recorded position for quick matrix element selection */
int mytranspose(double* mat, int n)
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

/* Same effect than transpose() but for 3 dimensional square matrices 
 * We assume that the transposing occurs only on the 2D slices ! */
int mytranspose3(double* mat, int n)
{
  int i, k, j;
  int kn, n2, pos, tpos;
  double tmp;

  n2 = n*n;

  for( k = n-1; k >= 0; k--)
    {
      kn = k*n;

      for( i = n-1; i >= 0; i--)
  	{
	  for (j = i-1; j >= 0; j--)
	    {
	      tmp = *(mat + (pos=(i + kn + j*n2)));
	      *(mat + pos) = *(mat + (tpos=(j + kn + i*n2)));
	      *(mat + tpos) = tmp;
	    }
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
