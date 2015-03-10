function GlideSeg = getGlide(TagData)


flukeAsc = TagData.FlukeSeg.flukeAsc;
flukeDesc = TagData.FlukeSeg.flukeDesc;
flukeBot = TagData.FlukeSeg.flukeBot;

flukeDescNum = TagData.FlukeSeg.flukeDescNum;
flukeAscNum = TagData.FlukeSeg.flukeAscNum;
flukeBotNum = TagData.FlukeSeg.flukeBotNum;
[glideBot, glideBotSeg, glideBotNum] = getGlideSeg(TagData, flukeBot, flukeBotNum);
[glideAsc, glideAscSeg, glideAscNum] = getGlideSeg(TagData, flukeAsc, flukeAscNum);
[glideDesc, glideDescSeg, glideDescNum] = getGlideSeg(TagData, flukeDesc, flukeDescNum);


%%

GlideSeg.glideBot = glideBot;
GlideSeg.glideAsc = glideAsc;
GlideSeg.glideDesc = glideDesc;

GlideSeg.glideBotSeg = glideBotSeg;
GlideSeg.glideAscSeg = glideAscSeg;
GlideSeg.glideDescSeg = glideDescSeg;

GlideSeg.glideBotNum = glideBotNum;
GlideSeg.glideAscNum = glideAscNum;
GlideSeg.glideDescNum = glideDescNum;

%%
fprintf('\n')
fprintf('bottom found glide %d, fluke seg %d\n', glideBotNum, flukeBotNum)
fprintf('desc found glide %d, fluke seg %d\n', glideDescNum, flukeDescNum)
fprintf('asc found glide %d, fluke seg %d\n', glideAscNum, flukeAscNum)
end

function [glide, glideSeg, glideSegNum] = getGlideSeg(TagData, fluke, flukeNum)
    timeHour = TagData.timeHour;
    accelX = TagData.accelTagOrig(:,1); 
    dataLength = TagData.dataLength;
    
    FREQ_AVRG = 0.7882;
    MIN_LEN = 2/FREQ_AVRG/3600;
    THLD_RUB_GLIDE = 0.2;
    glideSel = nan(dataLength, 1);
	glide = [{'flukeBeg'} {'flukeEnd'} {'glide'} 'dutyFac'; ...
        num2cell(fluke) cell(flukeNum,2)];
    glideSegNum = 0;
    for iFluke = 1:flukeNum

        thisFluke = fluke(iFluke, 1):fluke(iFluke, 2);

        [timeFlukePeakPre, flukePeakPre, indPeakPre] = ...
            getPeaks(timeHour(thisFluke), accelX(thisFluke), THLD_RUB_GLIDE);
        % add the last point, so that not omit last portion glides
        timeFlukePeak = [timeFlukePeakPre; timeHour(thisFluke(end))];
        flukePeak = [flukePeakPre; accelX(thisFluke(end))];
        indPeak = [indPeakPre; numel(thisFluke)];


        flukePeakTimeDiff = diff([timeFlukePeak(1); timeFlukePeak]);

        flatSeg = find(abs(flukePeakTimeDiff) >= MIN_LEN);
        isGlide = [flatSeg-1 flatSeg];
        glideNum = size(isGlide, 1);
        glideLen = 0;
        glide(iFluke+1, 3) = {[thisFluke(indPeak(isGlide(:,1)))'...
                        thisFluke(indPeak(isGlide(:,2)))']};
        if ~isempty(isGlide); glideSegNum = glideSegNum + 1; end
    
        for jGlide = 1:glideNum
            thisGlideBeg = thisFluke(indPeak(isGlide(jGlide,1)));
            thisGlideEnd = thisFluke(indPeak(isGlide(jGlide,2)));
            glideLen = thisGlideEnd - thisGlideBeg + 1 + glideLen;
            glideSel(thisGlideBeg:thisGlideEnd) = ...
                ones(thisGlideEnd-thisGlideBeg+1, 1);
        end
        glide(iFluke+1, 4) = {glideLen/(fluke(iFluke, 2) - fluke(iFluke, 1)+1)};
        if (glideLen == 0); glide(iFluke+1, 4) = {nan}; end
    end
    glideSeg = find(~isnan(glideSel));
end

