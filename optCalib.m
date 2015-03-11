function TagData = optCalib(TagData, nTagData)

RawVolt = TagData(nTagData).RawVolt;
Calib = TagData(nTagData).Calib;
%% Optimize the Calibration
% Optimize the pressure calibration:
% X = trPress(X);
[depth,Calib,sampleFreq] = d3calpressure(RawVolt,Calib,'full');

% Optimize the acceleration calibration:
% min_depth = 10;
[accelTag,Calib,sampleFreq] = d3calacc(RawVolt,Calib,'full');
% Optimize the magnetometer calibration:
[magTag,Calib,sampleFreq] = d3calmag(RawVolt,Calib,'full');
% Save the calibration information so far to the deployment CAL file:
d3savecal(prefix,'CAL',Calib) % bug needs to be fixed
timeHour = (1:length(accelTag))'/sampleFreq/3600;
timeSec = timeHour*3600;
depth(isnan(accelTag)) = nan;

TagData(nTagData).accelTag = accelTag;
TagData(nTagData).depth = depth;
TagData(nTagData).magTag = magTag;
TagData(nTagData).timeHour = timeHour;
TagData(nTagData).timeSec = timeSec;
TagData(nTagData).sampleFreq = sampleFreq;
end
