nTagData = 1;

TagData = struct;
TagData(nTagData).RawVolt = X;
TagData(nTagData).RawVoltOri = X_ORI;
TagData(nTagData).accelTagOrig = A;
TagData(nTagData).accelTagDyn = A_total;
TagData(nTagData).Calib = CAL;
TagData(nTagData).accelAnim = Aw;
TagData(nTagData).depthOrig = p;
TagData(nTagData).depthShift = p_shift;
TagData(nTagData).pitchDeg = rad2deg(pitch);
TagData(nTagData).rollDeg = rad2deg(roll);
TagData(nTagData).headDeg = rad2deg(head);
TagData(nTagData).timeHour = t_h;
TagData(nTagData).timeSec = t_s;
TagData(nTagData).sampleFreq = fs;
TagData(nTagData).name = 'tt13_268a';
TagData(nTagData).dataLength = numel(t_h);

