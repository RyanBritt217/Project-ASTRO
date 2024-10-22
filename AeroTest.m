startTime = datetime(2020,6,02,8,23,0);
stopTime = startTime + days(1);
sampleTime = 60;
sc = satelliteScenario(startTime,stopTime,sampleTime);

semiMajorAxis = [10000000;15000000];
eccentricity = [0.01;0.02];
inclination = [0;10];
rightAscensionOfAscendingNode = [0;15];
argumentOfPeriapsis = [0;30];
trueAnomaly = [0;20];

sat = satellite(sc,semiMajorAxis,eccentricity,inclination, ...
    rightAscensionOfAscendingNode,argumentOfPeriapsis,trueAnomaly);

show(sat)
groundTrack(sat,LeadTime=3600)