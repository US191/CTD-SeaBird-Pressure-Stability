%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script calculate offset for SeaBird pressure sensor from           %
% reference barometer                                                     %
% Autor: Pierre Rousselot - US191 IMAGO                                   %
% Date: 03/03/2018                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear

%% Variables
% Environment
P_baro   = 1008.6; % atmospheric pressure in mbar from barometer
T_air    = 28.1;   % air temperature in °C
P_CTD    = 0;      % pressure sensor in dbar

% Ship
H_baro   = 7.8;    % altitude barometer in meter
H_CTD    = 3.5;    % altitude CTD in meter

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constants
g        = 9.806;         % standard gravity
R        = 287.08;        % dry air constant
K        = 273.15;        % °C to Kelvin conversion
Ap       = 14.7;          % approximate atmospheric pressure at sea level in psi 
C        = 0.689476;      % factor conversion in dbar/psi

%% Calcul
P_atm    = (P_baro + ((P_baro * H_baro) / (29.2 * (T_air + K)))) * 0.01; % atmospheric pressure at sea level in dbar (Meteo-France)
P_CTDa   = P_CTD + (Ap * C);                                             % CTD absolute pressure from seabird relative pressure in dbar
P_CTDa0  = (P_CTDa + ((P_CTDa * H_CTD) / (29.2 * (T_air + K))));         % CTD absolute pressure at sea level in dbar (Meteo-France)

Offset   = P_atm - P_CTDa0;                                              % SeaBird pressure sensor offset
disp(['Offset = ' num2str(round(Offset*100)/100)]);
