#!/usr/bin/perl

# Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed
# with this library)

# This file is part of YAW Toolbox (Yet Another Wavelet Toolbox) You
# can get it at
# \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"}

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

# $Header: /home/cvs/yawtb/doc/tex/DocProcess.pl,v 1.13 2003-11-18 10:54:15 ljacques Exp $
#

use strict;
use warnings;
use Carp;
use Cwd;
use File::Find;
use File::Spec;


# Set architecture independent variables
my $matlab_comment_regex = "%";
my $is_in_doc_filename = '.is_in_mpath';

####################################################################
#                      GLOBAL VARIABLES
####################################################################
# $line_number : The number of the current line
# $line        : The current header line we take care of
# @header      : The header of the current file
# @code        : The code of the current file
my $line_number = 2;
my $line;
my (@header, @code);

# %toolbox_cmd: The key of the hash is the name of the toolbox commands
my %toolbox_cmd;
my %toolbox_filename;

# Set some variable according to the operating system
# Our default OS is Linux.
my $srcdir = qw(../../);
my $srcdir_regex = q(\.\./\.\./);
my $toolbox_file_extension_regex = '\.m';
my $path_sep = '/';
my $path_sep_regex = '/';
SWITCH:{
  if ( $^O =~ /windows[0-9]+/ ) {
    # Windows95/Windows98...
    last SWITCH; }
  # Add here other operating system
  };


# @section_substitution: This array stores the translation parameters to 
#    convert the sectioning commands found in a toolbox command file into
#    true LaTeX commands
my @section_substitution = (
# Command in .m            LaTeX Section    Color       Section       label
#  as regex                   command                    Title      Extension
 '\\\\manchap',              'subsection',    'red',        undef,          undef,
 '\\\\mansecSyntax',         'subsubsection', 'dark-blue',  'Syntax',       'Syn',
 '\\\\mansecDescription',    'subsubsection', 'dark-blue',  'Description',  'Des',
 '\\\\mansubsecInputData',   'paragraph',     'dark-blue',  'Input Data',   'InpD',
 '\\\\mansubsecOutputData',  'paragraph',     'dark-blue',  'Output Data',  'OutD',
 '\\\\mansecExample',        'subsubsection', 'dark-blue',  'Example(s)',   'Exa',
 '\\\\mansecReference',      'subsubsection', 'dark-blue',  'References',   'Ref',
 '\\\\mansecSeeAlso',        'subsubsection', 'dark-blue',  'See Also',     'See');

# %category_section : This Hash provides the correspondance between the
#    directory of the M-files and the file where one write the category 
#    sections of the manual
my %category_section = ( 
  "continuous/1d",                "TMP_cmd_cont_1d.tex",
  "continuous/1d/win_defs",       "TMP_cmd_cont_1d.tex",
  "continuous/1d/wave_defs",      "TMP_cmd_cont_1d.tex",
  "continuous/1dt",               "TMP_cmd_cont_1dt.tex",
  "continuous/1dt/wave_defs",     "TMP_cmd_cont_1dt.tex",
  "continuous/2d",                "TMP_cmd_cont_2d.tex",
  "continuous/2d/wave_defs",      "TMP_cmd_cont_2d.tex",
  "continuous/3d",                "TMP_cmd_cont_3d.tex",
  "continuous/3d/wave_defs",      "TMP_cmd_cont_3d.tex",
  "continuous/sphere",            "TMP_cmd_cont_sph.tex",
  "continuous/sphere/wave_defs",  "TMP_cmd_cont_sph.tex",
  "discrete/frames/1d",           "TMP_cmd_disc_frames_1d.tex",
  "discrete/frames/2d",           "TMP_cmd_disc_frames_2d.tex",
  "discrete/frames/sphere",       "TMP_cmd_disc_frames_sph.tex",
  "discrete/laplacian",           "TMP_cmd_disc_lap.tex",
  "discrete/matchp",              "TMP_cmd_disc_mat.tex",
  "discrete/ortho",               "TMP_cmd_disc_ort.tex",
  "discrete/packet/1d",           "TMP_cmd_disc_pack_1d.tex",
  "discrete/packet/2d",           "TMP_cmd_disc_pack_2d.tex",
  "discrete/packet/2d/wpck_defs", "TMP_cmd_disc_pack_2d.tex",
  "interfaces/spharmonickit",     "TMP_cmd_interfaces_spharmonickit.tex",
  "sample/1d",                    "TMP_cmd_samp.tex",
  "sample/1dt",                   "TMP_cmd_samp.tex",
  "sample/2d",                    "TMP_cmd_samp.tex",
  "sample/3d",                    "TMP_cmd_samp.tex",
  "sample/sphere",                "TMP_cmd_samp.tex",
  "tools/cmap",                   "TMP_cmd_tool.tex",
  "tools/display",                "TMP_cmd_tool.tex",
  "tools/help",                   "TMP_cmd_help.tex",
  "tools/io",                     "TMP_cmd_tool.tex",
  "tools/misc",                   "TMP_cmd_tool.tex",
  "",                             "TMP_cmd_tool.tex"
);

my $latex_output = qw(TMP_cmd_by_alpha.tex);

my $DEBUG = 0;

#####################################################################
#                        FUNCTIONS
#####################################################################

# remove_srcdir: remove the $srcdir of a filename
sub remove_srcdir {
  my $_file = shift;
  $_file =~ s/^$srcdir_regex//o;
  return $_file;
}


# split_function_name: $filenames is splitted into two parts the 
#   directory and its function name
sub split_function_name {
  my ($volume, $directory, $function ) = File::Spec->splitpath( shift );
  # Remove the extension of the file
  $function =~ s/(.*)$toolbox_file_extension_regex/$1/o;
  return ($directory, $function);
}


{
  my @doc_directory = ();

  # find_doc_directory_list: If a file $is_in_doc_filename exists in the
  # current directory then this directory, without the source directory
  # of the toolbox, is pushed into @doc_directory
  sub find_doc_directory_list {
    return unless -d  && -e File::Spec->catfile( $_, $is_in_doc_filename);
    push @doc_directory, $File::Find::name;
  }

  # find_toolbox_cmd_list: Find the commands in the YAWTB directories.
  #   The function returns a pointer to a Hash
  sub find_toolbox_cmd_list {
    %toolbox_cmd = ();
    my @toolbox_file = ();
    find( \&find_doc_directory_list, $srcdir );

    $DEBUG >=1 && print "DEBUG " . __FILE__ 
      . " " . __LINE__ ." : @doc_directory\n\n";

    foreach my $_dir (@doc_directory) {
      my @_toolbox_file = glob(File::Spec->catfile( $_dir, "*.m"));
      push @toolbox_file, @_toolbox_file;
    };
    foreach (@toolbox_file) {
      my $relative_filename = remove_srcdir( $_ );
      # Translate the relative filename into LaTeX i.e. the \ must be
      # protected, _ as well.
      (my $relative_filename_in_LaTeX = $relative_filename ) =~ s/\\/\\\\/g;
      $relative_filename_in_LaTeX =~ s/_/\\_/g;
      my ($directory, $function) = split_function_name( $relative_filename );
      # std_directory: Equivalent directory on a Unix machine.  This
      #   is very usefull on "Mac or Windows machine" to ensure portability
      #   of the code.
      # std_relative_function: Function with its complete Unix relative path
      (my $std_directory = $directory) =~ s|$path_sep_regex|/|g;
      my $std_relative_function = $std_directory . $function;
      # Remove the last separator
      $std_directory =~ s|(.*)/$|$1|;
      (my $function_in_LaTeX = $function ) =~ s/_/\\_/g;
      my $function_label = "cmd:$function";
      $toolbox_cmd{$function} = { "filename" => $_ ,
				  "relative_filename" => $relative_filename,
				  "relative_filename_in_LaTeX" => $relative_filename_in_LaTeX ,
				  "directory" => $directory,
				  "std_directory" => $std_directory,
				  "std_relative_function" => $std_relative_function,
				  "function_in_LaTeX" => $function_in_LaTeX,
				  "function_label" => $function_label };
      $toolbox_filename{$std_relative_function} = $function;
    }
    return 1;
  }
}

# get_header_and_code: The function returns the first block of comments
# found in the filename given as the first argumentargument
# Matlab file.
#  Input parameter
#        The name of the file
sub get_header_and_code {
  defined wantarray and croak "Function should not be call in void context";

  open( my $fh, "<", shift ) or die "Can't open file $!";
  @header = ();
  @code   = ();
  my @file_content = <$fh>;
  close $fh;
  my ($header_start_at_line,$header_end_at_line) = (-1,$#file_content);

  my $_count_line = 0;
  for (@file_content) {
    if ($header_start_at_line < 0 && ! m/^$matlab_comment_regex/o) {
      next;
    } elsif ($header_start_at_line < 0 &&  m/^$matlab_comment_regex/o) {
      $header_start_at_line = $_count_line;
      next;
    } elsif (m/\\mansecLicense/) {
      $header_end_at_line = $_count_line - 1;
      last;
    } elsif ($_ !~ m/^$matlab_comment_regex/o) {
      $header_end_at_line = $_count_line;
      last;
    };
  } continue { ++$_count_line; };
  return if $header_start_at_line < 0;

  @header = @file_content[ $header_start_at_line .. $header_end_at_line ];
  for (@header) { s/^$matlab_comment_regex ?//o };

  if ( $header_end_at_line < $#file_content ) {
    @code = @file_content[ $header_end_at_line+1 .. $#file_content ];
  } else {
    @code = ();
  };

  return 1;
}

# process_SeeAlso_section: Replace the regular expression by the functions
#   that matches the regular expressions
sub process_SeeAlso_section( ) {
  # Find the regular expression 
  my $start_SeeAlso = $line_number;
  my $end_SeeAlso   = $line_number;
  for ( ; $header[$end_SeeAlso] !~ /Location\}/ ; $end_SeeAlso++) { };
  if ( $start_SeeAlso == $end_SeeAlso ) {
    return
  }
  --$end_SeeAlso;
  my @list_regex = map { split /\s+/ } @header[ $start_SeeAlso .. $end_SeeAlso ];
  if ($#list_regex == -1 ) {
    return;
  }

  my @_list = ();
  # @match_regex : Thanks to this variable we will track the regular
  #   that never match a filename and add those regex to the list of files
  #   in the See Section
  my @match_regex;    
  foreach (0 .. $#list_regex) {
    $match_regex[$_] = 0;
  }
  foreach my $_filename (sort keys %toolbox_filename) {
    my $_cpt = -1;
    if ( 0 ) {
      print "\$filename : $_filename\n";
    }
    foreach (@list_regex) {
      $_cpt++;
      if ( 0 ) {
	print "  Elt regex : $_\n";
      }
      $_filename =~ m|$_| && (push @_list, $toolbox_filename{$_filename})
	&& $match_regex[$_cpt]++
	&& last;
    }
  }
  # Check the regex that never match a filename.  Remove the starting ^
  #   and ending $
  foreach (0 .. $#list_regex) {
    $list_regex[$_] =~ s|^\^||;
    $list_regex[$_] =~ s|\$$||;
    (! $match_regex[$_]) && push @_list, $list_regex[$_];
  }
  @_list = sort @_list;
  foreach (@_list) {
    if (exists $toolbox_cmd{$_}) {
      my $function_in_LaTeX = $toolbox_cmd{$_}{function_in_LaTeX};
      my $label = $toolbox_cmd{$_}{function_label};
      $_ = "\\htmlref{$function_in_LaTeX}{$label}";
    }
  }
  if ( 0 ) {
    print "\@list_regex : @list_regex\n";
    print "\@match_regex : @match_regex\n";
    print "\@_list : @_list\n\n";
  }


  foreach (@header[ $start_SeeAlso .. $end_SeeAlso ]) {
    $_ = "";
  };
  $header[ $start_SeeAlso ] = join ", ", @_list;
  $header[ $start_SeeAlso ] .= "\n\n";
  $line_number = $end_SeeAlso;
}

######################################################################
#                        MAIN PART
######################################################################
package main;

# Initialise the hash of the category files
my %is_empty=();
foreach my $_dir (sort keys %category_section) {
  my $_file = $category_section{$_dir};
  $is_empty{$_file} = 1;
  unlink $_file;
}


open(my $latexfh, ">", $latex_output) or croak "Can't open output LaTeX file";

find_toolbox_cmd_list( );

if ($DEBUG >= 3) {
  my @_cmd = sort keys %toolbox_cmd;
  print "Array cmd : @_cmd \n";
  foreach my $_cmd (sort keys %toolbox_cmd) {
    my $_filename = $toolbox_cmd{$_cmd}{filename};
    my $_longname = remove_srcdir( $_filename );
    print "DEBUG __FILE__ __LINE__ : $_cmd : $_filename : $_longname\n";
  }
}


foreach my $_function (sort keys %toolbox_cmd) {
  if ( 0 ) {
    print "\nFonction : $_function\n";
  }
  my $_filename          = $toolbox_cmd{$_function}{filename};
  my $_relative_filename = $toolbox_cmd{$_function}{relative_filename};
  my $_relative_filename_in_LaTeX 
    = $toolbox_cmd{$_function}{relative_filename_in_LaTeX};
  my $_function_label    = $toolbox_cmd{$_function}{function_label};
  my $_function_in_LaTeX = $toolbox_cmd{$_function}{function_in_LaTeX};
  my $_std_directory     = $toolbox_cmd{$_function}{std_directory};

  get_header_and_code( $_filename );

  push @header, "\n";
  push @header, "\\subsubsection{\\textcolor{dark-blue}{Location}}\n"
    . "$_relative_filename_in_LaTeX\n";
  push @header, "\\clearpage\n\n\n" 
    .  "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n";

  $line_number = 0;
  $line = ();
 HEADER_LINE:
  while ( $line_number <= $#header ) {
    $line = $header[$line_number];

    # Substitute \manchap
if ($line =~ s/$section_substitution[0]/
\\$section_substitution[1]\{\\textcolor{$section_substitution[2]}{$_function_in_LaTeX}\}
\\label{$_function_label}/) {
#    if ($line =~ s/$section_substitution[0]/
#\\$section_substitution[1]\{$_function_in_LaTeX\}
#\\label{$_function_label}/) {
      $header[$line_number] = $line;
      next;
    }

    # Substitute the other sectioning commands
    for ( my $i = 5; $i < $#section_substitution ; $i+=5 ) {
      if ($line =~ s/$section_substitution[$i]/\\$section_substitution[$i+1]\{\\textcolor{$section_substitution[$i+2]}{$section_substitution[$i+3]}\}\n\\label{$_function_label:$section_substitution[$i+4]}\n/) {
      #if ($line =~ s/$section_substitution[$i]/\\$section_substitution[$i+1]\{$section_substitution[$i+3]\}\n\\label{$_function_label:$section_substitution[$i+4]}\n/) {
	$header[$line_number] = $line;
	next HEADER_LINE if ( $section_substitution[$i] ne '\\\\mansecSeeAlso' );
	++$line_number;
	process_SeeAlso_section( );
	next HEADER_LINE;
      }
    }


    # To get a DVI file
#     s/\\manchap/\\textcolor{red}\\section{$_cmd_tex}\\textcolor{black}\n/g;
#     s/\\mansecSyntax/\\textcolor{dark-blue}\\subsection{Syntax}\\textcolor{black}\n/g;
#     s/\\mansecDescription/\\textcolor{dark-blue}\\subsection{Description}\\textcolor{black}\n/g;
#     s/\\mansubsecInputData/\\textcolor{dark-blue}\\subsubsection{Input Data}\\textcolor{black}\n/g;
#     s/\\mansubsecOutputData/\\textcolor{dark-blue}\\subsubsection{Output Data}\\textcolor{black}\n/g;
#     s/\\mansecExample/\\textcolor{dark-blue}\\subsection{Example(s)}\\textcolor{black}\n/g;
#     s/\\mansecReference/\\textcolor{dark-blue}\\subsection{References}\\textcolor{black}\n/g;
#     s/\\mansecSeeAlso/\\textcolor{dark-blue}\\subsection{See Also}\\textcolor{black}\n/g;


    $line =~ s/\\begin\{code\}/\\begin\{verbatim\}/g;
    $line =~ s/\\end\{code\}/\\end\{verbatim\}/g;
    $line =~ s/\\begin\{TODO\}/\\begin\{verbatim\}/g;
    $line =~ s/\\end\{TODO\}/\\end\{verbatim\}/g;
    $header[$line_number] = $line;
  } continue {
    ++$line_number;
  }

  # We now have to extract the processed description and write it in
  # one of the categories.  This description starts after a line like
  #             \label{cmd:function}
  # and stop just before the next
  #             \\$section_substitution[6]
  # which replaces the command \mansecSyntax
  my $found_description = 0;
  my @description = ();
  $line_number = 0;
 HEADER_LINE_LOOP:
  while ( $line_number <= $#header) {
    my $line = $header[$line_number];
    if ( $found_description == 0 ) {
      $found_description = 1 if ( $line =~ m/\\label\{$_function_label\}/ );
      next HEADER_LINE_LOOP;
    }
    else {
      last if ( $line =~ m/\\$section_substitution[6]/ );
    };
    push @description, $line if ( $line =~ m/\S/ )
  }
  continue { $line_number++; };

  {
    # Copy the description in one of the category file
    open(FH,'>>',$category_section{$_std_directory})
      or croak "Can't open the file $category_section{$_std_directory} for appending";
    if ( $is_empty{$category_section{$_std_directory}} == 1 ) {
      $is_empty{$category_section{$_std_directory}} = 0;
      # Print the head of the tabular
      print FH <<"EOF";
\\begin\{center\}
  \\begin\{tabular\}\{|p\{0.25\\linewidth\}|p\{0.70\\linewidth\}|\}
    \\hline
    \\multicolumn\{1\}\{|c|\}\{Command\} & Description\\\\
    \\hline\\hline
EOF

    } else {
      print FH "\\\\\n";
    }
    print FH "\\multicolumn\{1\}\{|c|\}{\\htmlref\{$_function_in_LaTeX\}\{$_function_label\}\} & @description";
    close FH or croak "Fail to close $_std_directory\n";
  }

  print $latexfh @header;
}


close $latexfh;

# We also have to close the tabulars
foreach (sort keys %is_empty) {
  if ($is_empty{$_} == 0) {
    open(FH,'>>',$_) or croak "Can't open the file $_ for appending";
    print FH  <<"EOF";
    \\\\\\hline
  \\end\{tabular\}
\\end\{center\}
EOF
    close FH;
  }
}


__END__
