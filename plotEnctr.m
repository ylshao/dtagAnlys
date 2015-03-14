function plotEnctr(TagData)

accelX = TagData.accelTag(:,1);
pitchDeg = TagData.pitchDeg;
timeHour = TagData.timeHour;
depthShiftFilt = TagData.depthShiftFilt;
EnctrSeg = TagData.EnctrSeg;
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

ax(2) = subplot(312);
plot(TagData.timeHour, accelX); hold on; 
plotSegFromCell(timeHour, accelX, EnctrSeg.FlatAy, 'c.')
plotSegFromCell(timeHour, accelX, EnctrSeg.FlatAz, 'g.')
xlabel('time [hour]'); ylabel('accel X [m/s^2]')

ax(3) = subplot(313);
plot(TagData.timeHour, pitchDeg); hold on; 
plot(TagData.timeHour, zeros(numel(TagData.timeHour), 1), 'k--')
plotSegFromCell(timeHour, pitchDeg, EnctrSeg.FlatAy, 'c.')
plotSegFromCell(timeHour, pitchDeg, EnctrSeg.FlatAz, 'g.')
xlabel('time [hour]'); ylabel('pitch [deg]')

linkaxes(ax, 'x')

end

function plotSegFromCell(time, Data, Seg, color)
plot(time(cell2mat(Seg.indCell)),...
    Data(cell2mat(Seg.indCell)), color);
end