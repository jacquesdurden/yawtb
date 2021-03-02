/* convsph: spherical convolution
 *
 * The documentation is available in the corresponding M-file.
 *
 * \mansec{License}
 *
 * This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
 * You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
 *
 * $Header: /home/cvs/yawtb/interfaces/spharmonickit/convsph.c,v 1.3 2003-11-13 09:01:57 ljacques Exp $
 *
 * Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with this library)
 * (See the notice at the end of the file.) */


/* Classical Libraries */
#include <math.h>
#include <stdio.h>
#include <string.h>

/* Matlab Libraries */
#include <mex.h>
#include "matrix.h"

/* SpharmonicKit Libraries */
#include "FST_hybrid_memo.h"
#include "primitive_FST.h"
#include "cospmls.h"
#include "precomp_flt_hybrid.h"

/**************************************************************/
/**************************************************************/

/* Input data */

#define i_data   prhs[0] 
#define i_filter   prhs[1] 
/* #define i_bw       prhs[2] */
#define i_narg  2

/* Output data */

#define o_result   plhs[0] 

/* Some useful macro */
#define compmult(a,b,c,d,e,f) (e) = ((a)*(c))-((b)*(d)); (f) = ((a)*(d))+((b)*(c))

/* Mexfunction == main(int argc, char **argv) */
void  mexFunction ( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])  
{
  int i, bw, size, size2_1, lim, max_split, width, height;
  int max_cos_size, max_shift_size;
  int *loc, *cos_size, *shift_size;
  double *rfilter, *ifilter, *rdata, *idata, *rresult, *iresult;
  double *seminaive_tablespace, *trans_seminaive_tablespace, *workspace;
  double **seminaive_table, **trans_seminaive_table;
  double **split_dptr, **cos_dptr, **shift_dptr;
  double **Z, *zspace, *Zptr;
  struct lowhigh *poly;
  double *wSave, *CoswSave, *CoswSave2;

  mxArray *dup_i_data, *dup_i_filter;

  if (nrhs != i_narg)
    {
      mexPrintf("Usage: result = convsph(data,filter)\n");
      return;
    }


 
  /* Bandwidth is set to the half of the number of rows in the data */
  height = mxGetM(i_data);
  width = mxGetN(i_data);
  size = height;
  size2_1 = size*size - 1;

  /* data must be square */
  if (height != width)
    {
      mexErrMsgTxt("Error: data and filter must be square matrices.");
    }

  /* Sizes of data and filter must be the same */
  if ((height != mxGetM(i_filter)) ||
      (width != mxGetN(i_filter)))
    {
      mexErrMsgTxt("Error: Sizes of data and filter must be the same.");
    }

  /* Size must be a power of 2 */
  if ((floor(log(size)/log(2))) != (log(size)/log(2)))
    {
      mexErrMsgTxt("Error: the size of data must be a power of 2.");
    } 


  bw = (size/2);

  /* bw has to be at least 64 */
  if (bw < 64)
    {
      mexErrMsgTxt("Error: bw must be at least 64. Use convsph_semi() instead.\n");
    }

  dup_i_data = mxDuplicateArray(i_data);
  dup_i_filter = mxDuplicateArray(i_filter);

  rdata = mxGetPr(dup_i_data);
  idata = mxGetPi(dup_i_data);
  
  transpose(rdata, size);

  if (idata == NULL)
    {
      idata = (double *) mxMalloc(sizeof(double) * size * size);
      for (i = size2_1; i >= 0; idata[i] = 0, i--);
    }
  else
    {
      transpose(idata, size);
    }

  rfilter = mxGetPr(dup_i_filter);
  ifilter = mxGetPi(dup_i_filter);
  
  transpose(rfilter, size);

  if (ifilter == NULL)
    {
      ifilter = (double *) mxMalloc(sizeof(double) * size * size);
      for (i = size2_1; i >= 0; ifilter[i] = 0, i--);
    }
  else
    {
      transpose(ifilter, size);
    }

  o_result = mxCreateDoubleMatrix (height, width, mxCOMPLEX);
  rresult = mxGetPr(o_result);
  iresult = mxGetPi(o_result);

  conv_hybrid(rdata, idata, rfilter, ifilter, rresult, iresult, size, bw);

  return;
}

int newConv2Sphere_hyb_memo( double *rdata, double *idata,
			      double *rfilter, double *ifilter,
			      double *rres, double *ires,
			      int size, int lim,
			      int *loc, double **Z,
			      struct lowhigh *poly,
			      double **seminaive_table,
			      double **trans_seminaive_table,
			      double **split_dptr,
			      double **cos_dptr,
			      double *workspace)
{
  int bw;
  double *frres, *fires, *filtrres, *filtires, *trres, *tires;
  double *scratchpad;

  bw = size / 2;

  frres = workspace;   /* needs (bw*bw) */
  fires = frres + (bw*bw);    /* needs (bw*bw) */
  trres = fires + (bw*bw);    /* needs (bw*bw) */
  tires = trres + (bw*bw);    /* needs (bw*bw) */
  filtrres = tires + (bw*bw); /* needs bw */
  filtires = filtrres + bw;   /* needs bw */
  scratchpad = filtires + bw; /* needs (8 * bw^2) + (32 * bw) */


  FST_hybrid_memo( rdata, idata,
		   frres, fires,
		   size,
		   scratchpad, 1,
		   lim, Z, poly,
		   loc, seminaive_table,
		   split_dptr, cos_dptr);
    
  FZT_hybrid_memo( rfilter, ifilter,
		   filtrres, filtires,
		   size,
		   scratchpad, 1,
		   lim, Z, poly,
		   loc, seminaive_table, 
		   split_dptr, cos_dptr);

  newTransMult(frres, fires, filtrres, filtires, trres,
	       tires, size);

  InvFST_semi_memo(trres, tires,
		   rres, ires,
		   size, trans_seminaive_table,
		   scratchpad, 1);


}

/************************************************************************/
/* multiplies harmonic coefficients of a function and a filter */
/* See convolution theorem of Driscoll and Healy */
/* datacoeffs should be output of an FST, filtercoeffs the 
   output of an FZT.  There should be (bw * bw) datacoeffs,
   and bw filtercoeffs.
   rres and ires should point to arrays
   of dimension bw * bw. size parameter is 2*bw  
*/

int newTransMult(double *rdatacoeffs, double *idatacoeffs, 
		  double *rfiltercoeffs, double *ifiltercoeffs, 
		  double *rres, double *ires,
		  int size)
{

  int m, l, bw;
  double *rdptr, *idptr, *rrptr, *irptr;

  bw = size/2;

  rdptr = rdatacoeffs;
  idptr = idatacoeffs;
  rrptr = rres;
  irptr = ires;

  for (m=0; m<bw; m++) {
    for (l=m; l<bw; l++) {
      compmult(rfiltercoeffs[l], ifiltercoeffs[l],
	       rdptr[l-m], idptr[l-m],
	       rrptr[l-m], irptr[l-m]);
      rrptr[l-m] *= sqrt(4*M_PI/(2*l+1));
      irptr[l-m] *= sqrt(4*M_PI/(2*l+1));
    }
    rdptr += bw-m; idptr += bw-m;
    rrptr += bw-m; irptr += bw-m;
  }
  for (m=bw+1; m<size; m++) {
    for (l=size-m; l<bw; l++){
      compmult(rfiltercoeffs[l], ifiltercoeffs[l],
	       rdptr[l-size+m], idptr[l-size+m],
	       rrptr[l-size+m], irptr[l-size+m]);
      rrptr[l-size+m] *= sqrt(4*PI/(2*l+1));
      irptr[l-size+m] *= sqrt(4*PI/(2*l+1));
    }
    rdptr += m-bw; idptr += m-bw;
    rrptr += m-bw; irptr += m-bw;
  }

}


/* Fully computes the Hybrid Spherical Convolution */
int conv_hybrid(double *rdata, double *idata, 
		 double *rfilter, double *ifilter,
		 double *rresult, double *iresult,
		 int size, int bw)
{
  int i, lim, max_split;
  int max_cos_size, max_shift_size;
  int *loc, *cos_size, *shift_size;
  double *seminaive_tablespace, *trans_seminaive_tablespace, *workspace;
  double **seminaive_table, **trans_seminaive_table;
  double **split_dptr, **cos_dptr, **shift_dptr;
  double **Z, *zspace, *Zptr;
  struct lowhigh *poly;
  double *wSave, *CoswSave, *CoswSave2;


  seminaive_tablespace =
    (double *) mxMalloc(sizeof(double) * Spharmonic_TableSize(bw));
  /* mexPrintf("Spharmonic_TableSize(%i): %i\n", bw, Spharmonic_TableSize(bw)); */
  
  trans_seminaive_tablespace =
    (double *) mxMalloc(sizeof(double) * Spharmonic_TableSize(bw));

  workspace = (double *) mxMalloc(sizeof(double) * 
				  (16 * bw * bw + 33 * bw));

  /** needed for newFCTX as used in FLT_SIMSPL **/
  poly = (struct lowhigh *) mxMalloc(sizeof(struct lowhigh) * 4 * bw );


  /****
    At this point, check to see if all the memory has been
    allocated. If it has not, there's no point in going further.
    ****/

  if ( (seminaive_tablespace == NULL) ||
       (trans_seminaive_tablespace == NULL) ||
       (workspace == NULL) || (poly == NULL) )
    {
      mexPrintf("seminaive_tablespace:%p, trans_seminaive_tablespace:%p, workspace:%p, poly:%p\n", 
		seminaive_tablespace,trans_seminaive_tablespace,workspace,poly); 
      mexErrMsgTxt("Error in allocating memory");
    }

  /*** precompute for the seminaive portion of the forward
    spherical transform algorithm (i.e. for those
    orders greater than lim) ***/

  /* mexPrintf("Generating seminaive tables...\n"); */
  seminaive_table =
    Spharmonic_Pml_Table( bw, seminaive_tablespace, workspace );
					  

  /*** transpose the above precomputed data...this will
    be the precomputed data for the inverse spherical transform ***/

  /* mexPrintf("Generating trans_seminaive tables...\n"); */
  trans_seminaive_table = 
    Transpose_Spharmonic_Pml_Table(seminaive_table,
				   bw,
				   trans_seminaive_tablespace,
				   workspace) ;


  /***
    now to precompute for the hybrid algorithm
    ***/


  /***
    allocate some space needed by HybridPts and
    get lim, locations of switch points, etc
    ***/

  cos_size = (int *) mxMalloc(sizeof(int) * bw );
  shift_size = (int *) mxMalloc(sizeof(int) * bw );

  loc = HybridPts( bw, &lim,
		   cos_size, shift_size,
		   &max_split,
		   &max_cos_size,
		   &max_shift_size ) ;


  /* This is space for the intermediate results
     of the hybrid algorithm */  
  zspace = (double *) mxMalloc(sizeof(double) *
			     (2 * (max_split) * bw));
  Z = (double **) mxMalloc(sizeof(double *) * (max_split));
  
  Z[0] = zspace;
  Zptr = zspace;
  for(i = 1 ; i < max_split + 0; i++)
    {
      Zptr += 2 * bw;
      Z[i] = Zptr;
    }
  

  /**
    I'm pointing it to the seminaive_tablespace.

    THIS IS OK PROVIDED THAT BW >= 64.

    At smaller bandwidths, use pure semi-naive.


    I first needed to precompute the seminaive data
    in order to take the transpose (to derive the precomputed
    data for the inverse spherical transform). Having done that,
    I don't care about the precomputed data at the start of this
    array. I can store the precomputed data for the hybrid algorithm
    here. Why? Because, basically (and with quite reasonable
    assumptions ... I think)

    sizeof(precomputed data for hybrid algorithm for orders m = 0 though lim)

    is less than

    sizeof(precomputed data for seminaive algorithm for orders m = 0 though lim)

    I could allocate separate space, but already at bw = 512 I'm
    allocating ALOT of memory. Might as well try to cut it down
    where I can.

    **/
  
  /*
    (double **)  ptrs which will be pointed to the various
    locations of the hybrid algorithm's precomputed data */

  split_dptr = (double **) mxMalloc(sizeof(double *) * 3 * (lim + 1));
  cos_dptr = split_dptr + lim + 1;
  shift_dptr = cos_dptr + lim + 1;					    

  Hybrid_SetDptrs( bw,
		   lim,
		   loc, seminaive_tablespace,
		   cos_size, shift_size,
		   cos_dptr,
		   split_dptr,
		   shift_dptr ) ;




  /****

    finally can precompute the data !

    *****/

  HybridPrecomp( bw, lim,
		 loc,
		 cos_dptr,
		 split_dptr,
		 shift_dptr,
		 workspace );



  newConv2Sphere_hyb_memo( rdata, idata,
			   rfilter, ifilter,
			   rresult, iresult,
			   size, lim,
			   loc, Z,
			   poly,
			   seminaive_table,
			   trans_seminaive_table,
			   split_dptr,
			   cos_dptr,
			   workspace) ;

  transpose(rresult, size);

  if (iresult != NULL)
    {
      transpose(iresult, size);
    }

  return;


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
