# act_by_line -- Main way that a line of the Makefile recipe is interpreted
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

sub act_by_line {
  my @lc_a;
  my $lc_tmcm;
  my $lc_this;
  @lc_a = split(/:/,$_[0],3);
  
  if ( $lc_a[1] eq "" ) { return; }
  if ( $lc_a[1] eq "#" ) { return; }
  if ( $lc_a[1] eq "label" ) { return; }
  
  $lc_tmcm = "-";
  if ( $lc_a[1] eq $lc_tmcm )
  {
    $adendia .= "\n" . $lc_a[2];
    return;
  }
  $lc_tmcm .= ">";
  if ( $lc_a[1] eq $lc_tmcm )
  {
    $adendia .= "\n\t" . $lc_a[2];
    return;
  }
  $lc_tmcm .= ">";
  if ( $lc_a[1] eq $lc_tmcm )
  {
    $adendia .= "\n\t\t" . $lc_a[2];
    return;
  }
  
  if ( $lc_a[1] eq "*" )
  {
    $adendia .= $lc_a[2];
    return;
  }
  
  if ( $lc_a[1] eq "s" )
  {
    my $lc2_a;
    ($lc2_a) = split(/:/,$lc_a[2]);
    while ( $lc2_a > 0.5 )
    {
      $adendia .= " ";
      $lc2_a = int($lc2_a - 0.8);
    }
    return;
  }
  
  if ( $lc_a[1] eq "n" )
  {
    my $lc2_a;
    ($lc2_a) = split(/:/,$lc_a[2]);
    while ( $lc2_a > 0.5 )
    {
      $adendia .= "\n";
      $lc2_a = int($lc2_a - 0.8);
    }
    return;
  }
  
  
  if ( $lc_a[1] eq "prsave" )
  {
    my @lc2_a;
    @lc2_a = split(/:/,$lc_a[2]);
    $strgvars{$lc2_a[0]} = $texbufvar;
    system("echo","  Delay-print buffer saved to thought variable: " . $lc2_a[0] . ":");
    return;
  }
  if ( $lc_a[1] eq "prload" )
  {
    my @lc2_a;
    @lc2_a = split(/:/,$lc_a[2]);
    $texbufvar = $strgvars{$lc2_a[0]};
    system("echo","  Delay-print buffer loaded from thought variable: " . $lc2_a[0] . ":");
    return;
  }
  if ( $lc_a[1] eq "prclear" )
  {
    $texbufvar = "";
    return;
  }
  if ( $lc_a[1] eq "%" )
  {
    my $lc_a;
    $lc_a = $adendia;
    $adendia = "";
    
    &act_by_line("ix:" . $lc_a[2]);
    $texbufvar .= $adendia;
    
    $adendia = $lc_a;
    return;
  }
  
  
  
  
  if ( $lc_a[1] eq "setvar" )
  {
    my @lc2_a;
    my $lc2_b;
    @lc2_a = split(/:/,$lc_a[2],2);
    $lc2_b = &meaning_of($lc2_a[1]);
    $strgvars{$lc2_a[0]} = $lc2_b;
    system("echo","  Thought variable: " . $lc2_a[0] . ": = " . $lc2_b . ":");
    return;
  }
  
  if ( $lc_a[1] eq "nsetvar" )
  {
    my @lc2_a;
    my $lc2_b;
    my $lc2_count;
    my $lc2_name;
    @lc2_a = split(/:/,$lc_a[2],3);
    $lc2_b = &meaning_of($lc2_a[2]);
    
    $lc2_name = $lc2_a[0];
    $lc2_count = $lc2_a[1];
    while ( $lc2_count > 0.5 )
    {
      my $lc3_n;
      $lc3_n = $lc2_name;
      $lc2_name = $strgvars{$lc3_n};
      
      if ( $lc2_name eq "" )
      {
        &devel_err_xaa("There is no such thought-variable as: " . $lc3_n . ":");
      }
      if ( &invalid_name($lc2_name) )
      {
        &devel_err_xaa("Invalid thought-variable name: " . $lc2_name . ":");
      }
      
      $lc2_count = int($lc2_count - 0.8);
    }
    
    $strgvars{$lc2_name} = $lc2_b;
    system("echo","  Thought variable: " . $lc2_name . ": = " . $lc2_b . ":");
    return;
  }
  
  
  
  
  
  if ( $lc_a[1] eq "varfromopt" )
  {
    &action__varfromopt($lc_a[2]);
    return;
  }
  
  if ( $lc_a[1] eq "stack" )
  {
    &action__stack($lc_a[2]);
    return;
  }
  
  if ( $lc_a[1] eq "qry-l" )
  {
    &action__qry_l($lc_a[2]);
    return;
  }
  
  if ( $lc_a[1] eq "ifsame-to" )
  {
    &action__ifsame_to($lc_a[2]);
    return;
  }
  
  if ( $lc_a[1] eq "ifdiff-to" )
  {
    &action__ifdiff_to($lc_a[2]);
    return;
  }
  
  if ( $lc_a[1] eq "goto" )
  {
    &action__goto($lc_a[2]);
    return;
  }
  
  if ( $lc_a[1] eq "prcd" )
  {
    &action__prcd($lc_a[2]);
    return;
  }
  
  
  # see action__prcd.fn.pl
  if ( $lc_a[1] eq "wrlvr" )
  {
    &action__wrlvr($lc_a[2]);
    return;
  }
  
  # see action__prcd.fn.pl
  if ( $lc_a[1] eq "wrlcpy" )
  {
    &action__wrlcpy($lc_a[2]);
    return;
  }
  
  if ( $lc_a[1] eq "wrlry" )
  {
    &action__wrlry($lc_a[2]);
    return;
  }
  
  if ( $lc_a[1] eq "rwrlry" )
  {
    &action__rwrlry($lc_a[2]);
    return;
  }
  
  if ( $lc_a[1] eq "prvw" )
  {
    &action__prvw($lc_a[2]);
    return;
  }
  
  if ( $lc_a[1] eq "apnvar" )
  {
    my @lc2_a;
    my $lc2_b;
    
    @lc2_a = split(/:/,$lc_a[2],2);
    $lc2_b = $strgvars{$lc2_a[0]};
    $lc2_b .= &meaning_of($lc2_a[1]);
    $strgvars{$lc2_a[0]} = $lc2_b;
    system("echo","  Thought variable: " . $lc2_a[0] . ": = " . $lc2_b . ":");
    return;
  }
  
  if ( $lc_a[1] eq "compare-version" )
  {
    &action__compare_version($lc_a[2]);
    return;
  }
  
  if ( $lc_a[1] eq "fail" ) { &action__fail; return; }
  if ( $lc_a[1] eq "err" )
  {
    $err_mesg .= &captura($lc_a[2]);
    return;
  }
  
  # Clear the logic stack.
  if ( $lc_a[1] eq "clearstack" )
  {
    @litstack = ();
    system("echo","  Logic Stack Cleared.");
    return;
  }
  
  
  # Change a variable (named in the one recognized argument) to
  # contain the dirname() result of it's former contents.
  # (If you want to have the dirname()-result in a separate
  # variable from the input contents, then precede this directive
  # with a "setvar" directive.)
  if ( $lc_a[1] eq "dirname" )
  {
    my $lc2_a;
    my $lc2_b;
    my $lc2_c;
    ($lc2_a) = split(/:/,$lc_a[2]);
    $lc2_b = $strgvars{$lc2_a};
    $lc2_c = dirname($lc2_b);
    $strgvars{$lc2_a} = $lc2_c;
    system("echo","  Thought variable: " . $lc2_a . ": = " . $lc2_c . ":");
    return;
  }
  
  # Creates a brand new array who's name is specified in the first
  # argument and who's contents are all the *remaining* arguments.
  # Do *not* include a colon at the end of the last argument, please.
  $lc_this = ( 1 > 2 );
  if ( $lc_a[1] eq "brandnew-array" )
  {
    &devel_err_aa("The \"brandnew-array\" directive has been renamed \"bna\".");
    $lc_this = ( 2 > 1 );
  }
  if ( $lc_a[1] eq "bna" ) { $lc_this = ( 2 > 1 ); }
  if ( $lc_this )
  {
    my @lc2_a;
    my $lc2_b;
    
    @lc2_a = split(/:/,$lc_a[2]);
    if ( &goodarray(@lc2_a) )
    {
      $lc2_b = shift(@lc2_a);
      $strarays{$lc2_b} = [@lc2_a];
      &report_array($lc2_b);
      return;
    }
  }
  
  if ( $lc_a[1] eq "emptyarray" )
  {
    my $lc2_a;
    my @lc2_b;
    @lc2_b = ();
    ($lc2_a) = split(/:/,$lc_a[2]);
    $strarays{$lc2_a} = [@lc2_b];
    &report_array($lc2_a);
    return;
  }
  
  if ( $lc_a[1] eq "newit" )
  {
    my @lc2_all;
    my $lc2_name;
    my $lc2_cdown;
    my $lc2_oldref;
    my @lc2_oldray;
    
    @lc2_all = split(/:/,$lc_a[2],3);
    $lc2_name = $lc2_all[0];
    $lc2_cdown = $lc2_all[1];
    while ( $lc2_cdown > 0.5 )
    {
      my $lc3_n;
      $lc3_n = $strgvars{$lc2_name};
      if ( $lc3_n eq "" )
      {
        &devel_err_xaa("Could not resolve the " . $lc2_cdown . " names after: "
          . $lc2_name . ":")
        ;
      }
      if ( &invalid_name($lc3_n) )
      {
        &devel_err_xaa("Not a valid variable-name from \"" . $lc2_name
         . "\": " . $lc3_n . ":")
        ;
      }
      $lc2_name = $lc3_n;
      $lc2_cdown = int($lc2_cdown - 0.8);
    }
    $lc2_oldref = $strarays{$lc2_name};
    @lc2_oldray = ();
    if ( ref($lc2_oldref) eq "ARRAY" )
    {
      @lc2_oldray = @$lc2_oldref;
    }
    @lc2_oldray = (@lc2_oldray,&meaning_of($lc2_all[2]));
    $strarays{$lc2_name} = [@lc2_oldray];
    &report_array($lc2_name);
    return;
  }
  
  # This next item creates a new array (named by the one recognized
  # argument) which contains all the arguments that were passed to
  # this "chorebox-configure" program.
  #   One exception is made though. If the very first argument
  # appears to be a "--srcdir" option, that argument is omitted.
  # The reason is that this argument should be prepended to the
  # argument list by the "configure" script, and therefore was probably
  # present in the arguments passed to this program as a *result* of
  # having been prepended by the calling "configure" script.
  if ( $lc_a[1] eq "argv" )
  {
    &action__argv($lc_a[2]);
    return;
  }
  
  
  # This next directives copies all items from the array named
  # in the first argument onto the array named in the second
  # argument - but while doing this copying, it filters out
  # any items that would create redundancies.
  if ( $lc_a[1] eq "redun" )
  {
    &action__redun($lc_a[2]);
    return;
  }
  
  if ( $lc_a[1] eq "echo" )
  {
    $adendia .= &meaning_of($lc_a[2]);
    return;
  }
  
  
  # Now here is what is done if the current directive is the start
  # of a -foreach- loop:
  if ( $lc_a[1] eq "foreach" )
  {
    &action__foreach($lc_a[2]);
    return;
  }
  
  if ( $lc_a[1] eq "eachend" )
  {
    &action__eachend;
    return;
  }
  
  if ( $lc_a[1] eq "perl-in" )
  {
    &action__perl_in($lc_a[2]);
    return;
  }
  
  if ( $lc_a[1] eq "bin-in" )
  {
    &action__bin_in($lc_a[2]);
    return;
  }
  
  if ( $lc_a[1] eq "adapt" )
  {
    &action__adapt($lc_a[2]);
    return;
  }
  
  # This is the directive that invokes another script:
  if ( $lc_a[1] eq "run" )
  {
    my $lc2_old;
    my $lc2_new_file;
    
    &devel_err_xaa("The \"run\" strategy has been scrapped."
      , "A better alternative will be available in compiled version."
    );
    $lc2_new_file = &meaning_of(@lc_a[2]);
    $lc2_old = &pack_script;
    @over_scripts = (@over_scripts,$lc2_old);
    &load_script_file($lc2_new_file);
    &act_by_line;
    return;
  }
  
  
  die "\nUnknown Makefile Recipe Command in line " . int($make_indx + 1.2)
    . ":\n  " . $_[0]
    . "\n\nRecipe file: " . $recipe_file . "\n\n";
  ;
}

