#!perl

while (<>) {
  chomp;
  s/\x1b\[[0-9;]*[mHfABCDsuJKhl]//g;

#Fighters: 8,000 (the Ferrengi) [Offensive]
#Fighters: 1,000 (belong to Corp#6, Psilocybin Cubensis) [Defensive]
#Mines   : 5 (Type 1 Armid) (belong to Corp#6, Psilocybin Cubensis)

  # set density for sector
  if (/^Sector[\s\(]+(\d+)[\s\)]+==>\s+(\d*),?(\d*).*Anom : (Yes|No)/)
  {
    $d=$2.$3;
    if ($d > $dens{$1}) { $dens{$1}=$d; }
    if (!$tag{$1} && ($dens{$1} > 499))
    {
       $tag{$1}="HIGHDENS";
    }

    # set anomanly flag for sector
    if ($4 eq "Yes")
    {
      $anom{$1}=1;
      if (!$tag{$1})
      {
         $tag{$1}="ANOM";
      }
    }
  }

  # store sector number
  if (/^Sector  : (\d+)/)
  {
    $sector=$1;
  }

  # store port type for sector
  if (/^Ports   : .*, Class \d \((\w{3})\)/) 
  {
    $ptype{$sector}=$1;
  }

  # store mine info for sector
  if (/(\d+) \(Type 1 Armid\) \(belong to /)
  {
    $minec{$sector}=$1;
    $mine{$sector}=1;
  }

  # store fig info for sector
  if (/^Fighters: /)
  {
    # store fig count and owner
    if (/(\d*)(,(\d+))? \(belong to (.*)\) \[/)
    {
      $figc{$sector}=$1.$3;
      $name=$4;
      $name=~s/,//;
    }
    elsif (/(\d*)(,(\d+))? \((.*)\) \[/)
    {
      $figc{$sector}=$1.$3;
      $name=$4;
      $name=~s/,//;
    }

    # store fig owner in $tag unless they are owned by your corp
    unless (/belong to your Corp/ | /yours/)
    {
      $tag{$sector}=$name;
    }
  }
}

print "  sec   figs      dens a m  mc prt description\n";
foreach $k (sort {$a <=> $b} keys %tag) {
  if ($k > 10) {
    printf "%5d %6d %9d %1d %1d %3d %3s %s\n", $k, $figc{$k}, $dens{$k}, $anom{$k}, $mine{$k}, $minec{$k}, $ptype{$k}, $tag{$k};
  }
}