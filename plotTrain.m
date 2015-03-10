function plotTrain(TagData)

figure; ax = [];
data = [TagData.pitchDeg TagData.headDeg];
ax(1) = subplot(211);
plot(TagData.timeHour, TagData.depthShiftFilt, 'b')
hold on
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
plot(TagData.timeHour, zeros(numel(TagData.timeHour), 3), 'k--')
plot(TagData.timeHour(TagData.TrainSeg.trainSeg),...
    TagData.headDeg(TagData.TrainSeg.trainSeg), 'r.');
xlabel('time [hour]'); ylabel('orient [deg]')
legend('pitch', 'head')
linkaxes(ax, 'x')

end