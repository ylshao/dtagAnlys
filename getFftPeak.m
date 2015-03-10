function peakFreq = getFftPeak(data, sampleFreq, startFreq)
    if nargin < 3
        startFreq = 0.05; % set the peak searching start frequency
    end
    dataDetr = data(~isnan(data));
    dataDetr = detrend(dataDetr,'constant');
    dataNum = size(dataDetr, 1);
    if dataNum > 5
        magFft = abs(fft(dataDetr, dataNum))/dataNum;
        freqSpec = ([0:dataNum/2-1]/dataNum*sampleFreq)';
        startInd = ceil((dataNum/2-1)/sampleFreq*startFreq*2);
        [~, peakInd] = max(magFft(startInd:length(freqSpec)));
        peakFreq = freqSpec(peakInd+startInd-1);
    else
        peakFreq = nan;
    end

