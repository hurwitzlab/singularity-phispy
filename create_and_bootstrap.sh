#!/bin/bash

set -x

echo "Hello! starting $(date)"

sudo rm -rf phispy.img
singularity create -s 1234 phispy.img
sudo singularity bootstrap phispy.img ubuntu.sh

echo "Goodbye! ending $(date)"
