
my @zla;
my $zlb;
my $zlc;

my @perlinga = ();
my $perlings = "#!";

{
  my $lc_a;
  
  #$lc_a = `which perl`;
  #chomp($lc_a);
  
  $lc_a = $critiray[0];
  &zamus($lc_a);
}
sub zamus {
  $perlings .= " " . $_[0];
  @perlinga = ( @perlinga, $_[0] );
}

@zla = @ARGV;
$zlb = @zla;

while ( $zlb > 0.5 ) { &procanarg; }
sub ashof {
  my $lc_a;
  $lc_a = @zla;
  if ( $lc_a < 0.5 ) { return ""; }
  $lc_a = shift(@zla);
  $zlb = @zla;
  return $lc_a;
}
sub procanarg {
  my $lc_counto;
  
  $zlc = shift(@zla);
  $zlb = @zla;
  
  if ( $zlc eq "run" )
  {
    &lasminuta;
    exec(@perlinga,@zla);
  }
  if ( $zlc eq "line" )
  {
    &lasminuta;
    exec("echo",$perlings);
  }
  
  if ( $zlc eq "lit" )
  {
    $lc_counto = &ashof;
    while ( $lc_counto > 0.5 )
    {
      &zamus(&ashof);
      $lc_counto = int($lc_counto - 0.8);
    }
    return;
  }
  
  die "\nUnrecognized chorebox-perl option: " . $zlc . ":\n\n";
  #&zamus($zlc);
}

sub lasminuta {
  # First we add into the search path what has been compiled
  # into this program as the default.
  &adincdirs(@moduleloc_buildform);
}
sub adincdirs {
  my $lc_a;
  foreach $lc_a (@_)
  {
    &zamus("-I" . $lc_a);
  }
}

die "\nYou never got to the invocation of chorebox-perl.\n\n";
#exec(@perlinga);

