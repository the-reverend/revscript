#!perl
while (<>) {
  chomp;
  s/\x1b\[[0-9;]*[mHfABCDsuJKhl]//g;
  s/,//;

#<Port>

# Items     Status  Trading % of max OnBoard
# -----     ------  ------- -------- -------
#Fuel Ore   Selling   2570    100%      50
#Organics   Buying    2070    100%       0
#Equipment  Selling   1290    100%       0

#We are selling up to 2930.  You have 0 in your holds.
#How many holds of Equipment do you want to buy [1]? 
#Agreed, 1 units.

#We'll sell them for 53 credits.
#Your offer [53] ? 0

  if (/<Port>/)                                                { $in=1; $price=0; $holds=0; }
  if ($in and /Organics\s+Buying\s+(\d+)\s+(\d+)%/)            { $in=0 if ($1>3000 or $2<100); }
  if ($in and /Organics do you want to sell \[(\d+)\]\?/)      { $holds=$1; }
  if ($in and /Organics do you want to sell \[\d+\]\? (\d+)/)  { $holds=$1; }
  if ($in and $holds>0 and /We'll buy them for (\d+) cred/)    { $price=$1/$holds; }

  # <P-Probe estimates your offer was  94.47% of best price>
  if ($in and /P-Probe estimates your offer was\s+(\d+(\.\d+)?)%/) { $price=$price*100/$1; }
  
  if ($in and $price>0 and /:\d+\]:\[(\d+)\]/)
  {
    printf "%5d : bo %3.1f\n", $1, $price;
    printf "- bo %3.1f : %5d\n", $price, $1;
    $in=0;
  }

}