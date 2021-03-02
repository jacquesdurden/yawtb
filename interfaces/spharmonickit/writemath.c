/* writemath: write data in mathematica list (ascii) format.
 *
 * The documentation is available in the corresponding M-file.
 *
 * \mansec{License}
 *
 * This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
 * You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
 *
 * $Header: /home/cvs/yawtb/interfaces/spharmonickit/writemath.c,v 1.2 2003-11-07 11:06:41 ljacques Exp $
 *
 * Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with this library)
 * (See the notice at the end of the file.) */

/* Classical Libraries */
#include <errno.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

/* Matlab Libraries */
#include <mex.h>
#include "matrix.h"

/* SpharmonicKit Libraries */
#include "MathFace.h"
/* 
   #include "FST_hybrid_memo.h"
   #include "cospmls.h"
   #include "precomp_flt_hybrid.h"
*/

/**************************************************************/
/**************************************************************/

/* Input data */

#define i_mat  prhs[0]
#define i_filename  prhs[1] 
#define i_narg  2

/* Output data */

/* Mexfunction == main(int argc, char **argv) */
void  mexFunction ( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])  
{
  int size, buflen, width, height, isreal;
  FILE *file;
  char *fname;
  double *mat_r, *mat_i;
 
  if (nrhs != i_narg)
    {
      mexPrintf("Usage: writemath(mat, filename)\n");
      return;
    }

  /* Obtaining the filename */
  buflen = (mxGetM(i_filename) * mxGetN(i_filename)) + 1;
  fname = mxCalloc(buflen, sizeof(char));
  mxGetString(i_filename, fname, buflen);

  /* Obtaining the size */
  height = mxGetM(i_mat);
  width = mxGetN(i_mat);

  /* Obtaining the input matrix */
  mat_r = mxGetPr(i_mat);
  mat_i = mxGetPi(i_mat);

  if (file = fopen(fname,"w"))
    {
      mexPrintf("Writing signal file %s...\n", fname);

      if (mat_i)
	{
	  mexPrintf("Complex data\n", fname);
	  printMMComplexTable(file, mat_r, mat_i, width, height);
	}
      else
	{
	  mexPrintf("Real data\n", fname);
	  printMMRealTable(file, mat_r, width, height);
	}

      fclose(file);
    }
  else
    {
      mexPrintf("Error: Unable to open signal file %s for writing data ...\n", fname);
    }
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

