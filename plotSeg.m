function plotSeg(TagData)

%% Plot Divided Segments
figure; ax = [];
data = TagData.accelTagOrig(:,1);
ax(1) = subplot(211);
plot(TagData.timeHour, TagData.depthShiftFilt, 'b')
hold on; 
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
ax(2) = subplot(212);
plot(TagData.timeHour, data); hold on; 
plot(TagData.timeHour, zeros(numel(TagData.timeHour), 1), 'k--')
xlabel('time [hour]'); ylabel('accel X [m/s^2]')
plot(TagData.timeHour(TagData.DepthSeg.surfSeg),...
    data(TagData.DepthSeg.surfSeg), 'r.');
plot(TagData.timeHour(TagData.DepthSeg.descSeg),...
    data(TagData.DepthSeg.descSeg), 'c.');
plot(TagData.timeHour(TagData.DepthSeg.ascSeg),...
    data(TagData.DepthSeg.ascSeg), 'g.');
plot(TagData.timeHour(TagData.DepthSeg.botSeg),...
    data(TagData.DepthSeg.botSeg), 'm.');
linkaxes(ax, 'x')
end