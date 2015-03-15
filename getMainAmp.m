function mainAmp = getMainAmp(data, enablePlot, BIN_NUM)
    if nargin < 3
        BIN_NUM = 10;  
        if nargin < 2
            enablePlot = 0;
        end
    end
    THLD_PEAK = 0.25;
    [~, thisPks] = getPeaks(ones(numel(data), 1),...
        data, THLD_PEAK);
%     if numel(find(~isnan(thisPks))) <= MIN_PEAK_NO; thisPks = nan; end
    thisAmp = abs(diff([0; thisPks]))/2;
    
    [elemNum, cenAmp] = hist(thisAmp, BIN_NUM);
    [maxCenAmp, maxCenAmpInd] = max(elemNum);
    mainAmp = cenAmp(maxCenAmpInd);

    if enablePlot
        figure; hold on
        hist(thisAmp, BIN_NUM);
        h = findobj(gca,'Type','patch');
        xlabel('Accel [g]');
        ylabel('Number');
        set(h,'FaceColor',0.7*ones(1,3),'EdgeColor','k')
        textStr = sprintf('Peak Mag. %6.4fg', mainAmp);
        text(mainAmp*1.1, maxCenAmp*0.9, textStr)
        plot(mainAmp, maxCenAmp, 'r.', 'MarkerSize', 20)
    end