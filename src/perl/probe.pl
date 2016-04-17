#!perl

while (<>) {
  chomp;
  s/\x1b\[[0-9;]*[mHfABCDsuJKhl]//g;
  if (/^Probe entering sector : (\d+)/) { $sector=$1; }
  if (/^Probe Destroyed!/) {
   unless ($p{$sector}) {print "$sector\n"; $p{$sector}=1;}
  }
}