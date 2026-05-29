clear all
close all

% --- USER PARAMETERS ---
Wa    = 2000;    % axicon diameter [µm]
p     = 27;      % radial period of the axicon [µm]
Ngray = 4096;    % physically printable grayscale levels per period
Delta = 0.4;     % pixel size [µm/pixel]
% -----------------------

% Image grid (coordinates in µm)
npix = ceil(Wa/Delta);   % number of pixels per side
[xi, yi] = meshgrid( (-(npix-1)/2 : (npix-1)/2) * Delta );
r = sqrt(xi.^2 + yi.^2); % radius of each pixel

% Grayscale level as a function of radius
rmod  = mod(r, p);                         % radius folded within one period [0,p[
level = floor( rmod / (p/Ngray) );         % indices 0 ... Ngray-1

% --- INVERT HERE ---
level = (Ngray-1) - level;

% Outside the axicon (r > Wa/2) → level 0 (no dose / minimum)
level(r > Wa/2) = 0;

% Map levels to 16-bit values (0–65535)
img16 = uint16( level * (65535/(Ngray-1)) );

% --- Write 16-bit TIFF ---
t = Tiff('axicon.tif','w');
tag.ImageLength     = size(img16,1);
tag.ImageWidth      = size(img16,2);
tag.Photometric     = Tiff.Photometric.MinIsBlack;
tag.BitsPerSample   = 16;
tag.SamplesPerPixel = 1;
tag.SampleFormat    = Tiff.SampleFormat.UInt;

% Correct physical scale: pixels per centimeter
px_per_cm = 1e4 / Delta;          % 1 cm = 10000 µm
tag.XResolution    = px_per_cm;
tag.YResolution    = px_per_cm;
tag.ResolutionUnit = Tiff.ResolutionUnit.Centimeter;

t.setTag(tag);
t.write(img16);
t.close();

