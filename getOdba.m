function AccelStat = getOdba(TagData)
    

    %%
    if nargin < 1
        help getOdba;
    end
    %%
    AccelStat = [];
    %%
    accelTagOrig = TagData.accelTag;
    sampleFreq = TagData.sampleFreq;
    timeHour = TagData.timeHour;

    totalAccel = accelTagOrig; % accel for averaging

    AVRG_WINDOW = 8*sampleFreq; % 25Hz 35 points -> 1.4sec, 0.78Hz -> 1.28sec
    delayIndNum = floor((AVRG_WINDOW-1)/2); % compensate for the delay in filtered data

    % need to dummy accel, so that the length shall be consistent
    avrgLastSegAccel = mean(totalAccel(end-delayIndNum+1:end, :));
    rawAccel = [totalAccel; repmat(avrgLastSegAccel, delayIndNum, 1)];
    % get static/dynamic/ODBA
    filtAccel = lowpassFilt(rawAccel, [], AVRG_WINDOW);
    staticAccel = filtAccel(1+delayIndNum:end, :);
    dynAccel = totalAccel - staticAccel;
    odba = abs(dynAccel(:,1)) + abs(dynAccel(:,2)) + abs(dynAccel(:,3));

    %%
    AccelStat.staticAccel = staticAccel;
    AccelStat.dynAccel = dynAccel;
    AccelStat.odba = odba;
    AccelStat.totalAccel = totalAccel;
end
