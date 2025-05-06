#!/bin/awk -f
BEGIN {
  FS = "([ ]?:[ ]+)";
  print "DEVICE, BATTERY_LVL";
}

/^Device/ { current_dev=$2;}
/^\s+percentage/{ batteries[current_dev]=$2; }

END {
    for(device in batteries){
        print device "," batteries[device];
    }
}
