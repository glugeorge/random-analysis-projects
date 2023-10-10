%1D temperature equation - numerical solution in finite differences
%adapted from code by Dahl-Jensen and Pattyn
close all
clear all

acc=0; % accumulation

gmax=11; % number of gridpoints in vertical
dt=100; % time step (yr)
Tabs=273.15; % absolute temperature
Tsurf=162; % surface temperature in K
secperyear=31556926; % seconds per Earth year
K=2.1*secperyear; % ice conductivity
G=0.028*secperyear;
diffus=1.e-6*secperyear; % Thermal diffusivity
rho=910.; % ice density
H0=2000.; % ice thickness at ice divide
z=linspace(0,-H0,gmax); % vertical spacing
w=-acc*(z/H0+1);% approximation of vertical velocity
t=Tsurf+z*0.; % initialization of temperature
t2=t;
dz=-H0/(gmax-1);
beta=8.7e-4;
Tpmp=Tabs+z*beta;

%constant surface temperature
for k=1:500 % iteration in time
    for i=gmax:-1:1
        alpha(i)=(diffus/dz+w(i))*dt/dz;
        beta(i)=1+(2*diffus/dz+w(i))*dt/dz;
        gamma(i)=diffus*dt/dz^2;
        if i==gmax
            f(i)=1;
            g(i)=-G*dz/K;
        else
            f(i)=alpha(i)/(beta(i)-gamma(i)*f(i+1));
            g(i)=(t(i)+gamma(i)*g(i+1))/(beta(i)-gamma(i)*f(i+1));
        end
    end
    t2(1)=Tsurf; % upper boundary condition (surface temperature)
    for i=2:gmax
        t2(i)=t2(i-1)*f(i)+g(i);
        if t2(i)>Tpmp(i)
            t2(i)=Tpmp(i);
        end
    end
    t=t2; % exchange temperature profiles
    tsave(k,:)=t;
end


%CHANGING Tsurf over time
%start with surface temp from loop above


figure
subplot(4,1,1)
title('Temperature over time')
ylabel('Temp. (C)')
hold on
subplot(4,1,[2:4])
plot(t-Tabs,z,'LineWidth',2);
xlim([-60 5]);
xlabel('Temp. (C)')
ylabel('Depth [m]')
pause(0.05);
hold on
grid on;

%increase grid and temporal resolution
told=tsave(end,:);
zold=z;

gmax=51; % number of gridpoints in vertical
dt=10; % time step (yr)
z=linspace(0,-H0,gmax); % vertical spacing
w=-acc*(z/H0+1);
t=Tsurf+z*0.; % initialization of temperature
dz=-H0/(gmax-1);
beta=8.7e-4;
Tpmp=Tabs+z*beta;

tsave2(1,:)=interp1(zold,told,z);
t2=t;
dz=-H0/(gmax-1);
beta=8.7e-4;
Tpmp=Tabs+z*beta;
Tsurf2=Tsurf;
kk2=1;
timemax=20000;

for kk=1:timemax/dt
    %varying surface temperature over time
    Tsurf2=Tsurf2+0.01;
    if kk<400
        Tsurf2=Tsurf2-0.05;
    elseif kk>=400 && kk<600
        Tsurf2=Tsurf2;
    elseif kk>=600 && kk<1000
        Tsurf2=Tsurf2+0.05;
    else
        Tsurf2=min([Tsurf2 (Tsurf+10)]);
    end
    
    t=tsave2(kk,:); % initialization of temperature
    t2=t;
  % iteration in time
    for i=gmax:-1:1
        alpha(i)=(diffus/dz+w(i))*dt/dz;
        beta(i)=1+(2*diffus/dz+w(i))*dt/dz;
        gamma(i)=diffus*dt/dz^2;
        if i==gmax
            f(i)=1;
            g(i)=-G*dz/K;
        else
            f(i)=alpha(i)/(beta(i)-gamma(i)*f(i+1));
            g(i)=(t(i)+gamma(i)*g(i+1))/(beta(i)-gamma(i)*f(i+1));
        end
    end
    t2(1)=Tsurf2; % upper boundary condition (surface temperature)
    for i=2:gmax
        t2(i)=t(i-1)*f(i)+g(i);
        if t2(i)>Tpmp(i)
            t2(i)=Tpmp(i);
        end
    end
    t=t2; % exchange temperature profiles

    tsave2(kk+1,:)=t;
%plotting    
    if rem(kk,20)==1
        subplot(4,1,1)
        plot(kk*dt/1000,Tsurf2-Tabs,'*k')
        xlim([0 timemax]/1000);
        ylim([150 200]-Tabs)
        xlabel('Thousand yrs')
        hold on
        grid on
        subplot(4,1,[2:4])
        h=plot(t-Tabs,z); grid on;
        xlim([160 240]-Tabs);
        ylim([-H0 0])
        pause(0.5);
        hold all
    end
end


