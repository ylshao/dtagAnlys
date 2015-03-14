function GlideSeg = getGlide(TagData)


FlukeSeg = TagData.FlukeSeg;

Bot = getGlideSeg(TagData, FlukeSeg.Bot);
Asc = getGlideSeg(TagData, FlukeSeg.Asc);
Desc = getGlideSeg(TagData, FlukeSeg.Desc);


%%

GlideSeg.Desc = Desc;
GlideSeg.Asc = Asc;
GlideSeg.Bot = Bot;
%%
fprintf('\n')
fprintf('bottom found glide %d, fluke seg %d\n', Bot.glideNum, FlukeSeg.Bot.num)
fprintf('desc found glide %d, fluke seg %d\n',  Desc.glideNum, FlukeSeg.Desc.num)
fprintf('asc found glide %d, fluke seg %d\n', Asc.glideNum, FlukeSeg.Asc.num)
end

function Glide = getGlideSeg(TagData, Seg)
    timeHour = TagData.timeHour;
    accelX = TagData.accelTagOrig(:,1); 
    dataLength = TagData.dataLength;
    fluke = Seg.begEndInd;
    flukeNum = Seg.num;
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
    
   	Glide.glide = glide;
    Glide.glideSeg = glideSeg;
    Glide.glideNum = glideSegNum;
    
end

