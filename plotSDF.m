function [hf, ha, hatom, hbond] = plotSDF(filename, opts)
% plotSDF plot 3D chemical structure from SDF file
%
% plotSDF(filename) plots the given SDF file
% plotSDF() opens a dialog to select an SDF file
% plotSDF(..., name=value) defines option variables
%
% Options:
%  n: number of facets for atom spheres
%  m: number of facets for bond cylinders

arguments
    filename (1, 1) string = ""
    opts.n (1, 1) double {mustBeInteger} = 61;
    opts.m (1, 1) double {mustBeInteger} = 61;
end

%% define formats
% define table with format constants for different atoms
% add to or update table to your liking
fa = table;
c = colororder;
fa("C",  ["sz", "color"]) = {0.5, [1,1,1]*0.2};
fa("H",  ["sz", "color"]) = {0.3, [1,1,1]*0.8};
fa("N",  ["sz", "color"]) = {0.5, c(1, :)};
fa("O",  ["sz", "color"]) = {0.6, c(2, :)};
fa("F",  ["sz", "color"]) = {0.5, c(5, :)};
fa("Cl", ["sz", "color"]) = {0.7, c(5, :)};
fa("S",  ["sz", "color"]) = {0.6, c(3, :)};
fa("I",  ["sz", "color"]) = {0.6, c(4, :)};
fa("Si", ["sz", "color"]) = {0.6, c(6, :)};

% table for bond sizes/colors
fb = table();
fb(1, ["sz", "color"]) = {0.1, [1,1,1]*0.6};
fb(2, ["sz", "color"]) = {0.2, [1,1,1]*0.4};
fb(3, ["sz", "color"]) = {0.3, [1,1,1]*0.2};

%% get filename
if isempty(filename) || filename == ""
    [tempfile, tempdir] = uigetfile("*.sdf;*.*", ...
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

%% Plot
hf = figure;
ha = axes;hold on;grid on;box on;

% plot atoms as spheres
[xp, yp, zp] = sphere(opts.n);
hatom = gobjects(nAtoms, 1);
for i = 1:nAtoms
    hatom(i) = surf(xp, yp, zp, ...
        EdgeColor="none", ...
        FaceColor=fa{atom(i), "color"}, ...
        DisplayName=sprintf("Atom%03d: %s", i, atom(i)));
    hatom(i).Parent = hgtransform;
    hatom(i).Parent.Matrix = makehgtform( ...
        "translate", [x(i), y(i), z(i)], ...
        "scale", fa{atom(i), "sz"});
end

% plot the bonds as cylinders
% we create a default cylinder, and rotate it to align
% with the bond vector
vecA = [0, 0, 1];
dx = x(idx2)-x(idx1);
dy = y(idx2)-y(idx1);
dz = z(idx2)-z(idx1);
vecB = [dx, dy, dz];
lenA = 1;
lenB = vecnorm(vecB, 2, 2);
[xp, yp, zp] = cylinder(1, opts.m);
hbond = gobjects(nBonds, 1);
for i = 1:nBonds
    hbond(i) = surf(xp, yp, zp, ...
        EdgeColor="none", ...
        FaceColor=fb{bond(i), "color"}, ...
        DisplayName=sprintf("Bond%03d: %d", i, bond(i)));
    hbond(i).Parent = hgtransform;
    rotAxis = cross(vecA, vecB(i, :));
    rotAngle = acos(dot(vecA, vecB(i, :))./(lenA.*lenB(i)));
    hbond(i).Parent.Matrix = makehgtform(...
        "translate", [x(idx1(i)), y(idx1(i)), z(idx1(i))], ...
        "axisrotate", rotAxis, rotAngle, ...
        "scale", [fb{bond(i), "sz"}*[1, 1], lenB(i)]);

end

ha.XAxis.Visible = false;
ha.YAxis.Visible = false;
ha.ZAxis.Visible = false;
ha.XTick = -100:100;
ha.YTick = -100:100;
ha.ZTick = -100:100;
axis vis3d
axis equal
view(3);
material("dull");
camlight("right");

end
