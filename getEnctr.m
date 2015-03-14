function EnctrSeg = getEnctr(TagData)

% enctrAy rotate 90 deg, gravity on axis y
% enctrAz gravity on axis z 
% dataLength = TagData.dataLength;

Surf = TagData.DepthSeg.Surf;
totalAccelMean = Surf.totalAccelMean;
totalAccelStd = Surf.totalAccelStd;
timeHour = TagData.timeHour;

THLD_ACCEL_Y_MEAN = 0.02;
THLD_ACCEL_Z_MEAN = 0.02;
THLD_ACCEL_Y_STD = 0.05;
THLD_ACCEL_Z_STD = 0.05;

isEnctrAy = abs(abs(totalAccelMean(:, 2)) - 1) < THLD_ACCEL_Y_MEAN &...
        totalAccelStd(:,2) < THLD_ACCEL_Y_STD;
isEnctrAz = abs(abs(totalAccelMean(:, 3)) - 1) < THLD_ACCEL_Z_MEAN &...
        totalAccelStd(:,3) < THLD_ACCEL_Z_STD;

FlatAy = getEnctrSeg(isEnctrAy, Surf, timeHour);
FlatAz = getEnctrSeg(isEnctrAz, Surf, timeHour);

EnctrSeg.FlatAy = FlatAy;
EnctrSeg.FlatAz = FlatAz;

enctrNumSum = EnctrSeg.FlatAy.num + EnctrSeg.FlatAz.num;
fprintf('\nNum of encounters find %d\nflatAy Num %d, flatAz Num %d\n',...
    enctrNumSum, EnctrSeg.FlatAy.num, EnctrSeg.FlatAz.num)
end

function Seg = getEnctrSeg(isEnctr, Surf, timeHour)
    enctr = find(isEnctr);
    enctrNum = numel(enctr);
    segBeg = Surf.begEndInd(:,1);
    segEnd = Surf.begEndInd(:,2);
    indCell = cell(enctrNum,1);
    timeCell = cell(enctrNum, 1);
    begEndInd = nan(enctrNum, 2);
    
    THLD_SEG_LENGTH = 25;%TagData(1).sampleFreq;

    for iEnc = 1:enctrNum
        thisSegNum = enctr(iEnc);
        thisSeg = segBeg(thisSegNum):segEnd(thisSegNum);
        if numel(thisSeg) >= THLD_SEG_LENGTH
            begEndInd(iEnc, :) = Surf.begEndInd(thisSegNum);
            indCell{iEnc} = (segBeg(thisSegNum):segEnd(thisSegNum))';
            timeCell{iEnc} = timeHour(segBeg(thisSegNum):segEnd(thisSegNum));
        end
    end
    Seg.begEndInd = begEndInd;
    Seg.indCell = indCell;
    Seg.timeCell = timeCell;
    Seg.num = enctrNum;
end
