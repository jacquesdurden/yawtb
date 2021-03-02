/* morletsph: Spherical Morlet Wavelet.
 *
 * The documentation is available in the corresponding M-file.
 *
 * \mansec{License}
 *
 * This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
 * You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
 *
 * $Header: /home/cvs/yawtb/continuous/sphere/wave_defs/emexicansph.c,v 1.2 2006-09-26 11:11:54 jacques Exp $
 *
 * Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with this library)
 * (See the notice at the end of the file.) */

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

#define i_e     prhs[8] /* Eccentricity */
#define i_s     prhs[9] /* Sum sigma_x^2 + sigma_y^2 */

#define i_narg  10

/* Output data */

#define o_out   plhs[0] 

/* Mexfunction == main */
void  mexFunction ( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])  
{
  
  double *X, *Y, *Z;
  double x, y, z;
  double sc, ang;
  double e, s, sx, sy, sx2, sy2;
  double *out;
  
  mxArray  *wavparval, *cell;
  int      nrow, ncol, siz, index;

  double sc2, dist, lambda, y2, prov;
  double phi, th, cphi, sphi, cth, sth, cang, sang;
  double oldX, newX, oldY, newY, oldZ, newZ;
  double cosphi2, sinphi2, tmpXY, norm_const;
  int    i;

  /********************************************************************************
   *                               Input Checkings                                *
   ********************************************************************************/

  /* Return only the wavelets parameters if an empty input in first arg */
  
  if ((nrhs == 1) && (mxIsEmpty(i_X)))
    {
      wavparval = mxCreateCellRow(4);
#ifdef MTLBR12
      mxSetName(wavparval, "wavparval");
#endif
      mxSetCellNb(wavparval, 0, mxCreateString("e"));
      mxSetCellNb(wavparval, 1, mxCreateScalarDouble(0.99));
      mxSetCellNb(wavparval, 2, mxCreateString("s"));
      mxSetCellNb(wavparval, 3, mxCreateScalarDouble(2));
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

  cang = cos(ang);
  sang = sin(ang);

  e   = mxGetScalar(i_e);
  s   = mxGetScalar(i_s);

  sx2 = s / (1 + sqrt(sqrt(1-e*e)));
  sy2 = s - sx2;

  sx  = sqrt(sx2);
  sy  = sqrt(sy2);

  o_out = mxCreateDoubleMatrix (nrow, ncol, mxREAL);
  out = mxGetPr(o_out);

  sc2     = sc*sc;

  th    = atan2(sqrt(x*x + y*y),z);
  phi   = atan2(y,x);

  cth   = cos(th);
  sth   = sin(th);

  cphi  = cos(phi);
  sphi  = sin(phi);

  norm_const = 2.0/(sqrt(M_PI*sx*sy*(3*sx2*sx2 + 3*sy2*sy2 + 2*sx2*sy2)));


  /********************************************************************************
   *                                 Computations                                 *
   ********************************************************************************/

  for(i = siz - 1; i >= 0; i--)
    {
      newX = *(X+i);
      newY = *(Y+i);
      newZ = *(Z+i);

      /* First Euler Angle rotation around OZ */

      oldX = newX;
      newX =   cphi*newX + sphi*newY;
      newY = - sphi*oldX + cphi*newY;

      /* Second Euler Angle rotation around OY */

      oldZ = newZ;
      newZ =   cth*newZ + sth*newX;
      newX = - sth*oldZ + cth*newX;

      /* Third Euler Angle rotation around OZ: R-1[z](chi)*/
      oldX = newX;
      newX =   cang*newX + sang*newY;
      newY = - sang*oldX + cang*newY;

      dist = (tmpXY = (newX * newX + newY * newY)) + (newZ-1) * (newZ-1);
      dist = (dist >= 4) ? (4 - 1e-10) : dist;

      y2   = 4 * dist / ( 4 - dist ); /* y2 = 4*tan^2(theta/2) */

      cosphi2 = newX / ( sqrt(tmpXY) + 1e-13 );
      cosphi2 *= cosphi2;

      sinphi2 = newY / ( sqrt(tmpXY) + 1e-13 );
      sinphi2 *= sinphi2;

      *(out + i) = (norm_const/sc) * (1 + y2/4) * 
	(sx2+sy2  -  y2/sc2*( (sy2/sx2)*cosphi2 + (sx2/sy2)*sinphi2 ) ) * 
	exp(-(y2/(2*sc2)) * ( (1.0/sx2)*cosphi2 + (1.0/sy2)*sinphi2 ) );

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
