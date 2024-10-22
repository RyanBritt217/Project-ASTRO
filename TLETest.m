
clear;
clc;
startTime = datetime(2024,10,16,15,36,0);
stopTime = datetime(2024,10,16,16,30,0);
sampleTime = 60;
sc = satelliteScenario(startTime,stopTime,sampleTime);
lat = 40.0385;
lon = -75.356;
gs = groundStation(sc,lat,lon,"MinElevationAngle",20);

tleFile = "leoSatelliteConstellation.tle";
%sat = satellite(sc,tleFile);

semiMajorAxis = 10000000;
eccentricity = 0.3;
inclination = 40; 
rightAscensionOfAscendingNode = 0; 
argumentOfPeriapsis = 0; 
trueAnomaly = 0; 
for i = 1:5
sat(i) = satellite(sc,semiMajorAxis,eccentricity,inclination + i*5,rightAscensionOfAscendingNode + i*10,argumentOfPeriapsis,trueAnomaly);
end 
ac = access(sat,gs);


for i = 1:5
sat(i).ShowLabel = true;
time = datetime(2024,10,16,16,30,0);
[azimuth(i),elevation(i),range(i)] = aer(sat(i),gs,time);
end 
display(range);
display(elevation);
display(azimuth);
% Properties of access analysis objects
ac(1)
play(sc)
