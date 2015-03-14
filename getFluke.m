function FlukeSeg = getFluke(TagData, FlukeThld)
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
Desc = getFlukeSeg(DepthSeg.Desc, FlukeThld, timeHour);
Asc = getFlukeSeg(DepthSeg.Asc, FlukeThld, timeHour);
Bot = getFlukeSeg(DepthSeg.Bot, FlukeThld, timeHour);
%%
FlukeSeg.Desc = Desc;
FlukeSeg.Asc = Asc;
FlukeSeg.Bot = Bot;

%%
flukeNumSum = FlukeSeg.Asc.num + FlukeSeg.Bot.num + FlukeSeg.Desc.num;
fprintf('\nNum of flukes find %d\nAsc Num %d, Bot Num %d, desc Num %d\n',...
    flukeNumSum, FlukeSeg.Asc.num, FlukeSeg.Bot.num, FlukeSeg.Desc.num)
end


function Fluke = getFlukeSeg(Seg, FlukeThld, timeHour)

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