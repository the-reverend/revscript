#!perl

while (<>) {
  chomp;
  s/\x1b\[[0-9;]*[mHfABCDsuJKhl]//g;
  if (/^Sector  : (\d+)/) {$sector=$1; $maxs=$1 if $1>$maxs; $cimfile=0;}
  if (/^Traders : .*/) { printf "$sector $_\n";}
  if (/^Ships   : .*/) { printf "$sector $_\n";}
}
