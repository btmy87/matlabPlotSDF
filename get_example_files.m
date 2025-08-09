% script to download example SDF files from NIST
% These are just a couple of interesting examples
% you can download many others from webbook.nist.gov
% search for the chemical you're interested in
% click "3d SD file" underneath the Chemical structure header to download
%
% matlab script can be run in matlab-online environment

fprintf("Downloading example SDF files from webbook.nist.gov\n\n");
% caffeine
system("curl https://webbook.nist.gov/cgi/cbook.cgi?Str3File=C58082 -o caffeine.sdf");

% tnt
system("curl https://webbook.nist.gov/cgi/cbook.cgi?Str3File=C118967 -o tnt.sdf");

% benzene
system("curl https://webbook.nist.gov/cgi/cbook.cgi?Str3File=C71432 -o benzene.sdf");

% buckminsterfullerene
system("curl https://webbook.nist.gov/cgi/cbook.cgi?Str3File=C99685968 -o C60.sdf");
