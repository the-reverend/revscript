#!perl

### read log and look for fig hit data
while (<>) {
  chomp;
  s/\x1b\[[0-9;]*[mHfABCDsuJKhl]//g;

  if (/Received from Deployed Fighters at (\d+)(:\d+:\d+) ([AP])M S\.D\. (\d+\/\d+\/\d+):/) {
    if ($3 eq "P" and $1 < 12) { $time=($1+12).$2; }
    else { $time=$1.$2; }
    $date=$4;
  }
  if (/> Report Sector (\d+): (.*) entered sector./) {
    printf("%-5d: %s, %s - ENTER %s\n", $1, $date, $time, $2);
  }
  if (/> Your fighters in sector (\d+) destroyed a Sub Space Ether Probe./) { $sect=$1; }
  if (/transmission to (.*)'s I.D. code./) {
    printf("%-5d: %s, %s - PROBE %s\n", $sect, $date, $time, $1);
  }

  if (/^Sector  :\s+(\d+)/) { $sect=$1; }
}