#!perl

#Sector  : 4071 in uncharted space.
#Ports   : Nebuchadnezzar Outpost, Class 2 (BSB)
#Fighters: 190 (belong to your Corp) [Defensive]
#Fighters: 10 (belong to Corp#8, War Room) [Defensive]

#   3   2610 100% - 1340 100%   1960 100%
#   4    940 100%   2910 100%   2570 100%

$maxs=1;
$cimfile = 1;

while (<>) {
	unless ($ARGV eq $cfname)
	{
		# assume current file is a cim file until we find out otherwise
    # if current file is a log, we don't want to remove the data from the list
		$cimfile = 1;
		$cfname = $ARGV;
	}
  chomp;
  s/\x1b\[[0-9;]*[mHfABCDsuJKhl]//g;
  if (/^Sector  : (\d+)/) {$sector=$1; $maxs=$1 if $1>$maxs; $cimfile=0;}
  if (/^Ports   : .*\(([BS]{3})\)/) { $h{$sector}=$1 unless $h{$sector}; $cimfile=0;}
  if (/(\d+)(([- ]+\d+\s+\d+%)+)/)
	{
		$h{$1}=$2;
		if ($cimfile) {$e{$1}=1;} # set exclude flag
	}
}

foreach $i (sort {$a <=> $b} keys %h) {
  $line=$h{$i};
  $line=~s/B/ -    0   0%/g;
  $line=~s/S/      0   0%/g;
  if    ($maxs<=999)  { printf "%3d%s\n", $i, $line unless $e{$i}; }
  elsif ($maxs<=9999) { printf "%4d%s\n", $i, $line unless $e{$i}; }
  else                { printf "%5d%s\n", $i, $line unless $e{$i}; }
}