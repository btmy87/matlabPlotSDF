function [x,y,z,atom,idx1,idx2,bond] = readSDF(filename)
% readSDF read data from SDF file
%
% INPUTS:
%  - filename: name of input file, or "" to select file from dialog
%
% OUTPUTS:
%  - x: (n, 1) double x-coordinate of atom location
%  - y: (n, 1) double y-coordinate of atom location
%  - z: (n, 1) double z-coordinate of atom location
%  - atom: (n, 1) string with chemical symbol for atom
%  - idx1: (m, 1) index into x,y,z arrays for start of bond
%  - idx2: (m, 1) index into x,y,z arrays for end of bond
%  - bond: (m, 1) bond strength, 1=single bond, 2=double bond, 3=tripple
%  bond

arguments
    filename (1, 1) string = ""
end

%% get filename
if isempty(filename) || filename == ""
    [tempfile, tempdir] = uigetfile(["*.sdf";"*.*"], ...
        "Select SDF file", ...
        MultiSelect="off");
    if isnumeric(tempfile)
        fprintf("plotSDF: No file selected.\n");
        return;
    end
    filename = fullfile(tempdir, tempfile);
end

assert(exist(filename, "file"), ...
    "plotSDF: file does not exist, %s\n", filename);

%% read file
fid = fopen(filename);
assert(fid > 0, ...
    "plotSDF: error opening file, %s\n", filename);

try
    % 4th line has atom and bond counts
    for i = 1:4
        txt = fgetl(fid);
    end
    n = sscanf(txt, "%3d%3d", [1, 2]);
    nAtoms = n(1);
    nBonds = n(2);

    % read atom locations and types
    x = zeros(nAtoms, 1);
    y = zeros(nAtoms, 1);
    z = zeros(nAtoms, 1);
    atom = strings(nAtoms, 1);

    for i = 1:nAtoms
        txt = strtrim(fgetl(fid));
        temp = textscan(txt, "%f %f %f %s", 1);
        x(i) = temp{1};
        y(i) = temp{2};
        z(i) = temp{3};
        atom(i) = string(temp{4});
    end

    % read bond start index, stop index, and bond level
    % indices are 3-digits, and will run into one another if
    % there are more than 100 atoms, breaking scanning functions
    idx1 = zeros(nBonds, 1);
    idx2 = zeros(nBonds, 1);
    bond = zeros(nBonds, 1);
    for i = 1:nBonds
        txt = char(fgetl(fid));
        idx1(i) = str2double(txt(1:3));
        idx2(i) = str2double(txt(4:6));
        bond(i) = str2double(txt(7:9));
    end

catch ME
    % try to close file if we error
    fclose(fid);
    rethrow(ME);
end