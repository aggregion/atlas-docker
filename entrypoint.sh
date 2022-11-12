#!/bin/bash

/configure.sh


"$ATLAS_BIN"/atlas_start.py && tail --pid=$(cat $ATLAS_HOME/logs/atlas.pid) -f /dev/null
