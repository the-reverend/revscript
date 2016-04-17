#!perl

while (<>) {
  chomp;
  s/\x1b\[[0-9;]*[mHfABCDsuJKhl]//g;
  if (/^Sector  : (\d+)/)                    { $sector=$1; }
  if (/(C: (.+))/) { printf "%5d %s\n", $sector, $1; }
  elsif (/(R [\w ]{6} (.+))/)  { printf "%5d %s\n", $sector, $1; }
  elsif (/(F [\w ]{6} (.+))/)  { printf "%5d %s\n", $sector, $1; }
  elsif (/(P [\w ]{6} (.+))/)  { printf "%5d %s\n", $sector, $1; }
  elsif (/(P: (.+))/) { printf "%5d %s\n", $sector, $1; }
  elsif (/(S: (.+))/) { printf "%5d %s\n", $sector, $1; }
  elsif (/(F: (.+))/) { printf "%5d %s\n", $sector, $1; }
  elsif (/^('(.+))/)   { printf "%5d %s\n", $sector, $1; }
  elsif (/^(`(.+))/)   { printf "%5d %s\n", $sector, $1; }
}