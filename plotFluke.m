function plotFluke(TagData)

%%

accelX = TagData.accelTagOrig(:,1);
pitchDeg = TagData.pitchDeg;
figure; ax = [];
ax(1) = subplot(311); 
plot(TagData.timeHour, TagData.depthShiftFilt, 'b'); hold on
plot(TagData.timeHour(TagData.DepthSeg.surfSeg),...
    TagData.depthShiftFilt(TagData.DepthSeg.surfSeg), 'r.');
plot(TagData.timeHour(TagData.DepthSeg.descSeg),...
    TagData.depthShiftFilt(TagData.DepthSeg.descSeg), 'c.');
plot(TagData.timeHour(TagData.DepthSeg.ascSeg),...
    TagData.depthShiftFilt(TagData.DepthSeg.ascSeg), 'g.');
plot(TagData.timeHour(TagData.DepthSeg.botSeg),...
    TagData.depthShiftFilt(TagData.DepthSeg.botSeg), 'm.');
xlabel('time [hour]'); ylabel('depth')
legend('orig', 'surf', 'desc', 'asc')
hold on; 
ax(2) = subplot(312);
plot(TagData.timeHour, accelX)
hold on; 
plot(TagData.timeHour, zeros(numel(TagData.timeHour), 1), 'k--')
plot(TagData.timeHour(TagData.FlukeSeg.flukeDescSeg),...
    accelX(TagData.FlukeSeg.flukeDescSeg), 'r.');
plot(TagData.timeHour(TagData.FlukeSeg.flukeAscSeg),...
    accelX(TagData.FlukeSeg.flukeAscSeg), 'r.');
plot(TagData.timeHour(TagData.FlukeSeg.flukeBotSeg),...
    accelX(TagData.FlukeSeg.flukeBotSeg), 'r.');
xlabel('time [hour]'); ylabel('accel X [m/s^2]')

ax(3) = subplot(313);
plot(TagData.timeHour, pitchDeg)
hold on; 
plot(TagData.timeHour, zeros(numel(TagData.timeHour), 1), 'k--')
plot(TagData.timeHour(TagData.FlukeSeg.flukeDescSeg),...
    pitchDeg(TagData.FlukeSeg.flukeDescSeg), 'r.');
plot(TagData.timeHour(TagData.FlukeSeg.flukeAscSeg),...
    pitchDeg(TagData.FlukeSeg.flukeAscSeg), 'r.');
plot(TagData.timeHour(TagData.FlukeSeg.flukeBotSeg),...
    pitchDeg(TagData.FlukeSeg.flukeBotSeg), 'r.');
xlabel('time [hour]'); ylabel('pitch [deg]')

linkaxes(ax, 'x')

end