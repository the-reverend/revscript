#!perl

$nmin1=0; $nmin2=0; $nmin3=0;
$nmax1=-100; $nmax2=-100; $nmax3=-100;

$pmin1=100; $pmin2=100; $pmin3=100;
$pmax1=0; $pmax2=0; $pmax3=0;

while (<>) {
  chomp;
  s/\x1b\[[0-9;]*[mHfABCDsuJKhl]//g;
  if (/<I> Ore:\s*(-?\d+)\s+<J> Org:\s*(-?\d+)\s+<K> Equ:\s*(-?\d+)/) { 
   if ($1<0) { $nmin1=$1 if $1<$nmin1; $nmax1=$1 if $1>$nmax1; }
   else      { $pmin1=$1 if $1<$pmin1; $pmax1=$1 if $1>$pmax1; }
   if ($2<0) { $nmin2=$2 if $2<$nmin2; $nmax2=$2 if $2>$nmax2; }
   else      { $pmin2=$2 if $2<$pmin2; $pmax2=$2 if $2>$pmax2; }
   if ($3<0) { $nmin3=$3 if $3<$nmin3; $nmax3=$3 if $3>$nmax3; }
   else      { $pmin3=$3 if $3<$pmin3; $pmax3=$3 if $3>$pmax3; }
  }
}
print "$nmin1 $nmax1 / $nmin2 $nmax2 / $nmin3 $nmax3\n";
print "$pmin1 $pmax1 / $pmin2 $pmax2 / $pmin3 $pmax3\n";