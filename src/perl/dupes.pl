#!perl

while (<>) {
  chomp;
  s/\x0D//;

# 08:55:16 PM 01/08/2011 76.26.230.179 mobby(7): New Player on Trade Wars

  if (/(\d+\.\d+\.\d+\.\d+) ([^\(]+)\((\d+)\):/)
  {
    $a = "$1|$2";
    unless ($hash{$a}) { print "$a\n"; }
    $hash{$a} = $1;
  }

}
