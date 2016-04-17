#!perl

use Time::Local;

$base=timelocal(0,0,0,1,0,2000); #-86400;

# adjust for dst
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
$base=$base-3600 if ($isdst);

$now=0;
$smax=0;
$sector=0;

while (<>) {

  # reset $now if the current file changes
  $now=0 unless $ARGV eq $fn;
  $fn=$ARGV;

  chomp;
  s/\x1b\[[0-9;]*[mHfABCDsuJKhl]//g;

  # grab date strings out of the game and covert to localtime in seconds
  # Date Built     : 06:45:02 PM Fri Oct 09, 2015
  # -=-=-=-  Current Stats for 01:14:51 AM Sun Nov 23, 2014 -=-=-=-
  # 09:36:38 AM Sun Nov 23, 2014
  if (!(/Date Built     : /) and (/(\d\d):(\d\d):(\d\d) (A|P)M (\w+) (\w+) (\d+), (20\d\d)/)) {
   $hr=$1; $mn=$2; $sc=$3; $ddd=$5; $mmm=$6; $dd=$7; $yyyy=$8-12;
   $hr+=12 if $hr<12 and $4 eq "P";
   if ($mmm eq "Jan") {$mm=0;}
   elsif ($mmm eq "Feb") {$mm=1;}
   elsif ($mmm eq "Mar") {$mm=2;}
   elsif ($mmm eq "Apr") {$mm=3;}
   elsif ($mmm eq "May") {$mm=4;}
   elsif ($mmm eq "Jun") {$mm=5;}
   elsif ($mmm eq "Jul") {$mm=6;}
   elsif ($mmm eq "Aug") {$mm=7;}
   elsif ($mmm eq "Sep") {$mm=8;}
   elsif ($mmm eq "Oct") {$mm=9;}
   elsif ($mmm eq "Nov") {$mm=10;}
   elsif ($mmm eq "Dec") {$mm=11;}
   $now=timelocal($sc,$mn,$hr,$dd,$mm,$yyyy);
   if ($` eq "-=-=-=-  Current Stats for ") { # only set stamp from V screen if newer
    $stamp= (($now-$base)>$stamp) ? $now-$base : $stamp;
   } else { $stamp=$now-$base; }
   $smax=($stamp>$smax) ? $stamp : $smax;
  }

  # read log file for stamps
  if (/^\s*(\d+) :\s+(\d+) :\s+(.+)\s+:\s+-?\d+(\.\d+)? day\(s\)( : (.*))?/) {
   $l{$2}="(na)" unless exists $l{$2};
   $l{$2}= ($1>$v{$2}) ? $3 : $l{$2};
   $f{$2}= ($1>$v{$2}) ? $6 : $f{$2};
   $v{$2}= ($1>$v{$2}) ? $1 : $v{$2};
   $smax= ($1>$smax) ? $1 : $smax;
  }

  # read game logs sector displays
  if (/^Sector  : (\d+)/) {
   $sector=$1;
   if ($sector>0 and $now>0) {
    $l{$sector}= ($stamp>$v{$sector}) ? "log"  : $l{$sector};
    $f{$sector}= ($stamp>$v{$sector}) ? $fn    : $f{$sector};
    $v{$sector}= ($stamp>$v{$sector}) ? $stamp : $v{$sector};
   }
  }
}

foreach $i (sort {$a <=> $b} keys %v) {
  printf "%9d : %5d : %-4s : %6.1f day(s) : %s\n", $v{$i}, $i, $l{$i}, ($smax-$v{$i})/86400, $f{$i};
}