function plotTrain(TagData)

headDeg = TagData.headDeg;
pitchDeg = TagData.pitchDeg;
timeHour = TagData.timeHour;
depthShiftFilt = TagData.depthShiftFilt;
TrainSeg = TagData.TrainSeg;
DepthSeg = TagData.DepthSeg;

figure; ax = [];
ax(1) = subplot(311); 
plot(TagData.timeHour, TagData.depthShiftFilt, 'b'); hold on; 
plotSegFromCell(timeHour, depthShiftFilt, DepthSeg.Surf, 'r.')
plotSegFromCell(timeHour, depthShiftFilt, DepthSeg.Desc, 'c.')
plotSegFromCell(timeHour, depthShiftFilt, DepthSeg.Asc, 'g.')
plotSegFromCell(timeHour, depthShiftFilt, DepthSeg.Bot, 'm.')
xlabel('time [hour]'); ylabel('depth')
legend('orig', 'surf', 'desc', 'asc')



ax(2) = subplot(212);
plot(TagData.timeHour, [pitchDeg headDeg]); hold on; 
plot(TagData.timeHour, zeros(numel(TagData.timeHour), 3), 'k--')
plotSegFromCell(timeHour, headDeg, TrainSeg, 'r.')
xlabel('time [hour]'); ylabel('orient [deg]')
legend('pitch', 'head')
linkaxes(ax, 'x')

end

function plotSegFromCell(time, Data, Seg, color)
plot(time(cell2mat(Seg.indCell)),...
    Data(cell2mat(Seg.indCell)), color);
end