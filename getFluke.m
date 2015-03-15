function FlukeSeg = getFluke(TagData, FlukeThld, method)
% [time_pks, data_pks] = getPeaks(time, data, thld_rub, thld_zero, loc_min_flag)
%   The function searches through all the data points to find local peaks.
%   A rubbish bound is defined, start from previous peak, only points
%   exceed the rubbish bound will be considered as possible peaks.
%
%   thld_rub threshold to decide a the rubbish bound
%       0: find all trivial peaks
%   thld_zero threshold to decide a small amplitude peak
%       0: keep all small data
%   loc_min_flag determine which peak to find 
%       1: find local maxima & minima, 0: only find local maxima

if nargin < 2
    help getFluke;
end

DepthSeg = TagData.DepthSeg;
timeHour = TagData.timeHour;
%%
if strcmpi(method, 'fft')
    Desc = getFlukeFft(DepthSeg.Desc, FlukeThld, timeHour);
    Asc = getFlukeFft(DepthSeg.Asc, FlukeThld, timeHour);
    Bot = getFlukeFft(DepthSeg.Bot, FlukeThld, timeHour);
elseif strcmpi(method, 'kmeans')    
    Desc = getFlukeKmeans(DepthSeg.Desc, FlukeThld);
    Asc = getFlukeKmeans(DepthSeg.Asc, FlukeThld);
    Bot = getFlukeKmeans(DepthSeg.Bot, FlukeThld);
else
    fprintf('wrong method typed')
    return
end
%%
FlukeSeg.Desc = Desc;
FlukeSeg.Asc = Asc;
FlukeSeg.Bot = Bot;

%%
flukeNumSum = FlukeSeg.Asc.num + FlukeSeg.Bot.num + FlukeSeg.Desc.num;
fprintf('\nNum of flukes find %d\nAsc Num %d, Bot Num %d, desc Num %d\n',...
    flukeNumSum, FlukeSeg.Asc.num, FlukeSeg.Bot.num, FlukeSeg.Desc.num)
end


function Fluke = getFlukeFft(Seg, FlukeThld, timeHour)

isFluke = Seg.peakFreq > FlukeThld.minFreq ...
            & Seg.peakFreq < FlukeThld.maxFreq ...
            & Seg.mainAmp > FlukeThld.minAmp ...
            & Seg.mainAmp < FlukeThld.maxAmp; % pitch 0.5 1 10 15
        
    segBeg = Seg.begEndInd(:,1);
    segEnd = Seg.begEndInd(:,2);
    
    flukeInd = find(isFluke);
    flukeNum = numel(flukeInd);
    
    indCell = cell(flukeNum,1);
    timeCell = cell(flukeNum, 1);
    begEndInd = nan(flukeNum, 2);

    for iFluke = 1:flukeNum
        thisSegNum = flukeInd(iFluke);
        begEndInd(iFluke, :) = Seg.begEndInd(thisSegNum, :);
        indCell{iFluke} = (segBeg(thisSegNum):segEnd(thisSegNum))';
        timeCell{iFluke} = timeHour(segBeg(thisSegNum):segEnd(thisSegNum));
    end

    Fluke.begEndInd = begEndInd;
    Fluke.indCell = indCell;
    Fluke.timeCell = timeCell;
    Fluke.num = flukeNum;
end


function Fluke = getFlukeKmeans(Seg, FlukeThld)

peakFreq = Seg.peakFreq;
mainAmp = Seg.mainAmp;
odbaMean = Seg.odbaMean;

statAccelAxMean = Seg.statAccelMean(:, 1);
totalAccelAyMean = Seg.totalAccelMean(:, 1);
metric = [peakFreq mainAmp];% odbaMean statAccelAxMean totalAccelAyMean];

CLUST_NUM = 11;
maxClustNum = CLUST_NUM;
for iMetric = 1:size(metric, 2)
    maxClustNum = min(maxClustNum, numel(find(~isnan(metric(:,iMetric)))));
end

[clustInd, centrd] = kmeans(metric, maxClustNum, 'Display','final', 'Replicates', 10);%'Distance','cityblock',

flukeCentrd = find(centrd(:, 1) < FlukeThld.maxFreq & ...
        centrd(:, 1) > FlukeThld.minFreq);

    flukeSel = nan(Seg.num, 1);
for iCentrd = 1:numel(flukeCentrd)
    flukeSel(clustInd == flukeCentrd(iCentrd)) = 1;
end

indFlukeSeg = find(~isnan(flukeSel));

    Fluke.begEndInd = Seg.begEndInd(indFlukeSeg, :);
    Fluke.indCell = Seg.indCell(indFlukeSeg);
    Fluke.timeCell = Seg.timeCell(indFlukeSeg);
    Fluke.num = numel(indFlukeSeg);
    Fluke.Kmeans.clustInd = clustInd;
    Fluke.Kmeans.centrd = centrd;
    Fluke.Kmeans.flukeCentrd = flukeCentrd;
    Fluke.Kmeans.clustNum = maxClustNum;
end



