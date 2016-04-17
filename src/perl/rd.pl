#!perl
# remove duplicates

while (<>) {
  chomp;
  s/\x1b\[[0-9;]*[mHfABCDsuJKhl]//g;
  s/^\s+//;
  s/\s+$//;
  $h{$_}+=1;
  print "$_\n" if $h{$_}==1; # or $_=="";
}