
accelTag = TagData(1).accelTag;
sampleFreq = TagData(1).sampleFreq;
timeHour = TagData(1).timeHour;
% select the data for comparing different ODBA
selSegCell = {42476:42697 79153:79312 79432:79515 91971:92088 345206:345461};

%% get the statitical template for flukes
nSelSegCell = numel(selSegCell);
peakFreqArray = nan(nSelSegCell, 1);
mainAmpArray = nan(nSelSegCell, 1);
BIN_NUM = 4;
ENABLE_PLOT = 0;
THLD_PEAK = 0.25;
for i = 1:nSelSegCell
    time = timeHour(selSegCell{i});
    data = accelTag(selSegCell{i},1);
    thisPeakFreq = getDomFreq(data, sampleFreq, 0, ENABLE_PLOT);
    thisMainAmp = getMainAmp(data, ENABLE_PLOT, THLD_PEAK, BIN_NUM);
    peakFreqArray(i) = thisPeakFreq;
    mainAmpArray(i) = thisMainAmp;
    if ENABLE_PLOT; figure; plot(time, data); end
end

avrgFreq = mean(peakFreqArray);
stdFreq = std(peakFreqArray);

avrgAmp = mean(mainAmpArray);
stdAmp = std(mainAmpArray);

flukeTemptCell = [{'peakFreq'}, {'mainAmp'};...
            {peakFreqArray}, {mainAmpArray};...
            {'avrgFreq'}, {'avrgAmp'};...
            {avrgFreq, avrgAmp};...
            {'stdFreq'}, {'stdAmp'};...
            {stdFreq, stdAmp}];
        
FREQ_AVRG = avrgFreq; FREQ_STD = 2*stdFreq; % FREQ_AVRG = 0.7882; FREQ_STD = 2*0.1255;
AMP_AVRG = avrgAmp; AMP_STD = 2*stdAmp; % AMP_AVRG = 0.25; AMP_STD = 0.05;
FlukeThld = struct;
FlukeThld.minFreq = FREQ_AVRG-FREQ_STD; FlukeThld.maxFreq = FREQ_AVRG+FREQ_STD;
FlukeThld.minAmp = AMP_AVRG-AMP_STD; FlukeThld.maxAmp = AMP_AVRG+AMP_STD;

save('Mar15', 'FlukeThld', '-append')