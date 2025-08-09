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
%  rotateLight: true/false reset light after rotation

arguments
    filename (1, 1) string = ""
    opts.n (1, 1) double {mustBeInteger} = 61;
    opts.m (1, 1) double {mustBeInteger} = 61;
    opts.rotateLight (1, 1) logical = false;
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

%% read file
[x,y,z,atom,idx1,idx2,bond] = readSDF(filename);

nAtoms = length(x);
nBonds = length(idx1);

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

% make camlight rotate with object
hlight = camlight("right");
if opts.rotateLight
    r = rotate3d();
    r.ActionPostCallback = @(~, ~) camlight(hlight, "right");
end
end
