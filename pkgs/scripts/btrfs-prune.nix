# nukes readonly btrfs files relative the current directory
# not really usefull for anyone besides me
#
# arguments
# 1: Month
# ..: days (use seq 10 12 for a range)
{writers}:
writers.writeFishBin "btrfs-prune" ''
  for day in $argv[2..];
      if test "$day" -le "9" ;
        set day "0$day"
      end

      set month "$argv[1]"
      set dir "$month$day"

      echo $dir;

      btrfs property set ./$dir ro false
      rm -rf ./$dir
  end
''
