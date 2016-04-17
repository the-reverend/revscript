#!perl
while (<>) {
  chomp;
  s/\x1b\[[0-9;]*[mHfABCDsuJKhl]//g;
  s/,//;

#<Port>

# Items     Status  Trading % of max OnBoard
# -----     ------  ------- -------- -------
#Fuel Ore   Buying    2570    100%       0
#Organics   Buying    2070    100%       0
#Equipment  Selling   1290    100%       0

#We are buying up to 2570.  You have 0 in your holds.
#How many holds of Fuel Ore do you want to sell [50]? 10
#Agreed, 10 units.

#We'll buy them for 433 credits.
#Your offer [433] ? 0

  if (/<Port>/)                                               { $in=1; $price=0; $holds=0; }
  if ($in and /Fuel Ore\s+Buying\s+(\d+)\s+(\d+)%/)           { $in=0 if ($1>3000 or $2<100); }
  if ($in and /Fuel Ore do you want to sell \[(\d+)\]\?/)     { $holds=$1; }
  if ($in and /Fuel Ore do you want to sell \[\d+\]\? (\d+)/) { $holds=$1; }
  if ($in and $holds>0 and /We'll buy them for (\d+) cred/)   { $price=$1/$holds; }
  
  if ($in and $price>0 and /:\d+\]:\[(\d+)\]/)
  {
    printf "%5d : bf %3.1f\n", $1, $price;
    printf "- bf %3.1f : %5d\n", $price, $1;
    $in=0;
  }

}