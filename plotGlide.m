function plotGlide(TagData)

plotFluke(TagData)
subplot(312)
% plot(timeFlukePeak, flukePeak, 'c.--'); 
plot(TagData.timeHour(TagData.GlideSeg.Bot.glideSeg), ...
    TagData.accelTag(TagData.GlideSeg.Bot.glideSeg, 1), 'r.')
plot(TagData.timeHour(TagData.GlideSeg.Asc.glideSeg), ...
    TagData.accelTag(TagData.GlideSeg.Asc.glideSeg, 1), 'r.')
plot(TagData.timeHour(TagData.GlideSeg.Desc.glideSeg), ...
    TagData.accelTag(TagData.GlideSeg.Desc.glideSeg, 1), 'r.')
end