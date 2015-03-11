function TagData = readSwv(TagData, nTagData, recdir)

prefix = TagData(nTagData).deployName;
RawVolt = d3readswv(recdir,prefix,TagData.desampFreq);
% [ch_names,descr,ch_nums,type] = d3channames(X.cn);
% Register the deployment:
[Calib,~] = d3deployment(recdir, prefix, prefix) ;

depthOrig = d3calpressure(RawVolt, Calib);

accelTagOrig = d3calacc(RawVolt,Calib);

magTagOrig = d3calmag(RawVolt,Calib);

depthOrig(isnan(accelTagOrig)) = nan;

TagData(nTagData).RawVolt = RawVolt;
TagData(nTagData).CalibOrig = Calib;
TagData(nTagData).accelTagOrig = accelTagOrig;
TagData(nTagData).depthOrig = depthOrig;
TagData(nTagData).magTagOrig = magTagOrig;

end