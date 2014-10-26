#!/bin/bash

VAR1=${VAR1:-defaultvalue}

echo "====> Show environment variables"
env 

# If the container stop, don't run this part
# docker start will run this script
if [ ! -f /.dockerstatus ]
then
   	# you code here
    echo "====> Create status file to be idempotent"
    echo "done" > /.dockerstatus
else
    echo "X ====> Not the first time, don't run configure. If you wan't remove /.dockerstatus"
fi

# Run here in foreground runit/supervisord or whatever you want
echo "====> Finished. Running XXX in FOREGROUND"
exec XXX

