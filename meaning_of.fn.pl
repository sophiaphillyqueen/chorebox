# meaning_of - Interprets a complex string definition
# Copyright (C) 2014  Sophia Elizabeth Shapira
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# ########################

sub meaning_of {
  my @lc_a;
  my @lc_b;
  
  if ( $_[0] eq "" ) { return ""; }
  
  @lc_a = split(/:/,$_[0],2);
  
  if ( $lc_a[0] eq "" ) { return &meaning_of($lc_a[1]); }
  if ( $lc_a[0] eq "x" ) { return ""; }
  
  if ( $lc_a[0] eq "l" )
  {
    my $lc2_a;
    my $lc2_b;
    ($lc2_a,$lc2_b) = split(/:/,$lc_a[1],2);
    if ( $lc2_a ne $lc_a[1] )
    {
      &devel_err_aa("A \"l\"-type string encounters a colon."
        , "Be aware that the behavior of such instances has recently changed."
      );
    }
    $lc2_a .= &meaning_of($lc2_b);
    return $lc2_a;
  }
  
  if ( $lc_a[0] eq "lit" )
  {
    &devel_err_aa("\"lit\" string-type has been re-named to \"l\".");
    return $lc_a[1];
  }
  
  if ( $lc_a[0] eq "var" )
  {
    @lc_b = split(/:/,$lc_a[1],2);
    if ( $lc_b[1] ne "" )
    {
      &devel_err_aa("More stuff after variable name in \"var\"-type."
        , "Be aware that the behavior of such instances will soon change."
      );
    }
    return $strgvars{$lc_b[0]};
  }
  
  if ( $lc_a[0] eq "env" )
  {
    @lc_b = split(/:/,$lc_a[1],2);
    if ( $lc_b[1] ne "" )
    {
      &devel_err_aa("More stuff after variable name in \"env\"-type."
        , "Be aware that the behavior of such instances will soon change."
      );
    }
    return $ENV{$lc_b[0]};
  }
  
  if ( $lc_a[0] eq "dvar" )
  {
    @lc_b = split(/:/,$lc_a[1],2);
    if ( $lc_b[1] ne "" )
    {
      &devel_err_aa("More stuff after variable name in \"env\"-type."
        , "Be aware that the behavior of such instances will soon change."
      );
    }
    return $valvar{$lc_b[0]};
  }
  
  if ( $lc_a[0] eq "pd" )
  {
    return dirname(&meaning_of($lc_a[1]));
  }
  
  if ( $lc_a[0] eq "par" )
  {
    return &meaning__of_parent($lc_a[1]);
  }
  
  
  # "varqry" does a current-system query command based on a variable with
  # one goto target if the output has content and another if the output
  # is empty.
  # :varqry:<source>:<dest>:<goto-if-empty>:<goto-if-full>:
  
  # "flqry" is just like "dqry", except that it will not cause
  # a fatal-error if the output is empty.
  if ( $lc_a[0] eq "flqry" )
  {
    my $lc2_a;
    my $lc2_b;
    
    $lc2_a = $lc_a[1];
    $lc2_b = `$lc2_a`; chomp($lc2_b);
    return $lc2_b;
  }
  
  if ( $lc_a[0] eq "qry" )
  {
    my $lc2_a;
    my $lc2_b;
    
    $lc2_a = $lc_a[1];
    $lc2_b = `$lc2_a`; chomp($lc2_b);
    if ( $lc2_b eq "" )
    {
      die "\nFATAL ERROR:\n  Empty result for the following query command:\n  %"
        . $lc2_a . "\n\n";
      ;
    }
    return $lc2_b;
  }
  
  # Dynamic query -- for things such as build-time.
  # It's implementation is like the early implementations
  # of "qry" - except that later on, "qry" will be
  # altered to check the query in the target-system
  # query-result file if one is specified - while "dqry"
  # will always continue to just get the output of a
  # shell command.
  if ( $lc_a[0] eq "dqry" )
  {
    my $lc2_a;
    my $lc2_b;
    
    $lc2_a = $lc_a[1];
    $lc2_b = `$lc2_a`; chomp($lc2_b);
    if ( $lc2_b eq "" )
    {
      die "\nFATAL ERROR:\n  Empty result for the following query command:\n  %"
        . $lc2_a . "\n\n";
      ;
    }
    return $lc2_b;
  }
  
  if ( $lc_a[0] eq "info" )
  {
    @lc_b = split(/:/,$lc_a[1]);
    return $proj_info_s{$lc_b[0]};
  }
  
  if ( $lc_a[0] eq "linfo" )
  {
    @lc_b = split(/:/,$lc_a[1]);
    return $proj_info_l{$lc_b[0]};
  }
  
  if ( $lc_a[0] eq "s" )
  {
    my $lc2_a;
    my $lc2_b;
    
    ($lc2_a) = split(/:/,$lc_a[1]);
    $lc2_b = "";
    while ( $lc2_a > 0.5 )
    {
      $lc2_b .= " ";
      $lc2_a = int($lc2_a - 0.8);
    }
    return $lc2_b;
  }
  
  # The 'shl' complex-type does reverse-escaping for shell-scripting assuming
  # that the value it receives is stuff that would be enclosed in single-quotes.
  if ( $lc_a[0] eq "shl" )
  {
    my $lc2_a;
    my $lc2_b;
    my $lc2_c;
    my $lc2_d;
    
    $lc2_a = &meaning_of($lc_a[1]);
    $lc2_b = "";
    while ( $lc2_a ne "" )
    {
      $lc2_c = chop($lc2_a);
      $lc2_d = $lc2_c;
      if ( $lc2_d eq "'" ) { $lc2_c = "'\"'\"'"; }
      $lc2_b = $lc2_c . $lc2_b;
    }
    return $lc2_b;
  }
  
  # The 'pls' does reverse-escaping with the assumption that it is passed
  # stuff that is inside a PERL string -- once it has been fully debugged
  # it will, that is.
  if ( $lc_a[0] eq "pls" )
  {
    my $lc2_a;
    my $lc2_b;
    my $lc2_c;
    my $lc2_d;
    
    $lc2_a = &meaning_of($lc_a[1]);
    $lc2_b = "";
    while ( $lc2_a ne "" )
    {
      $lc2_c = chop($lc2_a);
      $lc2_d = $lc2_c;
      if ( $lc2_d eq "\'" ) { $lc2_c = "\\\'"; }
      if ( $lc2_d eq "\"" ) { $lc2_c = "\\\""; }
      if ( $lc2_d eq "\@" ) { $lc2_c = "\\\@"; }
      if ( $lc2_d eq "\\" ) { $lc2_c = "\\\\"; }
      $lc2_b = $lc2_c . $lc2_b;
    }
    return $lc2_b;
  }
  
  if ( $lc_a[0] eq "msh" )
  {
    my $lc2_a;
    my $lc2_b;
    my $lc2_c;
    my $lc2_d;
    
    $lc2_a = &meaning_of($lc_a[1]);
    $lc2_b = "";
    while ( $lc2_a ne "" )
    {
      $lc2_c = chop($lc2_a);
      $lc2_d = $lc2_c;
      if ( $lc2_d eq "'" ) { $lc2_c = "'\"'\"'"; }
      if ( $lc2_d eq "\$" ) { $lc2_c = "\$\$"; }
      $lc2_b = $lc2_c . $lc2_b;
    }
    return $lc2_b;
  }
  
  if ( $lc_a[0] eq "gscp" )
  {
    my $lc2_a;
    my $lc2_b;
    my $lc2_c;
    
    $lc2_a = &meaning_of($lc_a[1]);
    $lc2_b = "";
    while ( $lc2_a ne "" )
    {
      $lc2_c = chop($lc2_a);
      if ( $lc2_c eq "#" ) { $lc2_c = "\\#"; }
      if ( $lc2_c eq "!" ) { $lc2_c = "\\!"; }
      $lc2_b = $lc2_c . $lc2_b;
    }
    return $lc2_b;
  }
  
  # The "world" meaning-type reads a string from a subservient world.
  # The first argument specifies the name of the world, and the second
  # specifies the name of the string within that world.
  if ( $lc_a[0] eq "world" )
  {
    my $lc2_a;
    my $lc2_b;
    print "Okay: " . $make_lines[$make_indx] . "\n"; # debug
    @lc_b = split(/:/,$lc_a[1],3);
    $lc2_a = $world_matrices{$lc_b[0]};
    if ( ref($lc2_a) != "HASH" )
    {
      die "\nFATAL ERROR:\n  Invalid world specified.\n  \""
        . $recipe_file . "\" in line " . int($make_indx + 1.2)
        . ":\n  " . $make_lines[$make_indx] . "\n\n"
    ;
    }
    $lc2_b = $lc2_a->{"strings"};
    if ( ref($lc2_b) != "HASH" )
    {
      die "\nFATAL ERROR:\n  That world seems to be missing it\'s strings.\n  \""
        . $recipe_file . "\" in line " . int($make_indx + 1.2)
        . ":\n  " . $make_lines[$make_indx] . "\n\n"
    ;
    }
    
    # The following error-generator was removed due to
    # critical misfirings.
    #if ( !($lc2_b->{$lc_b[1]}) )
    #{
    #  die "\nFATAL ERROR:\n  The specified string does not seem to exist"
    #    . " in that world.\n  \""
    #    . $recipe_file . "\" in line " . int($make_indx + 1.2)
    #    . ":\n  " . $make_lines[$make_indx] . "\n\n"
    #;
    #}
    
    return ($lc2_b->{$lc_b[1]});
  }
  
  if ( $lc_a[0] eq "perl-l" ) { return &$r__perl_l_exe(&meaning_of($lc_a[1])); }
  if ( $lc_a[0] eq "perl-i" ) { return &$r__perl_i_exe(&meaning_of($lc_a[1])); }
  if ( $lc_a[0] eq "bin-l" ) { return &$r__bin_l_exe(&meaning_of($lc_a[1])); }
  if ( $lc_a[0] eq "bin-i" ) { return &$r__bin_i_exe(&meaning_of($lc_a[1])); }
  
  if ( $lc_a[0] eq "bl" ) { return ""; }
  
  #die "\nUnknown complex string-type: \""
  #  . $lc_a[0] . "\" in line " . int($make_indx + 1.2)
  #  . ":\n  " . $make_lines[$make_indx] . "\n\n"
  #;
  &devel_err_xaa("Unknown complex string-type: \"" . $lc_a[0] . "\"");
}



sub meaning__of_parent {
  my $lc_par_level;
  my $lc_par_vnom;
  my $lc_each_ancestor;
  my @lc_rev_parent;
  my $lc_many_parent;
  
  ($lc_par_level,$lc_par_vnom) = split(/:/,$_[0]);
  
  # Generate reverse parent stack:
  @lc_rev_parent = ();
  foreach $lc_each_ancestor (@over_scripts)
  {
    @lc_rev_parent = ($lc_each_ancestor,@lc_rev_parent);
  }
  # And determine it's size:
  $lc_many_parent = @lc_rev_parent;
  if ( $lc_par_level > ( $lc_many_parent + 0.5 ) )
  {
    die "\n"
      . "Requested ancestor " . $lc_par_level . " where only " . $lc_many_parent
      . "are available.\n"
      . "This mistake is done here: \""
      . $recipe_file . "\" in line " . int($make_indx + 1.2)
      . ":\n  " . $make_lines[$make_indx] . "\n\n"
    ;
  }
  $lc_par_level = int($lc_par_level - 0.8);
  if ( $lc_par_level < 0 ) { $lc_par_level = 0; }
  return &var_from_packing($lc_rev_parent[$lc_par_level],$lc_par_vnom);
}


