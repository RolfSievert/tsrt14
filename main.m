%% 7.2.1 Sensor calibration
clear all;
load calibration;

M=8;    %#Microphones/sensors in the SN
N_samples=length(tphat);    %#Samples in the calibration data

e=zeros(N_samples,M);   %Allocate memory

%NOTE: The estimated TOA measurements is 2-dimensional!
tphat_bar=mean(tphat,2);    %Mean of the calibration data

%Measurement errors of the calibration data for each sensor
%(measurement noise)
for i=1:M
    e(:,i)=tphat(:,i)-tphat_bar;
end

for i=1:M
    [N,l]=hist(e(:,i),20);
    Wb=l(2)-l(1);   %Bin width
    Ny=length(e(:,i));  %Nr of samples
    
    figure(i)
    %EPDF of the measurement noise for sensor i
    bar(l,N/(Ny*Wb));
    hold on;
    
    %N-distribution of the measurement noise
    pe=ndist(mean(e(:,i)),var(e(:,i)));
    
    plot(pe)    %Plot the N-distribution
end

%% 7.2.2 Signal modeling
clear all;
%Micophone positions in setup 1
th_1=[0 0.29 0 0.87 0.44 0.98 0.96 0.73 1.24 0.45 1.15 0.01 0.45 -0.085 ...
    0.25 0.02];
%Micophone positions in setup 2
th_2=[-0.02 0.36 -0.02 0.41 -0.02 0.46 -0.02 0.51 -0.02 0.56 -0.02 0.61 ...
    -0.02 0.66 -0.02 0.71];
x0=[0.39 0.1];  %Robot start/initial position
nx=2;  %Dimension of robots position

M=8;    %#Microphones/sensors in the SN
N=1;    %#Targets (1 robot)

%2D TDOA as range differences for configuration 1
stdoa_1=exsensor('tdoa2',M,N,nx);    %Create TDOA network object
stdoa_1.x0=x0;
stdoa_1.th=th_1;

%2D TDOA as range differences for configuration 2
stdoa_2=exsensor('tdoa2',M,N,nx);    %Create TDOA network object
stdoa_2.x0=x0;
stdoa_2.th=th_2;

