Seg = TagData.DepthSeg.Bot;

peakFreq = Seg.peakFreq;
mainAmp = Seg.mainAmp;
odbaMean = Seg.odbaMean;

statAccelAxMean = Seg.statAccelMean(:, 1);
totalAccelAyMean = Seg.totalAccelMean(:, 1);
metric = [peakFreq mainAmp];% odbaMean];% statAccelAxMean totalAccelAyMean];

CLUST_NUM = 11;
maxClustNum = CLUST_NUM;
for iMetric = 1:size(metric, 2)
    maxClustNum = min(maxClustNum, numel(find(~isnan(metric(:,iMetric)))));
end

[clustInd, centrd] = kmeans(metric, maxClustNum, 'Display','final', 'Replicates', 10);

flukeCentrd = find(centrd(:, 1) < FlukeThld.maxFreq & ...
        centrd(:, 1) > FlukeThld.minFreq)

    flukeSel = nan(Seg.num, 1);
for iCentrd = 1:numel(flukeCentrd)
    flukeSel(clustInd == flukeCentrd(iCentrd)) = 1;
end

indFlukeSeg = find(~isnan(flukeSel));

Fluke.begEndInd = Seg.begEndInd(indFlukeSeg, :);
Fluke.indCell = Seg.indCell(indFlukeSeg);
Fluke.timeCell = Seg.timeCell(indFlukeSeg);
Fluke.num = numel(indFlukeSeg);

% disp(centrd)
%% evaluate proper number of clusters

eva = evalclusters(metric,'kmeans','silhouette','KList',1:20) % CalinskiHarabasz DaviesBouldin silhouette
figure(743); clf
plot(eva)
%%
figure(652); clf
[silh,h] = silhouette(metric, clustInd);
% cluster3 = mean(silh3)
% cluster4 = mean(silh4)
%%
accelX = TagData.accelTag(:,1);
pitchDeg = TagData.pitchDeg;
timeHour = TagData.timeHour;
depthShiftFilt = TagData.depthShiftFilt;
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
plotSegFromCell(timeHour, accelX, Fluke, 'm.')
xlabel('time [hour]'); ylabel('accel X [m/s^2]')

ax(3) = subplot(313);
plot(TagData.timeHour, pitchDeg); hold on; 
plot(TagData.timeHour, zeros(numel(TagData.timeHour), 1), 'k--')
plotSegFromCell(timeHour, pitchDeg, Fluke, 'm.')
xlabel('time [hour]'); ylabel('pitch [deg]')

linkaxes(ax, 'x')