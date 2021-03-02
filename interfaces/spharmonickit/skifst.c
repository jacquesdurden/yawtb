/* skifst: inverse fast spherical transform (Spharmonic Kit Implementation)
 *
 * The documentation is available in the corresponding M-file.
 *
 * \mansec{License}
 *
 * This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
 * You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
 *
 * $Header: /home/cvs/yawtb/interfaces/spharmonickit/skifst.c,v 1.1 2007-10-09 07:40:13 jacques Exp $
 *
 * Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with this library)
 * (See the notice at the end of the file.) */

/* Classical Libraries */
#include <errno.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/* Matlab Libraries */
#include <mex.h>
#include "matrix.h"

/* SpharmonicKit Libraries */
#include "FST_semi_fly.h"
#include "cospmls.h"
#include "csecond.h"
#include "primitive_FST.h"
#include "seminaive.h"

#define max(A, B) ((A) > (B) ? (A) : (B))

/**************************************************************/
/**************************************************************/

/* Input data */

#define i_coeffs   prhs[0] 
#define i_narg  1

/* Output data */

#define o_result   plhs[0] 

/* Mexfunction == main(int argc, char **argv) */
void  mexFunction ( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])  
{
  int i;
  int bw, bw2_1, size, size2_1, cutoff;
  double *rcoeffs, *icoeffs, *rresult, *iresult;
  double *CosPmls, *workspace;
  mxArray *dup_i_coeffs;

  /* ### 1. INITIALIZATIONS (+ input checkings) ### */
  if (nrhs != i_narg)
    {
      print_usage();
      return;
    }

  /* Bandwidth is equal to the number of rows in the input coeffs */
  bw = mxGetM(i_coeffs);
  bw2_1 = bw*bw - 1;
  size = 2*bw;
  size2_1 = size*size - 1;
  cutoff = bw; /* => assuming will seminaive all orders */

  /* LIMITATION: Bandwidth must be greater than 4 */
  if (bw < 4)
    {
      print_usage();
      mexErrMsgTxt("Error: Bandwidth must be greater than 4.");
    } 
  
  /* coeffs must be square */
  if (bw != mxGetN(i_coeffs))
    {
      print_usage();
      mexErrMsgTxt("Error: coeffs must be a square matrix.");
    }

  /* Size must be a power of 2 */
  if ((floor(log(bw)/log(2))) != (log(bw)/log(2)))
    {
      print_usage();
      mexErrMsgTxt("Error: the size of coeffs must be a power of 2.");
    } 

  /* ### 2. MEMORY ALLOCATION (+ matlab pointers import) ### */

  /* Duplicate matlab data for computation */
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

  CosPmls = (double *) mxMalloc(sizeof(double) * TableSize(0,bw) * 2);
  
  workspace = (double *) mxMalloc(sizeof(double) * 
				  ((8 * (bw*bw)) + 
				   (40 * bw)));

  /****
       At this point, check to see if all the memory has been
       allocated. If it has not, there's no point in going further.
  ****/
  
  if ( (rcoeffs == NULL) || (icoeffs == NULL) ||
       (rresult == NULL) || (iresult == NULL) ||
       (workspace == NULL) || (CosPmls == NULL) )
    {
      mexErrMsgTxt("Error in allocating memory");
    }

  InvFST_semi_fly(rcoeffs,icoeffs,
		  rresult, iresult,
		  size,
		  CosPmls,
		  workspace,
		  0,
		  cutoff);    

  transpose(rresult, size);
  if (iresult != NULL)
    {
      transpose(iresult, size);
    }

  return;
}

int print_usage()
{
  mexPrintf("Usage: sph_data = skifst(sph_harm_coeff)\n");
}

/* This program is free software; you can redistribute it and/or modify
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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA */
