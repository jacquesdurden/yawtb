/* mexicansph: Spherical Mexican Hat Wavelet.
 *
 * The documentation is available in the corresponding M-file.
 *
 * \mansec{License}
 *
 * This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
 * You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
 *
 * $Header: /home/cvs/yawtb/continuous/sphere/wave_defs/mexicansph.c,v 1.2 2006-09-20 08:51:30 jacques Exp $
 *
 * Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with this library)
 * (See the notice at the end of the file.) */

/* Matlab code :
 * wavmh=(2/pi)^.5*(1/a) * (1+tan(theta/2).^2).* ...
 *         (1-2*tan(theta/2).^2*a^-2).*exp(-2*a^-2*tan(theta/2).^2); */

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <mex.h>
#include "yawtb.h"

/* Input data */

#define i_X     prhs[0] 
#define i_Y     prhs[1] 
#define i_Z     prhs[2]

#define i_x     prhs[3] 
#define i_y     prhs[4] 
#define i_z     prhs[5]

#define i_sc    prhs[6] 
#define i_ang   prhs[7] 

#define i_narg  8

/* Output data */

#define o_out   plhs[0] 

/* Mexfunction == main */
void  mexFunction ( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])  
{
  /* Input array (in C) */
  double *X, *Y, *Z;
  double x, y, z;
  double sc, ang;
  double *out;
  
  /* Misc */
  mxArray  *wavparval, *cell;
  int      nrow, ncol, siz, index;

  double sc2, dist, y2, prov, norm_const;
  int    i;

  /* Temporary data */
  mxArray *mxtmp;
  double  *dtmp;

  /********************************************************************************
   *                               Input Checkings                                *
   ********************************************************************************/

  /* Return only the wavelets parameters if an empty input in first arg */
  
  if ((nrhs == 1) && (mxIsEmpty(i_X)))
    {
      wavparval = mxCreateCellRow(0);
#ifdef MTLBR12
      mxSetName(wavparval, "wavparval");
#endif
      o_out = wavparval;

      return;
    }
  else if (nrhs != i_narg)
    {
      mexErrMsgTxt("There are not enough parameters");
    }

  /* Check inputs sizes */

  if ( (mxGetM(i_X) != mxGetM(i_Y))||
       (mxGetN(i_X) != mxGetN(i_Y))||
       (mxGetM(i_X) != mxGetM(i_Z))||
       (mxGetN(i_X) != mxGetN(i_Z)))
    {
      mexErrMsgTxt("'X', 'Y' and 'Z' must have the same size!");
    }
  
  /********************************************************************************
   *                               Initializations                                *
   ********************************************************************************/

  X   = mxGetPr(i_X);
  Y   = mxGetPr(i_Y);
  Z   = mxGetPr(i_Z);

  nrow = mxGetM(i_X);
  ncol = mxGetN(i_X);
  siz  = nrow*ncol;

  x  = mxGetScalar(i_x);
  y  = mxGetScalar(i_y);
  z  = mxGetScalar(i_z);

  prov = sqrt(x*x + y*y + z*z);
  x /= prov;
  y /= prov;
  z /= prov;
  
  sc  = mxGetScalar(i_sc);
  ang = mxGetScalar(i_ang);

  o_out = mxCreateDoubleMatrix (nrow, ncol, mxREAL);
  out   = mxGetPr(o_out);

  sc2     = sc*sc;

  norm_const = 1.0/sqrt(2*M_PI);

  /********************************************************************************
   *                                 Computations                                 *
   ********************************************************************************/

  for(i = siz - 1; i >= 0; i--)
    {
      prov = (*(X+i) - x);
      dist = prov*prov;
          	
      prov = (*(Y+i) - y);
      dist += prov*prov;
          	
      prov = (*(Z+i) - z);
      dist += prov*prov;
	    
      dist = (dist >= 4) ? (4 - 1e-10) : dist;

      y2 = 4 * dist / ( 4 - dist );  /* 4*tan(th/2)^2 */
      

      *(out + i) = (norm_const/sc) * (1 + y2/4) * (2 - y2/sc2) * 
	exp(-y2/(2*sc2));
    }
  
} /* EndOf mexfunction */




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
