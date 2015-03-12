function TagData = shiftDepth(TagData, nTagData, method)

accelTag = TagData(nTagData).accelTag;
depth = TagData(nTagData).depth;
timeHour = TagData(nTagData).timeHour;

depth(isnan(accelTag)) = nan;
depth = -depth;
% DataPlot_Feb1(t_h, p_trc, 'dep');
THLD_RUB = 0.05;
[timeHourPeak, depthPeak, indPeak] = getPeaks(timeHour, depth, THLD_RUB, 0, 0);


THLD_LARGE_DESC = -0.02;
THLD_LARGE_ASC = 0.02;

if strcmpi(method, 'interp')
    for i = 1:3
    largeDesc = diff([0; depthPeak]) < THLD_LARGE_DESC;
    largeAsc = diff([depthPeak; 0]) > THLD_LARGE_ASC;
    isPeak = ~(largeDesc | largeAsc);
    depthPeak = depthPeak(isPeak);
    indPeak = indPeak(isPeak);
    timeHourPeak = timeHourPeak(isPeak);
    end
    shiftDepthMeter = interp1(timeHourPeak, depthPeak, timeHour, 'pchip','extrap');
  
elseif strcmpi(method, 'max')
    shiftDepthMeter = nan(numel(depth), 1);
    dep = [depthPeak(1); depthPeak; depthPeak(end)];
    indPeak = [1; indPeak; length(timeHour)];
    ARVG_WIN = 10;
    shiftDepthMeter(1:indPeak(1+floor(ARVG_WIN/2))) = max(dep(1:1+floor(ARVG_WIN/2)));
    for i = 1+floor(ARVG_WIN/2):length(indPeak)-floor(ARVG_WIN/2)
        shiftDepthMeter(indPeak(i):indPeak(i+1)) = max(dep(i-floor(ARVG_WIN/2):i+floor(ARVG_WIN/2)));
    end
    shiftDepthMeter(indPeak(i+1):end) = max(dep(length(indPeak)-floor(ARVG_WIN/2)+1:end));
end

figure; plot(timeHour, depth); hold on; plot(timeHourPeak, depthPeak, 'r.')
plot(timeHour, shiftDepthMeter, 'c.')% figure; plot(t_h, p_trc); hold on; plot(t_h, depthShift, 'c.--')


depthShift = depth-shiftDepthMeter;
TagData(nTagData).depthShift = depthShift;

end