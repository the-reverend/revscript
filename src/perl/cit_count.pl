#!perl
use POSIX;

print "   date    :   time   : num : cits : min-max : fighters\n";

while (<>) {
  chomp;
  s/\x1b\[[0-9;]*[mHfABCDsuJKhl]//g;

#-=-=-=-  Current Stats for 12:57:10 PM Fri Oct 03, 2014 -=-=-=-
# 107 planets exist in the universe, 3% have Citadels.
#6,535,538 Fighters and 3,952 Mines are in use throughout the Universe.

  if (/-=-=-=-  Current Stats for (\d+):(\d+):(\d+) (\w)M \w+ (\w+) (\d+), (\d+) -=-=-=-/) {
   $hh=$1;
   $mm=$2;
   $ss=$3;
   if ($4 eq "P" and $1<12) { $hh=$1+12; } else { $hh=$1; }
   $mmm=$5;
   $dd=$6;
   $yyyy=$7;
   
   $mmm=~s/Jan/01/;
   $mmm=~s/Feb/02/;
   $mmm=~s/Mar/03/;
   $mmm=~s/Apr/04/;
   $mmm=~s/May/05/;
   $mmm=~s/Jun/06/;
   $mmm=~s/Jul/07/;
   $mmm=~s/Aug/08/;
   $mmm=~s/Sep/09/;
   $mmm=~s/Oct/10/;
   $mmm=~s/Nov/11/;
   $mmm=~s/Dec/12/;
  }
#  if (/(\d+) planets exist in the universe, (\d+)% have/) { $mx = floor($1*($2+1)/100); $mn = ceil($1*$2/100); print "$yyyy $mmm $dd : $hh $mm $ss : $1 : $2% : $mn-$mx\n" }
  if (/(\d+) planets exist in the universe, (\d+)% have/) { $mx = floor($1*($2+1)/100); $mn = ceil($1*$2/100); $p=$1; $c=$2; }
  if (/([\d,]+) Fighters and /) {
   $f = $1;
   $line = sprintf("%4s-%2s-%2s : %2s:%2s:%2s : %3d : %3d%% : %3d-%-3d : %10s\n", $yyyy, $mmm, $dd, $hh, $mm, $ss, $p, $c, $mn, $mx, $f);
   print $line unless $h{$line};
   $h{$line} = 1;
  }

}