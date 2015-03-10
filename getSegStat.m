function SegStat = getSegStat(DepthSeg, TagData)
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

surfBeg = DepthSeg.surf(:,1);
surfEnd = DepthSeg.surf(:,2);
descBeg = DepthSeg.desc(:,1);
descEnd = DepthSeg.desc(:,2);
ascBeg = DepthSeg.asc(:,1);
ascEnd = DepthSeg.asc(:,2);
botBeg = DepthSeg.bot(:,1);
botEnd = DepthSeg.bot(:,2);


SegStat.SurfStat = calcStat(TagData, surfBeg, surfEnd);
SegStat.DescStat = calcStat(TagData, descBeg, descEnd);
SegStat.AscStat = calcStat(TagData, ascBeg, ascEnd); 
SegStat.BotStat = calcStat(TagData, botBeg, botEnd);
SegStat.DescStat.time = TagData.timeHour(DepthSeg.descSeg); 
SegStat.BotStat.time = TagData.timeHour(botBeg); 
%%
end
%
function Stat = calcStat(TagData, segBeg, segEnd)

surfNum = numel(segBeg);
sampleFreq = TagData.sampleFreq;
accelX = TagData.accelTagOrig(:,1); % use ax

% initialize
peakFreq = nan(surfNum, 1);
mainAmp = nan(surfNum, 1);
AccelDetail = TagData.AccelStat;
odbaMean = nan(surfNum, 1);
statAccelMean = nan(surfNum, 3);
statAccelStd = nan(surfNum, 3);
totalAccelMean = nan(surfNum, 3);
totalAccelStd = nan(surfNum, 3);

% set constants
THLD_ACCEL_PEAK = 0.25; % accel 0.25, pitch 15
MIN_PEAK_NO = 3; % need to find at least this number of peaks

for iSeg = 1:surfNum
    thisSeg = segBeg(iSeg):segEnd(iSeg);
    % get peakFreq
    thisAccel = accelX(thisSeg);
    thisFreq = getDomFreq(thisAccel, sampleFreq);
    peakFreq(iSeg) = thisFreq;
    
    % get meanAmp
    [~, thisPks] = getPeaks(ones(segEnd(iSeg) - segBeg(iSeg) + 1, 1),...
        thisAccel, THLD_ACCEL_PEAK);
    if numel(find(~isnan(thisPks))) <= MIN_PEAK_NO; thisPks = nan; end
    thisAmp = abs(diff([0; thisPks]))/2;
    BIN_NUM = 10;
    [elemNum,cenAmp] = hist(thisAmp, BIN_NUM);
    [~, maxCenAmpInd] = max(elemNum);
    mainAmp(iSeg) = cenAmp(maxCenAmpInd);
    
        
    % get AccelStat
    thisAccelStat = getAccelStat(TagData, thisSeg);
    AccelDetail(iSeg, 1) = thisAccelStat;
    odbaMean(iSeg) = mean(thisAccelStat.odba);
    statAccelMean(iSeg, :) = mean(thisAccelStat.staticAccel);
    statAccelStd(iSeg, :) = std(thisAccelStat.staticAccel);
    totalAccelMean(iSeg, :) = mean(thisAccelStat.totalAccel);
    totalAccelStd(iSeg, :) = std(thisAccelStat.totalAccel);
    
%     %% debug
%     if 0.472 > TagData.timeHour(segBeg(iSeg)) && 0.472 < TagData.timeHour(segEnd(iSeg))
%         timeHour = TagData.timeHour(thisSeg); 
%         totalAccel = TagData.accelTagOrig(thisSeg, :); 
%         staticAccel = TagData.AccelStat.staticAccel(thisSeg, :);
%         figure;
%         plot(timeHour, totalAccel(:,1)); hold on;
%         plot(timeHour, staticAccel(:,1), 'c')
%         xlabel('time [hour]'); ylabel('accel X [m/s^2]')
%         legend('total', 'static')
%     end
end

%%
Stat.peakFreq = peakFreq;
Stat.mainAmp = mainAmp;
Stat.AccelDetail = AccelDetail;
Stat.odbaMean = odbaMean;
Stat.statAccelMean = statAccelMean;
Stat.statAccelStd = statAccelStd;
Stat.totalAccelMean = totalAccelMean;
Stat.totalAccelStd = totalAccelStd;
end


function peakFreq = getDomFreq(data, sampleFreq, startFreq)
    if nargin < 3
        startFreq = 0.15; % set the peak searching start frequency
    end
    dataDetr = data(~isnan(data));
    dataDetr = detrend(dataDetr,'constant');
    dataNum = size(dataDetr, 1);
    if dataNum > 5
        magFft = abs(fft(dataDetr, dataNum))/dataNum;
        freqSpec = ((0:dataNum/2-1)/dataNum*sampleFreq)';
        startInd = ceil((dataNum/2-1)/sampleFreq*startFreq*2);
        [~, peakInd] = max(magFft(startInd:length(freqSpec)));
        peakFreq = freqSpec(peakInd+startInd-1);
    else
        peakFreq = nan;
    end
end

function thisAccelStat = getAccelStat(TagData, thisSeg)
    thisAccelStat = struct;
    thisAccelStat.staticAccel = TagData.AccelStat.staticAccel(thisSeg, :);
    thisAccelStat.dynAccel = TagData.AccelStat.dynAccel(thisSeg, :);
    thisAccelStat.odba = TagData.AccelStat.odba(thisSeg, :);
    thisAccelStat.totalAccel = TagData.AccelStat.totalAccel(thisSeg, :);
end