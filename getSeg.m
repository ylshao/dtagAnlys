function DepthSeg = getSeg(TagData)
% DepthSeg = divideSeg(TagData, enablePlot)
%   The function divides the tag data into four intervals: ascent dive, surface,
%   descent dive and bottom swimming. The intervals are divided based on
%   the depth data. 
%
%   variable name convention (xxx refers to a certain interval)
%       xxxSeg: all the index belongs to the interval
%       xxxBeg: the begin index of each segments of the interval
%       xxxEnd: the end index of each segments of the interval
%       xxxNum: the number of segments of the interval


% improved the segment division, so that at least there will be two pts for
% each interval
%
% Yunli Shao, Mar-8-2015

if nargin < 1
    help divideSeg
end
DepthSeg = struct; % initialize the output
%% Find Surface
% if underwater, depth is negative 
depthShiftFilt = TagData.depthShiftFilt;
thldSurfDepth = -0.05; % consider depth above the value as surface swim
surfSeg = find(depthShiftFilt > thldSurfDepth);

[surfBeg, surfEnd, surfNum] = getSurfSeg(surfSeg);
% modify the condition for surface
increSurfSegSel = nan(TagData.dataLength, 1); % for marking selected surf
sigma = 3; % is surf if within [mean-sigma*std, mean+sigma*std]
MIN_PTS_BTW_SURF = TagData.sampleFreq; % two surf shall be at least this length away
for iSeg = 1:(surfNum-1)
    % the statistical info of this surf
    thisSurfDepth = depthShiftFilt(surfBeg(iSeg):surfEnd(iSeg));
    thisSurfMean = mean(thisSurfDepth);
    thisSurfStd = std(thisSurfDepth); 
    
    % the statistical info of depth between this surf and next surf
    btwSurfDepth = depthShiftFilt(surfEnd(iSeg):surfBeg(iSeg+1));
    btwSurfMean = mean(btwSurfDepth);
    
    % criterion to determine whether data between surfs is also surf
    isSameSurf = (btwSurfMean < thisSurfMean + sigma*thisSurfStd && ...
            btwSurfMean > thisSurfMean - sigma*thisSurfStd) || ...
            numel(btwSurfDepth) < MIN_PTS_BTW_SURF+2;
    
    % if data between surfs is also surf, mark the data
    if isSameSurf
        increSurfSegSel(surfEnd(iSeg):surfBeg(iSeg+1)) = ...
            ones(surfBeg(iSeg+1)-surfEnd(iSeg)+1, 1);
    end
end
increSurfSeg = find(~isnan(increSurfSegSel));
surfSeg = unique([surfSeg; increSurfSeg]);
[surfBeg, surfEnd, surfNum] = getSurfSeg(surfSeg);

%% Find Descent, Ascent and Bottom Segments
pitchDeg = TagData.pitchDeg;
dataLength = TagData.dataLength;
timeHour = TagData.timeHour;

descBeg = surfEnd+1; % add one index so that the two are not the same
descEnd = nan(surfNum, 1);
ascEnd = surfBeg - 1; % minus one so that the two are different
ascBeg = nan(surfNum, 1);
% define the criteria for descend end and ascend begin
DESC_END_PITCH_DEG = 0; % if pitch exceeds 5 degrees, descent ends
ASC_BEG_PITCH_DEG = 0;
ascBeg(1) = find(pitchDeg(1:surfBeg(1)) < ASC_BEG_PITCH_DEG, 1, 'last'); % the last time that pitch still has negative value
descEnd(end) = find(pitchDeg(surfEnd(end):end) > DESC_END_PITCH_DEG, 1, 'first') + surfEnd(end) - 1; % the first time that pitch becomes positive
if isempty(ascBeg(1)); ascBeg(1) = ascEnd(1); end
if isempty(descEnd(end)); descEnd(end) = descBeg(end); end

% begin iteration to find begin & end index for all the segments
for iSeg = 1:(surfNum-1)
    RESRV_BOT_ASC = 4; % at least two bot pts and two asc pts
    thisDescPitchDeg = descBeg(iSeg)+1:(ascEnd(iSeg+1)-RESRV_BOT_ASC);
    locDescEnd = find(pitchDeg(thisDescPitchDeg) > DESC_END_PITCH_DEG, 1, 'first');
    if ~isempty(locDescEnd)
        descEnd(iSeg) = descBeg(iSeg) + locDescEnd; 
    else
        descEnd(iSeg) = (ascEnd(iSeg+1)-RESRV_BOT_ASC); % treatment, if fail to find descEnd
    end
    RESRV_BOT = 2; % at least two bot pts
    thisAscPitchDeg = (descEnd(iSeg)+RESRV_BOT+1):ascEnd(iSeg+1)-1;
    locAscBeg = find(pitchDeg(thisAscPitchDeg) < ASC_BEG_PITCH_DEG, 1, 'last');
    if ~isempty(locAscBeg)
        ascBeg(iSeg+1) = descEnd(iSeg)+RESRV_BOT+locAscBeg;
    else
        ascBeg(iSeg+1) = ascEnd(iSeg+1)-1; % treatment, if fail to find ascBeg
    end
end
botBeg = descEnd(1:(end-1))+1;
botEnd = ascBeg(2:end)-1;
Surf = collectSeg(surfBeg, surfEnd, timeHour);
Desc = collectSeg(descBeg, descEnd, timeHour);
Asc = collectSeg(ascBeg, ascEnd, timeHour);
Bot = collectSeg(botBeg, botEnd, timeHour);
%% Construct the output
DepthSeg.Surf = Surf;
DepthSeg.Asc = Asc;
DepthSeg.Desc = Desc;
DepthSeg.Bot = Bot;
fprintf('\nfind seg num %d\n', surfNum)
%% Sanity Check
sanityCheckNan(DepthSeg.Asc.begEndInd, 'asc')
sanityCheckNan(DepthSeg.Desc.begEndInd, 'desc')
sanityCheckNan(DepthSeg.Surf.begEndInd, 'surf')
sanityCheckNan(DepthSeg.Bot.begEndInd, 'bot')

sanityCheckRev(ascBeg, ascEnd, 'Asc Beg & Asc End')
sanityCheckRev(ascEnd, surfBeg, 'Asc End & Surf Beg')
sanityCheckRev(surfBeg, surfEnd, 'Surf Beg & Surf End')
sanityCheckRev(surfEnd, descBeg, 'Surf End & Desc Beg')
sanityCheckRev(descBeg, descEnd, 'Desc Beg & Desc End')
sanityCheckRev(descEnd(1:end-1), botBeg, 'Desc End & Bot Beg')
sanityCheckRev(botBeg, botEnd, 'Bot Beg & Bot End')
sanityCheckRev(botEnd, ascBeg(2:end), 'Bot End & Asc Beg')

end

function [surfBeg, surfEnd, surfNum] = getSurfSeg(surfSeg)
    % use two points to identify the location of each surface segment
    surfSegDiff = diff([0; surfSeg]); % diff of indSurf, if ~= 1, not consecutive
    surfBeg = surfSeg(surfSegDiff ~= 1); % begin index is those not equal to one
    surfEnd = surfSeg(find(surfSegDiff ~= 1)-1); % end index is before begin index in indSurf
    surfBeg = surfBeg(1:end-1); % for each segment, the order is asc->surf->desc->bot->asc
    surfEnd = surfEnd(2:end);
    surfNum = numel(surfBeg); % surfNum = descNum = ascNum = botNum+1
end

function sanityCheckNan(begEndInd, txt)
    segBegNanNum = numel(find(isnan(begEndInd(:,1))));
    segEndNanNum = numel(find(isnan(begEndInd(:,2))));
    if segBegNanNum ~= 0 || segEndNanNum ~= 0
    fprintf('%sBeg nan %d, %sEnd nan %d\n', txt, segBegNanNum, txt, segEndNanNum);
    end
end

function sanityCheckRev(segBeg, segEnd, txt)
    segBtwLen = segEnd - segBeg;
    revSeg = find(segBtwLen < 0);
    revSegNum = numel(revSeg);
    if revSegNum ~= 0
    fprintf('Reversed %s %d\n', txt, revSegNum);
    end
end

function Seg = collectSeg(segBeg, segEnd, timeHour)
indCell = cell(numel(segBeg),1);
timeCell = cell(numel(segBeg), 1);
for iSeg = 1:numel(segBeg)
    if ~isnan(segBeg(iSeg)) && ~isnan(segEnd(iSeg))
        indCell{iSeg} = (segBeg(iSeg):segEnd(iSeg))';
        timeCell{iSeg} = timeHour(segBeg(iSeg):segEnd(iSeg));
    end    
end

Seg.begEndInd = [segBeg segEnd];
Seg.indCell = indCell;
Seg.timeCell = timeCell;
Seg.num = numel(segBeg);
end