#!/bin/bash


devtap  1120 645  && sleep 5 && \
    devtap  1348 889 && \
    sleep 10 && \
    echo "removing the x" && \
                 devtap  1668 105 && sleep 10

