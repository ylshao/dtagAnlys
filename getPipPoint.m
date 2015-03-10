function [thisPipPoint, maxDist] = getPipPoint(TagData, thisSeg)
    maxDist = 0;
    thisPipPoint = nan;
    timeHour = TagData.timeHour(thisSeg);
    depth = TagData.depthShiftFilt(thisSeg);
    depthBeg = depth(1);
    depthEnd = depth(end);
    timeHourBeg = timeHour(1);
    timeHourEnd = timeHour(end);
    for iSeg = 1:numel(thisSeg)
        thisPortion = (timeHour(iSeg)-timeHourBeg)/(timeHourEnd-timeHourBeg);
        thisLinearDepth = depthBeg+(depthEnd-depthBeg)*thisPortion-depth(iSeg);
        thisDist = thisLinearDepth;
        if thisDist>maxDist
            maxDist = thisDist;
            thisPipPoint = thisSeg(iSeg);
        end
    end
    if isnan(thisPipPoint)
        aa = 1;
    end
end