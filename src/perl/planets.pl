#!perl

$pin=0;
while (<>) {
  chomp;
  s/\x0D//;
  s/\x1b\[[0-9;]*[mHfABCDsuJKhl]//g;

  # sector display %list1
  if (/^Sector  :\s+(\d+)/) { $sect=$1; }
  if (/^(.........)/)       { $pin=0 if ($1 ne "Planets :") and ($1 ne "         "); }
  if (/^Planets : (<<<< )?(.*)$/)   {
                              $pin=1;
                              my $name=$2;
                              if ($name=~/(.*?) >>>> \(Shielded\)/) { $name=$1; }
                              $label1=sprintf("%5d %s",$sect,$name); 
                              $list1{$label1}=0 unless $list1{$label1}>0;
                            }
  elsif (/^          (<<<< )?(.*)$/ and $pin)
                            {
                              my $name=$2;
                              if ($name=~/(.*?) >>>> \(Shielded\)/) { $name=$1; }
                              $label1=sprintf("%5d %s",$sect,$name); 
                              $list1{$label1}=0 unless $list1{$label1}>0;
                            }

  # planet display
  if (/^Planet .(\d+) in sector (\d+): (.*)$/) { $num=$1; $sect=$2; $name=$3; }
  if (/^Class (.)(.*?), (.*)$/)                { $class2=$1.$2; $class1=$1}
  if (/^Created by: (.*)$/)                    {
                                                 $label1=sprintf("%5d %s",$sect,'('.$class1.') '.$name); 
                                                 $label2=sprintf("%3d (%s) %s (%s)", $num, $class2, $name, $1);
                                                 $list2{$label2}=$sect;
                                                 $cit{$label2}=0;
                                                 $cons{$label2}=0;
                                                 $dupe{$label1}=$label2;
                                               }
  if (/Planet has a level (\d) Citadel,/) { $cit{$label2}=$1; }
  if (/under construction, (\d+) day\(s\) till complete./) { $cons{$label2}=$1; }

}

print "planet displays:\n";
print " sect c  d num description\n";
foreach $k (sort keys %list2) {
  printf "%5d %1d %2d %s\n", $list2{$k}, $cit{$k}, $cons{$k}, $k;
}

print "\nsector scans (weeded out):\n";
print " sect description\n";
foreach $k (sort keys %list1) {
  unless ($dupe{$k}) { printf "%s\n", $k; }
}