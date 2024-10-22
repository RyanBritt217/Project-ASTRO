clear;
clc;
service = 'https://unifieddatalibrary.com/udl/elset?epoch=%3Enow-1%20days&idOnOrbit=56444';
options = weboptions('Username','ryan.britt1','Password','','CertificateFilename', '', 'ContentType','json', 'ArrayFormat', 'json', 'Timeout', 100); 
data = webread(service,options);

% Example TLE
tle1 = '1 25544U 98067A   20336.59748229  .00004269  00000-0  10113-4 0  9991';
tle2 = '2 25544  51.6441 329.1255 0003377  32.5037  44.6991 15.50197475241189';

% Call the function with example TLE
true_anomaly = tle_to_true_anomaly(data(2).line1, data(2).line2);

function true_anomaly = tle_to_true_anomaly(tle_line1, tle_line2)
    % Extract parameters from TLE
    i = str2double(tle_line1(9:16));      % Inclination (degrees)
    raan = str2double(tle_line1(18:25));  % RAAN (degrees)
    e = str2double(tle_line2(27:33)) / 1e7; % Eccentricity
    omega = str2double(tle_line2(34:42)); % Argument of perigee (degrees)
    M = str2double(tle_line2(44:51));     % Mean anomaly (degrees)

    % Convert M to radians
    M_rad = deg2rad(M);

    % Solve Kepler's Equation for Eccentric Anomaly E
    E = M_rad; % Initial guess
    for iter = 1:10 % Iterate to solve for E
        E = M_rad + e * sin(E);
    end

    % Calculate True Anomaly
    nu = 2 * atan2(sqrt(1 + e) * sin(E / 2), ...
                   sqrt(1 - e) * cos(E / 2));
    
    % Convert nu to degrees
    true_anomaly = rad2deg(nu);

    % Display the result
    fprintf('True Anomaly: %.4f degrees\n', true_anomaly);
end

