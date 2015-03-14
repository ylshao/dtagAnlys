function plotSeg(TagData)

%% Plot Divided Segments
figure; ax = [];
accelX = TagData.accelTag(:,1);
timeHour = TagData.timeHour;
depthShiftFilt = TagData.depthShiftFilt;
DepthSeg = TagData.DepthSeg;

ax(1) = subplot(211);
plot(TagData.timeHour, TagData.depthShiftFilt, 'b'); hold on; 
plotSegFromCell(timeHour, depthShiftFilt, DepthSeg.Surf, 'r.')
plotSegFromCell(timeHour, depthShiftFilt, DepthSeg.Desc, 'c.')
plotSegFromCell(timeHour, depthShiftFilt, DepthSeg.Asc, 'g.')
plotSegFromCell(timeHour, depthShiftFilt, DepthSeg.Bot, 'm.')
xlabel('time [hour]'); ylabel('depth')
legend('orig', 'surf', 'desc', 'asc')
ax(2) = subplot(212);
plot(timeHour, accelX); hold on; 
plot(timeHour, zeros(numel(timeHour), 1), 'k--')
xlabel('time [hour]'); ylabel('accel X [m/s^2]')
plotSegFromCell(timeHour, accelX, DepthSeg.Surf, 'r.')
plotSegFromCell(timeHour, accelX, DepthSeg.Desc, 'c.')
plotSegFromCell(timeHour, accelX, DepthSeg.Asc, 'g.')
plotSegFromCell(timeHour, accelX, DepthSeg.Bot, 'm.')
linkaxes(ax, 'x')
end

function plotSegFromCell(time, Data, Seg, color)
plot(time(cell2mat(Seg.indCell)),...
    Data(cell2mat(Seg.indCell)), color);
end