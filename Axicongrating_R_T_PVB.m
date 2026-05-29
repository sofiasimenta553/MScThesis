clear all
% close all

xaxistype = 0; %0 = lambda; 1 = freq

%% Parameters of NOPA at Imperial College
% lambda = linspace(1250,1350,1000)*1e-6; %[mm] wavelength)
% d_DG = 27e-3; %[mm] period of grating
% f1 = 75; %[mm] lens focal length
% w0 = 5; %[mm] beam waist

%% Parameters of Yb at INESC MN
%option1
lambda = linspace(1026,1034,100)*1e-6; %[mm] wavelength)
d_DG = 9e-3; %[mm] period of grating
f1 = 35; %[mm] lens focal length
w0 = 10; %[mm] beam waist

%% Parameters of Yb at INESC MN
%option2
lambda = linspace(1026,1034,100)*1e-6; %[mm] wavelength)
d_DG = 12e-3; %[mm] period of grating
f1 = 35; %[mm] lens focal length
w0 = 10; %[mm] beam waist


%% Parameters of POLIMI
%option1
lambda = linspace(515,700,1000)*1e-6; %[mm] wavelength) %550, 780
d_DG = 27e-3; %[mm] period of grating
f1 = 150; %[mm] lens focal length 
w0 = 2; %[mm] beam waist


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





