#!/bin/bash

PROCESS=$1
for i in `ps aux | grep [c]lient | grep ${PROCESS} | awk '{print $2}'`; do 
    kill -9 $i  
done

