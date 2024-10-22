mission.StartDate = datetime(2019, 1, 4, 12, 0, 0);
mission.Duration  = hours(6);

mission.Satellite.SemiMajorAxis  = 6786233.13; % meters
mission.Satellite.Eccentricity   = 0.0010537;
mission.Satellite.Inclination    = 51.7519;    % deg
mission.Satellite.RAAN           = 95.2562;    % deg
mission.Satellite.ArgOfPeriapsis = 93.4872;    % deg
mission.Satellite.TrueAnomaly    = 202.9234;   % deg

mission.GroundStation.Latitude  =42;  % deg
mission.GroundStation.Longitude =-71; % deg

mission.mdl = "OrbitPropagatorBlockExampleModel";
open_system(mission.mdl);
snapshotModel(mission.mdl)

mission.Satellite.blk = mission.mdl + "/Orbit Propagator";


set_param(mission.Satellite.blk, ...
    "startDate",      num2str(juliandate(mission.StartDate)), ...
    "stateFormatNum", "Orbital elements", ...
    "orbitType",      "Keplerian", ...
    "semiMajorAxis",  "mission.Satellite.SemiMajorAxis", ...
    "eccentricity",   "mission.Satellite.Eccentricity", ...
    "inclination",    "mission.Satellite.Inclination", ...
    "raan",           "mission.Satellite.RAAN", ...
    "argPeriapsis",   "mission.Satellite.ArgOfPeriapsis", ...
    "trueAnomaly",    "mission.Satellite.TrueAnomaly");

set_param(mission.Satellite.blk, ...
    "centralBody",  "Earth", ...
    "outportFrame", "Fixed-frame");

set_param(mission.Satellite.blk, ...
    "propagator",   "Numerical (high precision)", ...
    "gravityModel", "Spherical Harmonics", ...
    "earthSH",      "EGM2008", ... % Earth spherical harmonic potential model
    "shDegree",     "120", ... % Spherical harmonic model degree and order
    "useEOPs",      "on", ... % Use EOP's in ECI to ECEF transformations
    "eopFile",      "aeroiersdata.mat"); % EOP data file

set_param(mission.mdl, ...
    "SolverType", "Variable-step", ...
    "SolverName", "VariableStepAuto", ...
    "RelTol",     "1e-6", ...
    "AbsTol",     "1e-7", ...
    "StopTime",   string(seconds(mission.Duration)));

set_param(mission.mdl, ...
    "SaveOutput", "on", ...
    "OutputSaveName", "yout", ...
    "SaveFormat", "Dataset");


mission.SimOutput = sim(mission.mdl);

mission.Satellite.TimeseriesPosECEF = mission.SimOutput.yout{1}.Values;
mission.Satellite.TimeseriesVelECEF = mission.SimOutput.yout{2}.Values;

mission.Satellite.TimeseriesPosECEF.TimeInfo.StartDate = mission.StartDate;
mission.Satellite.TimeseriesVelECEF.TimeInfo.StartDate = mission.StartDate;

scenario = satelliteScenario;

sat = satellite(scenario, mission.Satellite.TimeseriesPosECEF, mission.Satellite.TimeseriesVelECEF, ...
    "CoordinateFrame", "ecef");

disp(scenario)

for idx = numel(sat):-1:1
    % Retrieve states in geographic coordinates
    [llaData, ~, llaTimeStamps] = states(sat(idx), "CoordinateFrame","geographic");
    % Organize state data for each satellite in a separate timetable
    mission.Satellite.LLATable{idx} = timetable(llaTimeStamps', llaData(1,:)', llaData(2,:)', llaData(3,:)',...
        'VariableNames', {'Lat_deg','Lon_deg', 'Alt_m'});
    mission.Satellite.LLATable{idx}
end

clear llaData llaTimeStamps;