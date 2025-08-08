#!/bin/bash
# script to download example SDF files from NIST
# These are just a couple of interesting examples
# you can download many others from webbook.nist.gov
# search for the chemical you're interested in
# click "3d SD file" underneath the Chemical structure header to download

# caffeine
curl https://webbook.nist.gov/cgi/cbook.cgi?Str3File=C58082 -o caffeine.sdf

# tnt
curl https://webbook.nist.gov/cgi/cbook.cgi?Str3File=C118967 -o tnt.sdf

# benzene
curl https://webbook.nist.gov/cgi/cbook.cgi?Str3File=C71432 -o benzene.sdf

# buckminsterfullerene
curl https://webbook.nist.gov/cgi/cbook.cgi?Str3File=C99685968 -o C60.sdf
