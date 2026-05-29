clear all
close all

% --- PARÂMETROS DO UTILIZADOR ---
Wa    = 500;    % diâmetro do axicon [µm]
p     = 27;       % período radial do axicon [µm]
Ngray = 4096;       % níveis de cinzento fisicamente imprimíveis por período
Delta = 0.4;      % tamanho de pixel [µm/pixel]
% -------------------------------------------

% Grelha da imagem (coordenadas em µm)
npix = ceil(Wa/Delta);   % número de pixeis por lado
[xi, yi] = meshgrid( (-(npix-1)/2 : (npix-1)/2) * Delta );
r = sqrt(xi.^2 + yi.^2); % raio de cada pixel

% Nível de cinzento em função do raio (perfil periódico em r)
% Cada nível tem largura ≈ p/Ngray = 27/32 ≈ 0.84 µm (~1 pixel)
rmod  = mod(r, p);                         % raio "dobrado" dentro de um período [0,p[
level = floor( rmod / (p/Ngray) );         % índices 0 ... Ngray-1
% --- INVERT HERE ---
level = (Ngray-1) - level;

% Fora do axicon (r > Wa/2) → nível 0 (sem dose / mínimo)
level(r > Wa/2) = 0;

% Mapear níveis para 16 bits (0–65535)
img16 = uint16( level * (65535/(Ngray-1)) );


% --- Escrever TIFF 16-bit ---
t = Tiff('axicon.tif','w');
tag.ImageLength     = size(img16,1);
tag.ImageWidth      = size(img16,2);
tag.Photometric     = Tiff.Photometric.MinIsBlack;
tag.BitsPerSample   = 16;
tag.SamplesPerPixel = 1;
tag.SampleFormat    = Tiff.SampleFormat.UInt;

% Escala física correcta: pixels por centímetro
px_per_cm = 1e4 / Delta;          % 1 cm = 10000 µm
tag.XResolution   = px_per_cm;
tag.YResolution   = px_per_cm;
tag.ResolutionUnit = Tiff.ResolutionUnit.Centimeter;

t.setTag(tag);
t.setTag(tag);
t.write(img16);
t.close();

