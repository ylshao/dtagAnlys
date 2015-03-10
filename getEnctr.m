function EnctrSeg = getEnctr(TagData)

% enctrAy rotate 90 deg, gravity on axis y
% enctrAz gravity on axis z 
dataLength = TagData.dataLength;

SurfStat = TagData.SegStat.SurfStat;
totalAccelMean = SurfStat.totalAccelMean;
totalAccelStd = SurfStat.totalAccelStd;

THLD_ACCEL_Y_MEAN = 0.02;
THLD_ACCEL_Z_MEAN = 0.02;
THLD_ACCEL_Y_STD = 0.05;
THLD_ACCEL_Z_STD = 0.05;

isEnctrAy = abs(abs(totalAccelMean(:, 2)) - 1) < THLD_ACCEL_Y_MEAN &...
        totalAccelStd(:,2) < THLD_ACCEL_Y_STD;
isEnctrAz = abs(abs(totalAccelMean(:, 3)) - 1) < THLD_ACCEL_Z_MEAN &...
        totalAccelStd(:,3) < THLD_ACCEL_Z_STD;
enctrAy = find(isEnctrAy);
enctrAz = find(isEnctrAz);

enctrAySel = nan(dataLength, 1);
enctrAzSel = nan(dataLength, 1);

THLD_SEG_LENGTH = 25;%TagData(1).sampleFreq;
surfBeg = TagData.DepthSeg.surfBeg;
surfEnd = TagData.DepthSeg.surfEnd;
for iEncAy = 1:numel(enctrAy)
    thisSeg = surfBeg(enctrAy(iEncAy)):surfEnd(enctrAy(iEncAy));
    if numel(thisSeg) >= THLD_SEG_LENGTH
    enctrAySel(thisSeg) = ...
        ones(surfEnd(enctrAy(iEncAy)) - surfBeg(enctrAy(iEncAy)) + 1, 1);
    end
end
enctrAySeg = find(~isnan(enctrAySel));

for iEncAz = 1:numel(enctrAz)
    thisSeg = surfBeg(enctrAz(iEncAz)):surfEnd(enctrAz(iEncAz));
    if numel(thisSeg) >= THLD_SEG_LENGTH
    enctrAzSel(thisSeg) = ...
        ones(surfEnd(enctrAz(iEncAz)) - surfBeg(enctrAz(iEncAz)) + 1, 1);
    end
end
enctrAzSeg = find(~isnan(enctrAzSel));

EnctrSeg.enctrAySeg = enctrAySeg;
EnctrSeg.enctrAzSeg = enctrAzSeg;
EnctrSeg.enctrAySel = enctrAySel;
EnctrSeg.enctrAzSel = enctrAzSel;

end