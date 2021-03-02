/* readmath: read data saved in mathematica list (ascii) format
 *
 * The documentation is available in the corresponding M-file.
 *
 * \mansec{License}
 *
 * This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
 * You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
 *
 * $Header: /home/cvs/yawtb/interfaces/spharmonickit/readmath.c,v 1.2 2003-11-07 11:06:41 ljacques Exp $
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

#define i_filename  prhs[0] 
#define i_size  prhs[1] 
#define i_narg  2

/* Output data */

#define o_out  plhs[0] 

/* Mexfunction == main(int argc, char **argv) */
void  mexFunction ( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])  
{
  int size, buflen, width, height, isreal;
  FILE *file;
  char *fname;
  double *out_r, *out_i;
 
  if (nrhs != i_narg)
    {
      mexPrintf("Usage: out = readmath(filename, size)\n");
      return;
    }

  /* Obtaining the filename */
  buflen = (mxGetM(i_filename) * mxGetN(i_filename)) + 1;
  fname = mxCalloc(buflen, sizeof(char));
  mxGetString(i_filename, fname, buflen);

  /* Obtaining the size */
  size = mxGetScalar(i_size);

  /* Creating the output */
  o_out = mxCreateDoubleMatrix (size, size, mxCOMPLEX);
  out_r = mxGetPr(o_out);
  out_i = mxGetPi(o_out);

  if (file = fopen(fname,"r"))
    {
      mexPrintf("Reading signal file %s...\n", fname);
      readMMComplexTable(file, out_r, out_i, size*size, &width, &height, &isreal);
      /*      readMMRealTable(file, out_r, size*size, &width, &height);*/
      fclose(file);
    }
  else
    {
      mexPrintf("Error: Unable to open signal file %s...\n", fname);
    }
}

/* convsph: spherical convolution
 *
 * The documentation is available in the corresponding M-file.
 *
 * \mansec{License}
 *
 * This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
 * You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
 *
 * $Header: /home/cvs/yawtb/interfaces/spharmonickit/readmath.c,v 1.2 2003-11-07 11:06:41 ljacques Exp $
 *
 * Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with this library)
 * (See the notice at the end of the file.) */
