function TrainSeg = getTrain(TagData)

timeHour = TagData.timeHour;
headDeg = TagData.headDeg;
dataLength = TagData.dataLength;
THLD_RUB_HEAD_DEG = 30;
[timeHeadPeak, headPeak, indPeak] = getPeaks(timeHour, headDeg, THLD_RUB_HEAD_DEG);
% figure;
% plot(timeHour, headDeg)
% hold on
% plot(timeHeadPeak, headPeak, 'r.')


%% concat depth segments
concatSegMat = [TagData.DepthSeg.asc TagData.DepthSeg.surf ...
        TagData.DepthSeg.desc [TagData.DepthSeg.bot; nan nan] ];
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

trainSel = nan(dataLength, 1);
indPeakNum = numel(indPeak);
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
    isTrain = peakSegDiff >= MIN_SEG_NUM & peakSegDiff <= MAX_SEG_NUM & ...
            headPeakDiff > MIN_HEAD_DEG;
    if ~isempty(find(thisHeadDiffAbs > MAX_DIFF_HEAD_DEG, 1, 'first'))
        isTrain = 0;
    end
    
    % select index in trainSel
    thisSeg = thisPeakBeg:thisPeakEnd;
    if isTrain
        trainSel(thisSeg) = ones(thisPeakEnd - thisPeakBeg + 1, 1);
        trainSegNum = trainSegNum + 1;
    end
end
trainSeg = find(~isnan(trainSel));

%%
TrainSeg.trainSeg = trainSeg;
TrainSeg.trainSel = trainSel;
TrainSeg.trainSegNum = trainSegNum;

%%
fprintf('\nfind trainning segments %d\n', trainSegNum)
end