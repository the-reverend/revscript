#!perl

use Time::Local;

$base=timelocal(0,0,0,1,0,2000);

# adjust for dst
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
$base=$base-3600 if ($isdst);

$now=0;
$smax=0;
$sector=0;

$_="10:07:10 PM Tue Jan 22, 2019";
$twtime=222816206;

#226191090 03-01-2007 21:44:10 226276389 03-01-2007 21:58:37 226277256
$_="10:51:30 PM Fri Mar 01, 2019";
$twtime=226191090;

  chomp;

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
   $stamp=$now-$base;
  }
printf "%s %s %s %s %s", $_, $base, $now, $stamp, $twtime
