function FlukeSeg = getFluke(DepthSeg, SegStat, TagData, FlukeThld)
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

if nargin < 4
    help getFluke;
end

%%
[flukeDesc, flukeDescSeg, flukeDescNum] = getFlukeSeg(SegStat.DescStat, DepthSeg.descBeg, ...
            DepthSeg.descEnd, FlukeThld);
[flukeAsc, flukeAscSeg, flukeAscNum] = getFlukeSeg(SegStat.AscStat, DepthSeg.ascBeg, ...
            DepthSeg.ascEnd, FlukeThld);
[flukeBot, flukeBotSeg, flukeBotNum] = getFlukeSeg(SegStat.BotStat, DepthSeg.botBeg, ...
            DepthSeg.botEnd, FlukeThld);
%%
FlukeSeg.flukeDesc = flukeDesc;
FlukeSeg.flukeAsc = flukeAsc;
FlukeSeg.flukeBot = flukeBot;

FlukeSeg.flukeDescSeg = flukeDescSeg;
FlukeSeg.flukeAscSeg = flukeAscSeg;
FlukeSeg.flukeBotSeg = flukeBotSeg;

FlukeSeg.flukeDescNum = flukeDescNum;
FlukeSeg.flukeAscNum = flukeAscNum;
FlukeSeg.flukeBotNum = flukeBotNum;

%%
flukeNumSum = FlukeSeg.flukeAscNum + FlukeSeg.flukeBotNum + FlukeSeg.flukeDescNum;
fprintf('\nNum of flukes find %d\nAsc Num %d, Bot Num %d, desc Num %d\n',...
    flukeNumSum, flukeAscNum, flukeBotNum, flukeDescNum)
end


function [fluke, flukeSeg, flukeNum] = getFlukeSeg(data, segBeg, segEnd, FlukeThld)

isFluke = data.peakFreq > FlukeThld.minFreq ...
            & data.peakFreq < FlukeThld.maxFreq ...
            & data.mainAmp > FlukeThld.minAmp ...
            & data.mainAmp < FlukeThld.maxAmp; % pitch 0.5 1 10 15
flukeInd = find(isFluke);
flukeNum = numel(flukeInd);
flukeSel = nan(max(segEnd)+100, 1);
fluke = nan(flukeNum, 2);
for iFluke = 1:flukeNum
    flukeSel(segBeg(flukeInd(iFluke)):segEnd(flukeInd(iFluke))) = ...
        ones(segEnd(flukeInd(iFluke)) - segBeg(flukeInd(iFluke)) + 1, 1);
    fluke(iFluke, :) = [segBeg(flukeInd(iFluke)) segEnd(flukeInd(iFluke))];
end
flukeSeg = find(~isnan(flukeSel));

end