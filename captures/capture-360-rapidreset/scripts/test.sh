#!/bin/bash
X=1500
echo $X
mx="$X";my="$X";head -c "$((3*mx*my))" /dev/urandom | convert -depth 8 -size "${mx}x${my}" RGB:- random.png