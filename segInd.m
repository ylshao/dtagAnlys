
% due to the current def of enctr, the selected segment may not satisfy the
% "surface" condition

fluke = [42476:42697 79153:79312 79432:79515 91971:92088 345206:345461];
enctrAz = {139272:140389 385419:385725 388323:389960 397550:398114};
enctrAy = {138075:139298 392752:393729};


anlysEnctrAy = [{'avrg'}, {'std'}; cell(numel(enctrAy), 2);...
            {'oaAvrg'}, {'oaStd'}; cell(1, 2)];
anlysEnctrAz = [{'avrg'}, {'std'}; cell(numel(enctrAz), 2);...
            {'oaAvrg'}, {'oaStd'}; cell(1, 2)];

accel = TagData(1).accelTag(:,2);
for iEnctr = 1:numel(enctrAy)
thisSeg = enctrAy{iEnctr};
anlysEnctrAy{iEnctr+1, 1} = mean(accel(thisSeg));
anlysEnctrAy{iEnctr+1, 2} = std(accel(thisSeg));
end
anlysEnctrAy{end, 1} = mean(abs(cellfun(@mean, ...
                anlysEnctrAy(2:(numel(enctrAy)+1), 1))));
anlysEnctrAy{end, 2} = mean(abs(cellfun(@mean, ...
                anlysEnctrAy(2:(numel(enctrAy)+1), 2))));
accel = TagData(1).accelTag(:,3);
for iEnctr = 1:numel(enctrAz)
thisSeg = enctrAz{iEnctr};
anlysEnctrAz{iEnctr+1, 1} = mean(accel(thisSeg));
anlysEnctrAz{iEnctr+1, 2} = std(accel(thisSeg));
end
anlysEnctrAz{end, 1} = mean(abs(cellfun(@mean, ...
                anlysEnctrAz(2:(numel(enctrAz)+1), 1))));
anlysEnctrAz{end, 2} = mean(abs(cellfun(@mean, ...
                anlysEnctrAz(2:(numel(enctrAz)+1), 2))));
      
%%
peakFreq = getDomFreq(TagData(1).accelTag(selSeg,3), TagData.sampleFreq, 0)

%%
ind = find(TagData.DepthSeg.Surf.peakFreq < 0.05);
indSeg = cell2mat(TagData.DepthSeg.Surf.indCell(ind));
%%
selSeg = enctrAz{1};
% selSeg = indSeg;
figure(456); clf
accelX = TagData.accelTag(:,1);
pitchDeg = TagData.pitchDeg;
timeHour = TagData.timeHour;
depthShiftFilt = TagData.depthShiftFilt;
DepthSeg = TagData.DepthSeg;

ax = [];
ax(1) = subplot(211); 
plot(TagData.timeHour, TagData.depthShiftFilt, 'b'); hold on; 
plotSegFromCell(timeHour, depthShiftFilt, DepthSeg.Surf, 'r.')
plotSegFromCell(timeHour, depthShiftFilt, DepthSeg.Desc, 'c.')
plotSegFromCell(timeHour, depthShiftFilt, DepthSeg.Asc, 'g.')
plotSegFromCell(timeHour, depthShiftFilt, DepthSeg.Bot, 'm.')
xlabel('time [hour]'); ylabel('depth')
legend('orig', 'surf', 'desc', 'asc')

ax(2) = subplot(212);
plot(TagData.timeHour, TagData(1).accelTag(:,1:3)); hold on; 
plot(TagData.timeHour(selSeg), TagData(1).accelTag(selSeg,2:3), 'c.')
xlabel('time [hour]'); ylabel('accel [m/s^2]')
legend('x', 'y', 'z')
linkaxes(ax, 'x')