
peakFreq = TagData.SegStat.BotStat.peakFreq;
mainAmp = TagData.SegStat.BotStat.mainAmp;
odbaMean = TagData.SegStat.BotStat.odbaMean;

statAccelMean = TagData.SegStat.BotStat.statAccelMean(:, 1);
totalAccelMean = TagData.SegStat.BotStat.totalAccelMean(:, 1);
metric = [peakFreq mainAmp odbaMean statAccelMean totalAccelMean];
CLUST_NUM = 20;
[clustInd, centrd] = kmeans(metric, CLUST_NUM);
disp(centrd)
%%
CENT_NUM = 13;
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

xlabel('time [hour]'); ylabel('accel X [m/s^2]')

ax(3) = subplot(313);
plot(TagData.timeHour, pitchDeg)
hold on; 
plot(TagData.timeHour, zeros(numel(TagData.timeHour), 1), 'k--')

xlabel('time [hour]'); ylabel('pitch [deg]')

linkaxes(ax, 'x')

%
flukeCentrd = find(centrd(:, 1) < 1 & centrd(:, 1) > 0.6);
% centrdArray = centrd(flukeCentrd);
for iCentrd = 1:numel(centrdArray)
    thisSeg = cell2mat(TagData.DepthSeg.botSegCell...
        (clustInd == flukeCentrd(iCentrd)));

subplot(312);
plot(TagData.timeHour(thisSeg),...
    accelX(thisSeg), 'r.');
subplot(313);
plot(TagData.timeHour(thisSeg),...
    pitchDeg(thisSeg), 'r.');
end