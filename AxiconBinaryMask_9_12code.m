clearvars; clc;

%% GDSII design for Single Farfield Mask (17mm x 17mm)
addpath(genpath('C:\Users\sofia\Documents\Axicon\BinaryAxicon\GDSII Library\'));

% Create a structure to hold elements
bs = gds_structure('Axicon');

%% Define single 17mm frame with 100 µm border
square_size = 17000;     % Size of the square [µm]
border_width = 100;      % Border thickness [µm]

% Function to create border polygon with inner hole
create_border = @(x0, y0) [ ...
    % Outer square
    x0, y0;
    x0, y0 + square_size;
    x0 + square_size, y0 + square_size;
    x0 + square_size, y0;
    x0, y0;
    % Inner square (reversed to create hole)
    flipud(border_width + [ ...
        x0, y0;
        x0, y0 + square_size - 2*border_width;
        x0 + square_size - 2*border_width, y0 + square_size - 2*border_width;
        x0 + square_size - 2*border_width, y0;
        x0, y0;
    ]); 
    x0, y0; % Close the polygon
];

% Create and add the border
border_poly = create_border(0, 0);
bs(end+1) = gds_element('boundary', 'xy', border_poly, 'layer', 1);

%% Axicons inside the single 17mm frame (no individual frames)
asize = 2;                % 2x2 axicons
wa = 5000;                % Axicon diameter [µm]
spacing = 8000;           % Spacing between axicons [µm]
usable_size = square_size - 2*border_width;

% Cálculo automático do offset para centralizar os axicons com espaçamento desejado
total_axicons_span = (asize - 1) * spacing + wa;  % Espaço ocupado no layout
offset = (usable_size - total_axicons_span) / 2;  % Margem igual em todos os lados

% Generate center positions (2x2 layout)
[xx, yy] = meshgrid(0:asize-1);
centers = border_width + offset + wa/2 + spacing * [xx(:), yy(:)];

% Define grating periods for each axicon (in µm)
grating_periods = [9, 12, 9, 12];  % Different periods for each axicon

% Create axicons
v = 200; % Vertices per polygon

for n = 1:size(centers, 1)
    p(n) = grating_periods(n);  % Set the grating period for each axicon
    
    r = p(n)/4 : p(n)/2 : wa/2;
    
    % Center circle
    circ = nsidedpoly(v, 'Center', centers(n,:), 'Radius', r(1));
    bs(end+1) = gds_element('boundary', 'xy', circ.Vertices, 'layer', 1);
    
    % Rings
    for m = 1:length(r)/2 - 1 + rem(length(r), 2)
        circ1 = nsidedpoly(v, 'Center', centers(n,:), 'Radius', r(2*m));
        circ2 = nsidedpoly(v, 'Center', centers(n,:), 'Radius', r(2*m+1));
        ring = [circ1.Vertices; circ1.Vertices(1,:); circ2.Vertices(1,:); flip(circ2.Vertices); circ1.Vertices(1,:)];
        bs(end+1) = gds_element('boundary', 'xy', ring, 'layer', 1);
    end

    % Add text with the grating period
    text_position = centers(n,:) + [wa/2 + 200, 0];  % Position text to the right of each axicon
    period_text = sprintf('%d µm', p(n));  % Format the text with the grating period
    bs(end+1) = gds_element('text', 'xy', text_position, 'text', period_text, 'layer', 2);
end

% Export GDS
gdslib = gds_library('single_frame', 'uunit',1e-6, 'dbunit',1e-9, bs);
write_gds_library(gdslib, '!Axicon9and12.gds');
