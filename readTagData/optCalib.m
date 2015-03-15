function TagData = optCalib(TagData, nTagData)

satisCalib = 0;
while ~satisCalib
    TagData = reoptCalib(TagData, nTagData);
    correctKey = 0;
    while ~correctKey
    keyPress = input('Satis for the calib? y, n  ', 's');
    switch keyPress(1)
        case 'y'
            satisCalib = 1;
            correctKey = 1;
        case 'n'
            correctKey = 1;
        otherwise
            fprintf('Please type y, n')
    end
    end
end

end

function TagData = reoptCalib(TagData, nTagData)
RawVolt = TagData(nTagData).RawVolt;
Calib = TagData(nTagData).CalibOrig;
prefix = TagData(nTagData).deployName;
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
TagData(nTagData).Calib = Calib;
end
