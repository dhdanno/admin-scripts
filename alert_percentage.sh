#!/bin/sh

if ( fs_cli -x 'g729_available' |grep "true" >/dev/null 2>&1 ); then
  TOTAL=`fs_cli -x 'g729_count'`
  AVAILABLE=`fs_cli -x 'g729_info' | grep available | awk '{print $5}'`
  ALLOCATED=`fs_cli -x 'g729_info' | grep allocated | awk '{print $5}'`
  TOTAL=`echo "scale=1;$AVAILABLE+$ALLOCATED" | bc -l | sed 's/\..*//'`
  PCTUSED=`echo "scale=1;$ALLOCATED/$TOTAL*100" | bc -l | sed 's/\..*//'`

  if [ $PCTUSED -gt 80 ]; then
    echo "CRITICAL - More than 80% used";
    exit 2;
  else if [ $PCTUSED -gt 65 ]; then
      echo "WARNING - More than 65% used";
      exit 1;
    else
      echo "OK - Less than 65% used";
    fi
  fi
else
  echo "CRITICAL - G729 not loaded!";
  exit 2;
fi

exit 0;
