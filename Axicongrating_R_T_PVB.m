clear all
% close all

xaxistype = 0; %0 = lambda; 1 = freq

%% Parameters of original concept simulations/superK demo
% lambda = linspace(900,1200,1000)*1e-6; %[mm] wavelength)
% lambda_DG = 1064e-6; %[mm] central design wavelength
% theta_DG = 0.9/180*pi; %diffraction angle of first order for central design wavelength
% d_DG = lambda_DG/sin(theta_DG); %period of grating
% f1 = 20; %[mm] lens focal length
% w0 = 1; %[mm] beam waist

%% Parameters for Matlab testing scaled from OPA1
% lambda = linspace(545,695,1000)*1e-6; %[mm] wavelength)
% d_DG = 30e-3; %[mm] period of grating
% f1 = 25; %[mm] lens focal length
% w0 = 0.4; %[mm] beam waist

%% Parameters for INL axicon 1 and setup of July 2024 @VOXEL
% lambda = linspace(790,810,1000)*1e-6; %[mm] wavelength)
% d_DG = 10e-3; %[mm] period of grating
% f1 = 75; %[mm] lens focal length
% w0 = 2.5; %[mm] beam waistclear

%% Parameters for PHAROS
% lambda = linspace(1020,1040,1000)*1e-6; %[mm] wavelength)
% d_DG = 9e-3; %[mm] period of grating
% f1 = 50; %[mm] lens focal length
% w0 = 2.5; %[mm] beam waistclear

%% Parameters for Yb-laser pulse compressed with n2photonics
% % lambda = linspace(1010,1050,1000)*1e-6; %[mm] wavelength) 40 fs pulses
% lambda = linspace(1000,1060,1000)*1e-6; %[mm] wavelength) 25 fs pulses
% d_DG = 9e-3; %[mm] period of grating
% f1 = 50; %[mm] lens focal length
% w0 = 2.5; %[mm] beam waistclear

%% Good parameters for OPA3
% lambda = linspace(650,950,1000)*1e-6; %[mm] wavelength)
% d_DG = 40e-3; %[mm] period of grating
% f1 = 100; %[mm] lens focal length
% w0 = 3; %[mm] beam waist

%% TEST: Yb with axicon for IMPALA project
% lambda = linspace(1026,1034,100)*1e-6; %[mm] wavelength)
% d_DG = 10e-3; %[mm] period of grating
% f1 = 40; %[mm] lens focal length
% w0 = 5; %[mm] beam waistclear


%% Parameters of Ti:sapphire oscillator (80 MHz rep. rate)
% lambda = linspace(800,810,1000)*1e-6; %[mm] wavelength)
% d_DG = 3e-3; %[mm] period of grating
% f1 = 10; %[mm] lens focal length
% w0 = 15; %[mm] beam waist

%% Parameters of NOPA at Imperial College
% lambda = linspace(1250,1350,1000)*1e-6; %[mm] wavelength)
% d_DG = 26e-3; %[mm] period of grating
% f1 = 75; %[mm] lens focal length
% w0 = 5; %[mm] beam waist


%% Parameters of Yb at MP Lab
%option1
lambda = linspace(1026,1034,100)*1e-6; %[mm] wavelength)
d_DG = 9e-3; %[mm] period of grating
f1 = 35; %[mm] lens focal length
w0 = 10; %[mm] beam waist

%% Parameters of Yb at MP Lab
%option2
lambda = linspace(1026,1034,100)*1e-6; %[mm] wavelength)
d_DG = 12e-3; %[mm] period of grating
f1 = 35; %[mm] lens focal length
w0 = 10; %[mm] beam waist

%% Calculation

T_PVB = lambda*f1/(pi*w0); %thickness of perfect vortex beam (beam waist)
R_PVB = f1*lambda/d_DG; %radius of perfect vortex beam

switch xaxistype
    case 1 %freq
        xvec = 3e8./(lambda*1e-3)*1e-12;
    case 0 %lambda
        xvec = lambda*1e3;
end

figure
hold on
plot(xvec, R_PVB*1e3 + T_PVB*1e3,':k')
plot(xvec, R_PVB*1e3,'-k')
plot(xvec, R_PVB*1e3 - T_PVB*1e3,':k')
switch xaxistype
    case 1
        xlabel('f (THz)')
    case 0
        xlabel('\lambda (\mum)')
end
ylabel('R \pm T (\mum)')
axis square
box on
title(['R/T = ',num2str(round(mean(R_PVB./T_PVB))), '; 2T/d_{SLM} = ', num2str(2*mean(T_PVB)/8e-3)])


%Loop to find all wavelengths that are spatially separated as different PVBs

i = 1;
ind_lambdasep = i;
while i < length(lambda)
    [temp, ind] = min(abs(R_PVB(i)+T_PVB(i) - (R_PVB-T_PVB)));
    i = ind;
    if ind < length(lambda)
        ind_lambdasep = [ind_lambdasep, ind];
    end
end

lambda_sep = lambda(ind_lambdasep);
R_PVB_sep = R_PVB(ind_lambdasep);
T_PVB_sep = T_PVB(ind_lambdasep);

switch xaxistype
    case 1 %freq
        xvec2 = 3e8./(lambda_sep*1e-3)*1e-12;
    case 0 %lambda
        xvec2 = lambda_sep*1e3;
end

hold on
errorbar(xvec2, R_PVB_sep*1e3, T_PVB_sep*1e3,'ok','MarkerFaceColor','k')
switch xaxistype
    case 1
        xlabel('f (THz)')
    case 0
        xlabel('\lambda (\mum)')
end
ylabel('R \pm T (\mum)')
axis square
box on
title(['R/T = ',num2str(round(mean(R_PVB./T_PVB))), '; 2T/d_{SLM} = ', num2str(2*mean(T_PVB)/8e-3)])
set(gcf,'Position',[881.5714  612.4286  415.4286  344.0000])


%% Compute relation between grating period and focal legth at a given wavelength and diameter

% lambda1 = 620*1e-6; %[mm] reference wavelength
% f1 = 100; %[mm] reference lens focal length
% d_DG1 = 30e-3; %[mm] reference period of grating
% D1 = 2*f1*tan(asin(lambda1/d_DG1)); %[mm] reference diameter
% 
% d_DGlist = linspace(10,200,1000)*1e-3; %[mm] period of grating
% flist = D1/2./(tan(asin(lambda1./d_DGlist)));
% 
% figure
% plot(flist,d_DGlist*1e3)
% xlabel('Focal length (mm)')
% ylabel('Grating period (\mum)')
% axis square





