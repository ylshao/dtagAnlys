function plotGlide(TagData)

plotFluke(TagData)
subplot(312)
% plot(timeFlukePeak, flukePeak, 'c.--'); 
plot(TagData.timeHour(TagData.GlideSeg.glideBotSeg), ...
    TagData.accelTagOrig(TagData.GlideSeg.glideBotSeg, 1), 'm.')
plot(TagData.timeHour(TagData.GlideSeg.glideAscSeg), ...
    TagData.accelTagOrig(TagData.GlideSeg.glideAscSeg, 1), 'g.')
plot(TagData.timeHour(TagData.GlideSeg.glideDescSeg), ...
    TagData.accelTagOrig(TagData.GlideSeg.glideDescSeg, 1), 'c.')
end