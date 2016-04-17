#!perl

### read log and look for planets
while (<>) {
  chomp;
  s/\x1b\[[0-9;]*[mHfABCDsuJKhl]//g;
  if (/^\s+\d+.*?Level 1/) { print "$_\n"; }
#  if (/FM/) {$c+=1;}
#  if (/^\d+\s/) {$d+=1;}
#  if (/^\d+\s+>\s+[()\d]+\s+>/) {$mw+=1;}
#  if (/(\d+\s+){6}\d+/) {$n+=6;}
#  elsif (/(\d+\s+){5}\d+/) {$n+=5;}
#  elsif (/(\d+\s+){4}\d+/) {$n+=4;}
#  elsif (/(\d+\s+){3}\d+/) {$n+=3;}
#  elsif (/(\d+\s+){2}\d+/) {$n+=2;}
#  elsif (/(\d+\s+){1}\d+/) {$n+=1;}
}