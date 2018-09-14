function [temp,pressure,density] = standatm( alt )
%STANDATM  A function that accepts an altitude and returns t, p, and rho
%   Its just a glorified case structure that calls local functions
%   "isotherm" or "grad". Both of these members are simply passed the
%   parameter "alt" and they return an array containing temperature,
%   pressure, and density.
if alt >= 0 && alt <= 11
    [temp,pressure,density] = grad(alt);
elseif alt > 11 && alt <= 25
    [temp,pressure,density] = isotherm(alt);
elseif alt > 25 && alt <= 47
    [temp,pressure,density] = grad(alt);
elseif alt > 47 && alt <= 53
    [temp,pressure,density] = isotherm(alt);
elseif alt > 53  && alt <= 79
    [temp,pressure,density] = grad(alt);
elseif alt > 79 && alt <= 90
    [temp,pressure,density] = isotherm(alt);
elseif alt > 90 && alt <= 105
    [temp,pressure,density] = grad(alt);
end
end

function [temp,pressure,density] = isotherm ( alt )
%ISOTHERM I dont feel like typing these equations over and over.
%   Still just a glorified case structure. However this gets a little
%   interesting because of the fact that in order to get the temperature at
%   the base of a level, it needs to find the values at the top of the
%   gradient layer beneath it. In order to do this it calls the "grad"
%   function. The thing is that the gradient function often has initial
%   values that depend on the isothermal layer beneath it. Therefore it
%   calls the "isotherm" value at the base of its layer. This mean that in
%   order to calculate the values for any given altitude, there are
%   multiple calls to both the isotherm and grad functions. 

g_0 = 9.807;    % m/s^2
R = 287;    % constant
temp_1 = 216.66;    % kelvin
h_1 = 0;    % km

% This next chunk of code may be more efficient as a switch.
if alt > 11 && alt <= 25
    temp_1 = 216.66;
    [~,pressure_1,density_1] = grad(11); %throw out the temp
    h_1 = 11;
elseif alt > 47 && alt <= 53
    temp_1 = 282.66;
    [~,pressure_1,density_1] = grad(47); %throw out the temp
    h_1 = 47;
elseif alt > 79 && alt <= 90
    temp_1 = 165.66;
    [~,pressure_1,density_1] = grad(79); %throw out the temp
    h_1 = 79;
end

temp = temp_1;  % This is what makes it an isothermal layer
alt_m = alt * 1000; % Equations are in terms of meters
h_1_m = h_1 * 1000; % Convert km to meters
pressure = pressure_1 * exp((-(g_0)/(R * temp_1)) * (alt_m - h_1_m));   % Calculate pressure
density = density_1 * exp((-(g_0)/(R * temp_1)) * (alt_m - h_1_m));     % Calculate density
end

function [temp,pressure,density] = grad ( alt )
%GRAD Calculating temperature, pressure, and density in a gradient layer
%   See the explanation of the isothermal layer.

g_0 = 9.807;    % m/s^2
R = 287;    % constant
a = -6.5;   % kelvin/km
temp_1 = 288.16;    % kelvin
pressure_1 = 1.01325 * 10^5;    % pascals
density_1 = 1.2250; % kg/m^3
h_1 = 0;    % km

% This could also be refactored as a switch
if alt > 25 && alt <= 47
    a = 3;
    [temp_1,pressure_1,density_1] = isotherm(25);
    h_1 = 25;
elseif alt > 53 && alt <= 79
    a = -4.5;
    [temp_1,pressure_1,density_1] = isotherm(53);
    h_1 = 53;
elseif alt > 90 && alt <= 105
    a = 4;
    [temp_1,pressure_1,density_1] = isotherm(90);
    h_1 = 90;
end

a_m = a * (10 ^ -3);    % The equations work with meters not km
alt_m = alt * 1000;     % Again meters, not kilometers.
h_1_m = h_1 * 1000;     % See above.
temp = temp_1 + (a_m * (alt_m - h_1_m));    % Calculate temperature
pressure = pressure_1 * (1 + ((a_m / temp_1) * (alt_m - h_1_m)))^(-(g_0)/(a_m * R));    % Calculate pressure
density = density_1 * (1 + ((a_m / temp_1) * (alt_m - h_1_m)))^(-(((g_0)/(a_m * R))+1));    % Calculate density
end