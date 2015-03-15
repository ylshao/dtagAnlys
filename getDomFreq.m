function peakFreq = getDomFreq(data, sampleFreq, startFreq, enablePlot)
    if nargin < 4
        enablePlot = 0;
        if nargin < 3 
            startFreq = 0.15; % set the peak searching start frequency
        end
    end
    
    if isempty(startFreq); startFreq = 0.15; end
    dataDetr = data(~isnan(data));
    dataDetr = detrend(dataDetr,'constant');
    dataNum = size(dataDetr, 1);
    if dataNum > 5
        magFft = abs(fft(dataDetr, dataNum))/dataNum;
        freqSpec = ((0:dataNum/2-1)/dataNum*sampleFreq)';
        if startFreq == 0
            startInd = 1;
        else
            startInd = ceil((dataNum/2-1)/sampleFreq*startFreq*2);
        end
        [peakAmp, peakInd] = max(magFft(startInd:length(freqSpec)));
        peakFreq = freqSpec(peakInd+startInd-1);
    else
        peakFreq = nan;
    end
    if enablePlot
    figure; hold on;
    plot(freqSpec, magFft(1:length(freqSpec)), 'k', 'Linewidth', 2)
    xlabel('Frequency (Hz)');
    ylabel('|FFT|');
    textStr = sprintf('%6.4fHz', peakFreq);
    text(peakFreq*2, peakAmp*0.9, textStr)
    plot(peakFreq, peakAmp, 'r.', 'MarkerSize', 20)
    end
end