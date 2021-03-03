# Welcome to the Yet Another Wavelet toolbox.

![YAWtb](doc/images/yawtb_logo.jpg)

## Introduction

This archive contains the code of the YAWtb toolbox. The purpose of this toolbox is to implement in Matlab:
- 1D, 2D, 3D Continuous Wavelet Transforms (CWTs)
- 1D+Time (spatio-temporal) CWT
- (Stereographical) Spherical CWT
- 2D dyadic Frames (isotropic and directional)
- (in development) Spherical Frames of Stereographical Wavelets

This toolbox was under active development till about 2010 but **it is no longer developed**. The onlly purpose of this GitHub repository is to keep an accessible archive of the YAWtb, for instance, for possible analysis, forks, or porting into another numerical programming language (such as Python or Julia).

## Documentation

If you want to know more about the content and purpose of this Matlab toolbox, you can have a look to the following documents:
- Some [slides](doc/slides/yawtb.pdf) describing the toolbox and its philosophy (HASSIP minischool, Marseille, 1-5 November 2003)
- Yet Another Wavelet Toolbox Reference Guide (2003, pdf):
  - [pdf](doc/tex/YAWTBReferenceManual.pdf) (LaTeX sources are available in the repository) 
  - [html](https://htmlpreview.github.io/?https://github.com/jacquesdurden/yawtb/blob/main/doc/html/index.html)

## You wanna help?

This toolbox should ideally be ported to Python, which is more flexible than Matlab and interfaces more naturally with the C files required for instance by the spherical wavelet transform. However, none of the toolbox's authors have time anymore to make this transfer. If you want to help, feel free to contact [Laurent Jacques](https://perso.uclouvain.be/laurent.jacques/) for more information.  

## License

This toolbox and all its files are provided under the "GNU GENERAL PUBLIC LICENSE, Version 2, June 1991".
See this [file](COPYING.txt) for more information.

## Warnings

This repository contains the version 0.1.1 of the YAWtb. It was still an unstable version and a lot of work had to be done especially on the documentation (use YAWtb at your own, rather limited, risk). 

### Requirements

The YAWtb worked for Matlab versions greater than 5 and was developped onto the 6th. It's not sure that this toolbox still works with recent version of Matlab. 

### Installation

In the sequel, the `>>` symbols represents the Matlab prompt.

Follow these steps to install the YAWtb Matlab toolbox,

1. Unpack YAWtb where you want (say the `<YAWTBDIR>` directory for simplicity);

2. Compile all the YAWtb mexfiles (provided that your `mex` matlab script is well configured) with the  `yamake` utility:
```
>> cd <YAWTBDIR>
>> yamake
```
(and for a more explicit compilation `>> yamake debug`)

**Remark**: If you have Microsoft Windows (9x, 2000, XP, ...), it seems that the native Matlab compiler, and also this of Windows, are not
able to compile correctly the yawtb C code (e.g. cwtsph stuff). Use instead the free compiler of Borland available at http://www.borland.com (need a simple registration) and configure Matlab in function (run 'mex -setup' and read the Borland compiler FAQ and doc).

3. Run `yaload` in Matlab to load the whole YAWtb path:
```
>> cd <YAWTBDIR>
>> yaload
```

4. Add the following lines to a matlab startup file, either the general one (matlabrc.m) located in MATLABDIR/toolbox/local, or the local startup file (startup.m) somewhere in your home dir (see matlab doc):
```
%% YAWtb installation
olddir=pwd;
cd <YAWTBDIR>
yaload;
cd(olddir);
clear olddir;
```

5. Enjoy of YAWtb !

## TODO List

Here is the TODO list of things to improve, create, delete inside the YAWtb project:

- Using signal instead of their Fourier transform in various mfiles
(`cwt<n>d`, `cwtsph`, ...) and allowing the use of the fft with a special keyword 
(e.g. `fft`);

- Setting sampling period in `cwt1d.m`

- improve the documentation of `morletsph.m` and `dogsph.c` is really
  poor.

- check the documentation of `cwt1dt.m` and the associated spatio
  temporal Morlet wavelet.

- use `k_0` (or `a_0`) and `c_0` to control the 1dt Morlet wavelet instead
of `k_0` and `w_0`.

- `yademo` fails with `cwt1dt` or `movgauss`: Comments are
  inserted directly in the code environment.  Note that in `cwt1d`
  comments were outside of this environment.  We probably need to
  move them outside of this environment.

- The norm $L^1$ or $L^2$ is not taken into account in cwt1dt.
 ```
>> mat = movgauss;
>> wave = cwt1dt(fft2(mat),'mexican',[4 5 6],[1],'order',4,'sigma',1,'sigmax',1,'sigmat',8);
>> yashow(wave,'filter');
```
The plot is not correct because we expect an anisotropic wavelet.

- The filter option does not exist with `cwt1d`.


## Toolbox directory tree
```
Here is the current explanation of the yawtb tree

===
yawtb (=>:directories, ->:files)
|
|-> AUTHORS               /* GPL file */
|-> COPYING               /* GPL file */
|-> yaload.m              /* yawtb startup file (addpath, etc ...) */
|-> yamake.m              /* compilations of the yawtb mexfiles */
|
|=> doc                   /* Documentation */
|   |=> html
|   |=> ps
|   |=> ascii
|   `=> tex
|
|=> continuous            /* All the continuous transfrom */
|   |=> 1d                /* 1D CWT */ 
|   |=> 2d                /* 2D CWT */
|   |=> 1dt               /* 1D+T CWT (spatio-temporal) */ 
|   `=> sphere            /* Spherical CWT */
|
|=> discrete
|   |=> packet            /* Wavelet Packets in 1d and 2d */
|   |   |=> 1d   	
|   |   `=> 2d 	          
|   |=> matchp            /* matching pursuit  */
|   |=> laplacian
|   `=> ortho             /* orthogonal wavelet */              
|
|=> frames                /* Wavelet Frames */
|   |=> 1d   	
|   |=> 2d 	          
|   `=> sphere
|
|=> include               /* Directories for storing general usage
|                            C-File that may be useful for many
|=> interfaces            /* Various interfaces to external (GPL) program
|   `=> spharmonickit     /* Interface to the SpharmonicKit */
|
|=> lib                   /* MEX-File */
|
|=> src
|   
|=> tools
|   |=> display           /* universal display function (yashow.m) */
|   |=> misc              /* various utils (vect, noising, thresholding, ...) */
|   |=> cmap              /* various colormap needed by som yawtb functions (e.g. rgray, ...) */
|   |=> devel             /* The developper corner (see README inside) */
|   `=> io                /* Input/Output scripts (like pgm read & write) */
|
|=> demos                 /* some demo of yawtb */
|   `=> denoising
|	|=> 1d	          /* Various techniques related to signal denoising */  
|	|=> 2d            /* Various techniques related to image denoising */
|	`=> sphere        /* Various techniques related to spherical denoising */
|
`=> samples               /* samples for the different WT */            	
    |=> 1d         
    |=> 2d
    |=> 1dt 
    `=> sphere  
```

## Authors (alphabetical order)
- Alain Coron 
- Laurent Demanet
- [Laurent Jacques](https://perso.uclouvain.be/laurent.jacques/) (corresponding author) 
- Attilio Rivoldini 
- Pierre Vandergheynst

## News
- **March 2nd, 2021**: YAWtb now hosted on GitHub and the full repository in now on Git; previous website is down and redirect here.
- **December 15th 2011**: YAWtb hosted on  UCLouvain: The project is now hosted as an official page on the UCL server (UCLouvain.be server)
- **April 15th 2007**: Ubuntu package available. Thanks to Vincent Boucher, a Ubuntu package of the YAWtb daily snapshot are available in the Download section.
- **January 11th 2006**: The YAWtb website has moved. We are now hosted gracefully by the Telecommunication and Teledetection Laboratory (TELE). The team thanks the TELE lab for this kind support.
- **June 14th 2002**: First (unstable) release of the YAWtb. The YAWtb developpers have the pleasure to announce you the creation of the first unstable release called YAWtb-0.1.0 However, this version has no tutorial and many programs may not work correctly. Go to the download section of this site to get YAWtb-0.1.0. All the comments, remarks, contributions are welcome in the YAWtb Wiki or in our mailing lists. Update (15th June): A separated archive for all the documentations (ps, pdf, html) has been created in the download section.
- **June 4th 2002**: Adding a YAWtb Wiki. A Wiki has been added to the YAWtb site here (or click on "Yawtb Wiki Help Pages" in the left menu). This allows to create an html YAWtb tutorial based on a Wiki in complement of the existing YAWtb reference document. The main idea is that every pages of this tutorial may be modified by every one to add his own comments, remarks, experiments about the use of the yawtb.
- **January 22th 2002**: Adding of a new CWT. The 3D CWT. A new CWT has been added to the toolbox, the three dimensional CWT. Screenshots and explanations can be found here.
- **January 7th 2002**: The YAWtb user reference is done. The YAWtb project contains now a complete user reference thanks to the work of Alain. Functions are now described by categories and by alphabetical order here. A YAWtb tutorial will be realized soon and the first YAWtb stable release will follow.
- **August 7th 2001**: Spherical Continous Wavelet Transform. The YAWtb (the cvs version) supports now the spherical continuous wavelet transform. You can find some screenshots here.
- **July 20th 2001**: View CVS. Removing CVS Web and replacing it by View CVS. This choice gives better results in the CVS visualization (syntax highlightings).
- **July 16th 2001**: CVS Web. The whole YAWtb's CVS repository can now be browsed through a CVSWeb? interface at the link CVS Web located in the left menu. (More information about the CVSWeb? cgi script here)
- **July 13th 2001**: Web site updated. Adding one other example to the "Tests & Screenshots" section. There is now an explanation of how to compute multiple scales/angles with cwt2d.
- **July 13th 2001**: Web site updated. Adding a "News" section to the YAWtb site. The aim of this section is to present the evolution of the YAWtb in all its aspects (source code, mathematical concepts, documentation, web site, ...)
- **July 12th 2001**: Web site updated. The "Tests & Screenshots" section is now completed. It contains currently only a few Continuous Wavelet Transform (1D and 2D) examples.
- **December 21th 2000**: the YAWtb is born. Creation of the YAWtb (Yet Another Wavelet toolbox) project. The developpers are A.Coron, L. Jacques, A. Rivoldini and P. Vandergheynst.

## Acknowledgements

The YAWtb team want to thank you the following persons 
for their kind contributions to the toolbox :
- Boris Cigale
- Geoffroy Piroux
- Vincent Boucher
