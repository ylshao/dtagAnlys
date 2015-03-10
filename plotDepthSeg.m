function plotDepthSeg(TagData)
timeHour = TagData.timeHour;
depthShiftFilt = TagData.depthShiftFilt;
DepthSeg = TagData.DepthSeg;
plot(TagData.timeHour, TagData.depthShiftFilt, 'b')
hold on; 
plotSegFromCell(timeHour, depthShiftFilt, DepthSeg.Surf, 'r.')
plotSegFromCell(timeHour, depthShiftFilt, DepthSeg.Desc, 'c.')
plotSegFromCell(timeHour, depthShiftFilt, DepthSeg.Asc, 'g.')
plotSegFromCell(timeHour, depthShiftFilt, DepthSeg.Bot, 'm.')
xlabel('time [hour]'); ylabel('depth')
legend('orig', 'surf', 'desc', 'asc')
end

function plotSegFromCell(time, Data, Seg, color)
plot(time(cell2mat(Seg.segCell)),...
    Data(cell2mat(Seg.segCell)), color);
end