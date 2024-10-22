

clear;
clc;
service = 'https://unifieddatalibrary.com/udl/elset?epoch=%3Enow-1%20days&idOnOrbit=12078';
options = weboptions('Username','ryan.britt1','Password','','CertificateFilename', '', 'ContentType','json', 'ArrayFormat', 'json', 'Timeout', 100); 
data = webread(service,options);



date = datetime(data(1).epoch, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSSSSSZ', 'TimeZone', 'UTC');

startTime = date;
stopTime = date + days(2);
sampleTime = 60;
sc = satelliteScenario(startTime,stopTime,sampleTime);
lat = 40.037031;
lon = -75.345272;
gs = groundStation(sc,lat,lon,"MinElevationAngle",20);



tleFile = "eccentricOrbitSatellite.tle";
%sat1 = satellite(sc,tleFile,OrbitPropagator="sgp4");
%mean anon is not the same as true anon ask my mentor how to fix this

%
sat = satellite(sc,data(1).semiMajorAxis*1000,data(1).eccentricity,data(1).inclination,data(1).raan,data(1).perigee,data(1).meanAnomaly);

% semiMajorAxis = 10000000;
% eccentricity = 0.3;
% inclination = 40; 
% rightAscensionOfAscendingNode = 0; 
% argumentOfPeriapsis = 0; 
% trueAnomaly = 0; 
% ac = access(sat,gs);
ac = access(sat,gs);


sat.ShowLabel = true;
time = date + hours(1);
[azimuth,elevation,range] = aer(sat,gs,time);
 
display(range);
display(elevation);
display(azimuth);
% Properties of access analysis objects
ac(1)
play(sc)






