#!/bin/bash

set -x

echo "Hello! starting $(date)"

sudo rm -rf phispy.img
singularity create -s 2048 phispy.img
sudo singularity bootstrap phispy.img ubuntu.sh

echo "Goodbye! ending $(date)"
