/* skfst: fast spherical transform (Spharmonic Kit Implementation)
 *
 * The documentation is available in the corresponding M-file.
 *
 * \mansec{License}
 *
 * This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
 * You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
 *
 * $Header: /home/cvs/yawtb/interfaces/spharmonickit/skfst.c,v 1.1 2007-10-09 07:40:13 jacques Exp $
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

#define i_data   prhs[0] 
#define i_narg  1

/* Output data */

#define o_result   plhs[0] 

/* Mexfunction == main(int argc, char **argv) */
void  mexFunction ( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])  
{
  int i;
  int bw, bw2_1, size, size2_1, ncol, nrow, cutoff;
  int data_is_real;
  double *rdata, *idata, *rresult, *iresult;
  double *CosPmls, *workspace;
  mxArray *dup_i_data;

  /* ### 1. INITIALIZATIONS (+ input checkings) ### */
  if (nrhs != i_narg)
    {
      print_usage();
      return;
    }

  /* Bandwidth is set to the half of the number of rows in the data */
  nrow = mxGetM(i_data);
  ncol = mxGetN(i_data);

  /* data must be double */
  if (! mxIsDouble(i_data) ) 
    {
      print_usage();
      mexErrMsgTxt("Error: input data must be recorded as double (real or complex).");
    }

  /* data must be square */
  if (nrow != ncol)
    {
      print_usage();
      mexErrMsgTxt("Error: data must be a square matrix.");
    }

  /* Size must be a power of 2 */
  if ((floor(log(nrow)/log(2))) != (log(nrow)/log(2)))
    {
      print_usage();
      mexErrMsgTxt("Error: the size of data must be a power of 2.");
    } 

  size = nrow;
  size2_1 = size*size - 1;
  bw = (size/2);
  bw2_1 = bw*bw - 1;
  cutoff = bw ; /* => assuming will seminaive all orders */

  /* LIMITATION: Bandwidth must be greater than 4 */
  if (bw < 4)
    {
      print_usage();
      mexErrMsgTxt("Error: Bandwidth must be greater than 4.");
    } 
  
  /* ### 2. MEMORY ALLOCATION (+ matlab pointers import) ### */

  /* Duplicate matlab data for computation */
  dup_i_data = mxDuplicateArray(i_data);
  rdata = mxGetPr(dup_i_data);
  idata = mxGetPi(dup_i_data);
  data_is_real = (idata == NULL);

  /* Transposing matrices for matlab matrix representation compatibility */
  transpose(rdata, size);

  if (data_is_real)
    {
      idata = (double *) mxMalloc(sizeof(double) * size * size);
      for (i = size2_1; i >= 0; idata[i] = 0, i--);
    }
  else
    {
      transpose(idata, size);
    }

  /* Matlab outputs */
  o_result = mxCreateDoubleMatrix (bw, bw, mxCOMPLEX);
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

  if ( (rdata == NULL) || (idata == NULL) ||
       (rresult == NULL) || (iresult == NULL) ||
       (workspace == NULL) || (CosPmls == NULL) )
    {
      mexErrMsgTxt("Error in allocating memory");
    }

  /* ### 3. Fast Spherical Transform Computation ### */
  FST_semi_fly(rdata, idata,
	       rresult, iresult,
	       size,
	       CosPmls,
	       workspace,
	       data_is_real,
	       cutoff);

  transpose(rresult, bw);
  if (iresult != NULL)
    {
      transpose(iresult, bw);
    }

  return;
}

int print_usage()
{
  mexPrintf("Usage: sph_harm_coeff = skfst(sph_data)\n");
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
