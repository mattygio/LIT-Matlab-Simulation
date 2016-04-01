

%% Setup Arduinos and Simulation

rows = 4;
cols = 4;
sim = simulation(rows,cols,1);


%% Move Arduinos

simTime = 2.00;
f = @(x,y)(-10); sim.moveArduinos(f,simTime);
f = @(x,y)(-3); sim.moveArduinos(f,simTime);
f = @(x,y)((2.*cos(x))-8); sim.moveArduinos(f,simTime);
f = @(x,y)((-sqrt(1./(((x./2)-2.25).^2.*((y./2)-2.25).^2))/2)-2); sim.moveArduinos(f,simTime);
f = @(x,y)(((sin(5.*((x./8)-4)).*cos(5.*((y./8)-4))./8)*50)-8); sim.moveArduinos(f,simTime);
f = @(x,y)((-1./(15.*((x-4.5).^2+(y-4.5).^2))./9)*500); sim.moveArduinos(f,simTime);
% f = @(x,y)((imag(asin(((x/1.5)-2).*((y/1.5)-2)))-4)*2); sim.moveArduinos(f,simTime);
% f = @(x,y)(-sqrt(134-x.^2-y.^2)); sim.moveArduinos(f,simTime);
% f = @(x,y)(-sqrt(40-(x-4).^2-(y-4).^2)); sim.moveArduinos(f,simTime);
% f = @(x,y)((1/8)*(-(x-8).^2-(y-8).^2)); sim.moveArduinos(f,simTime);
% f = @(x,y)(-(1/25)*((x-6).^3-3.*(x-6)+(y-4).^3-3.*(y-4))-7); sim.moveArduinos(f,simTime);
% f = @(x,y)(-5); sim.moveArduinos(f,simTime);
% 
% % simTime = 1.50;
% f = @(x,y)(-(1/25)*((x-6).^3-3.*(x-6)+(y-4).^3-3.*(y-4))-7); sim.moveArduinos(f,simTime);
% f = @(x,y)((-1./(15.*((x-4.5).^2+(y-4.5).^2))./9)*500); sim.moveArduinos(f,simTime);
% f = @(x,y)(((sin(5.*((x./8)-4)).*cos(5.*((y./8)-4))./8)*50)-8); sim.moveArduinos(f,simTime);
% f = @(x,y)(-(1/25)*((x-6).^3-3.*(x-6)+(y-4).^3-3.*(y-4))-7); sim.moveArduinos(f,simTime);
% 
% % simTime = 0.75;
% f = @(x,y)((-1./(15.*((x-4.5).^2+(y-4.5).^2))./9)*500); sim.moveArduinos(f,simTime);
% f = @(x,y)(-(1/25)*((x-6).^3-3.*(x-6)+(y-4).^3-3.*(y-4))-7); sim.moveArduinos(f,simTime);
% f = @(x,y)((-sqrt(1./(((x./2)-2.25).^2.*((y./2)-2.25).^2))/2)-2); sim.moveArduinos(f,simTime);
% f = @(x,y)((1/8)*(-(x-8).^2-(y-8).^2)); sim.moveArduinos(f,simTime);
% f = @(x,y)(-sqrt(40-(x-4).^2-(y-4).^2)); sim.moveArduinos(f,simTime);
% f = @(x,y)(((sin(5.*((x./8)-4)).*cos(5.*((y./8)-4))./8)*50)-8); sim.moveArduinos(f,simTime);
% f = @(x,y)(-sqrt(134-x.^2-y.^2)); sim.moveArduinos(f,simTime);
% f = @(x,y)(-(1/25)*((x-6).^3-3.*(x-6)+(y-4).^3-3.*(y-4))-7); sim.moveArduinos(f,simTime);
% f = @(x,y)((-1./(15.*((x-4.5).^2+(y-4.5).^2))./9)*500); sim.moveArduinos(f,simTime);
% f = @(x,y)(-(1/25)*((x-6).^3-3.*(x-6)+(y-4).^3-3.*(y-4))-7); sim.moveArduinos(f,simTime);
% f = @(x,y)((-sqrt(1./(((x./2)-2.25).^2.*((y./2)-2.25).^2))/2)-2); sim.moveArduinos(f,simTime);
% f = @(x,y)((1/8)*(-(x-8).^2-(y-8).^2)); sim.moveArduinos(f,simTime);
% f = @(x,y)(-sqrt(40-(x-4).^2-(y-4).^2)); sim.moveArduinos(f,simTime);
% f = @(x,y)(((sin(5.*((x./8)-4)).*cos(5.*((y./8)-4))./8)*50)-8); sim.moveArduinos(f,simTime);
% f = @(x,y)(-sqrt(134-x.^2-y.^2)); sim.moveArduinos(f,simTime);

sim.resetArduinoPositions(simTime);

sim.displaySimProperties();

%% Export Data
% Uncomment line below to export data

scaleFactor = 2.5;
sim.exportHeightData(scaleFactor);

