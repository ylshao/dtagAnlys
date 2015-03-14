function TrainSeg = getTrain(TagData)

timeHour = TagData.timeHour;
headDeg = TagData.headDeg;
% dataLength = TagData.dataLength;
THLD_RUB_HEAD_DEG = 30;
[timeHeadPeak, headPeak, indPeak] = getPeaks(timeHour, headDeg, THLD_RUB_HEAD_DEG);
% figure;
% plot(timeHour, headDeg)
% hold on
% plot(timeHeadPeak, headPeak, 'r.')


%% concat depth segments
concatSegMat = [TagData.DepthSeg.Asc.begEndInd...
            TagData.DepthSeg.Surf.begEndInd ...
            TagData.DepthSeg.Desc.begEndInd ...
            [TagData.DepthSeg.Bot.begEndInd; nan nan] ];
concatSegArray = reshape(concatSegMat', [], 1);    


%%
% the idea of training selection is, when dolphin rotate 1 circle (head
% degree changes from 0 to 360), it will cover some surfs, some asc, some
% desc and some bot. For training, usually it will cover a complete set of
% surf, asc, desc and bot. 

DEF_CENT_SEG = 0.1;
MIN_SEG_NUM = 4; % minimal segments shall contain 
MAX_SEG_NUM = 10; 
MIN_HEAD_DEG = 350; % over this value means rotate 1 circle
MAX_DIFF_HEAD_DEG = 20; % head degree should change smoothly during training
    
indPeakNum = numel(indPeak);
isTrain = nan(indPeakNum-1, 1);
trainSegNum = 0;
if mod(indPeakNum, 2) ~= 0 
    indPeakNum = indPeakNum - 1;
end
for iPeak = 1:(indPeakNum-1)
    % sort every two peaks as one segment
    thisPeakBeg = indPeak(iPeak);
    thisPeakEnd = indPeak(iPeak+1);
    headPeakDiff = abs(headDeg(thisPeakEnd) - headDeg(thisPeakBeg));
    
    % only use center of the segment to find interval numbers
    thisPeakCentBeg = thisPeakBeg+DEF_CENT_SEG*(thisPeakEnd-thisPeakBeg);
    thisPeakCentEnd = thisPeakBeg+(1-DEF_CENT_SEG)*(thisPeakEnd-thisPeakBeg);
    thisHeadDiffAbs = abs(diff(headDeg(thisPeakBeg:thisPeakEnd)));
    
    % find the interval numbers of head peaks
    peakSegBeg = find(concatSegArray <= thisPeakCentBeg, 1, 'last');
    peakSegEnd = find(concatSegArray <= thisPeakCentEnd, 1, 'last');
    peakSegDiff = peakSegEnd-peakSegBeg;
    
    % judge whether or not isTrain
    thisTrain = peakSegDiff >= MIN_SEG_NUM & peakSegDiff <= MAX_SEG_NUM & ...
            headPeakDiff > MIN_HEAD_DEG;
    if ~isempty(find(thisHeadDiffAbs > MAX_DIFF_HEAD_DEG, 1, 'first'))
        thisTrain = 0;
    end
    if thisTrain == 1
        isTrain(iPeak) = thisTrain;
    end
%     % select index in trainSel
%     thisSeg = thisPeakBeg:thisPeakEnd;
%     if isTrain(iPeak)
%         trainSel(thisSeg) = ones(thisPeakEnd - thisPeakBeg + 1, 1);
%         trainSegNum = trainSegNum + 1;
%     end
end
% trainSeg = find(~isnan(trainSel));
     
trainInd = find(~isnan(isTrain));
trainNum = numel(trainInd);
    indCell = cell(trainNum,1);
    timeCell = cell(trainNum, 1);
    begEndInd = nan(trainNum, 2);
for iTrain = 1:trainNum
    thisPeakBeg = indPeak(trainInd(iTrain));
    thisPeakEnd = indPeak(trainInd(iTrain)+1);
    begEndInd(iTrain, :) = [thisPeakBeg thisPeakEnd];
    indCell{iTrain} = (thisPeakBeg:thisPeakEnd)';
    timeCell{iTrain} = timeHour(thisPeakBeg:thisPeakEnd);
end
%%

    TrainSeg.begEndInd = begEndInd;
    TrainSeg.indCell = indCell;
    TrainSeg.timeCell = timeCell;
    TrainSeg.num = trainNum;
%%
fprintf('\nfind trainning segments %d\n', trainNum)
end