#!perl
while (<>) {
  chomp;
  s/\xff.//g;                        # strip telnet protocol commands
  s/[\x0a\x07,]//g;                  # strip line feed, bell, and comma
  s/\x1b\[[0-9;]*[mHfABCDsuJKhl]//g; # strip ansi codes
  print "$_\n";
}