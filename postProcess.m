function postProcess(TagData)


FlukeSeg = TagData.FlukeSeg;
GlideSeg = TagData.GlideSeg;
EnctrSeg = TagData.EnctrSeg;
TrainSeg = TagData.TrainSeg;
dataLength = TagData.dataLength; 

flukeAsc = FlukeSeg.Asc.begEndInd;
flukeBot = FlukeSeg.Bot.begEndInd;
flukeDesc = FlukeSeg.Desc.begEndInd;

thisFigNum = 1632;
%% Percent of each events over all deployment

glideAscPct = numel(GlideSeg.Asc.glideSeg)/dataLength;
glideBotPct = numel(GlideSeg.Bot.glideSeg)/dataLength;
glideDescPct = numel(GlideSeg.Desc.glideSeg)/dataLength;
glidePct = glideBotPct + glideAscPct + glideDescPct;

flukeAscPct = numel(cell2mat(FlukeSeg.Asc.indCell))/dataLength - glideAscPct;
flukeBotPct = numel(cell2mat(FlukeSeg.Bot.indCell))/dataLength - glideBotPct;
flukeDescPct = numel(cell2mat(FlukeSeg.Desc.indCell))/dataLength - glideDescPct;
flukePct = flukeDescPct + flukeAscPct + flukeBotPct;

enctrAyPct = numel(cell2mat(EnctrSeg.FlatAy.indCell))/dataLength;
enctrAzPct = numel(cell2mat(EnctrSeg.FlatAz.indCell))/dataLength;
enctrPct = enctrAyPct + enctrAzPct;

trainPct = numel(cell2mat(TrainSeg.indCell))/dataLength;

unknownPct = 1 - flukePct - enctrPct - trainPct - glidePct;

segPct = [flukePct, glidePct, enctrPct, trainPct];

figure(thisFigNum); clf; thisFigNum = thisFigNum+1;
bar(segPct)
title('Event Length/Data Length')
xlabel('Events'), ylabel('Percent [%]')
xTickLabel = [{'fluke'}; {'glide'}; {'encounter'}; {'training'}; {'unknown'}];
set(gca,'XTick', 1:numel(xTickLabel), 'XTickLabel', xTickLabel)

%% The percent of each segment in fluke and glide
flukeAscOva = flukeAscPct/flukePct;
flukeBotOva = flukeBotPct/flukePct;
flukeDescOva = flukeDescPct/flukePct;

glideAscOva = glideAscPct/glidePct;
glideBotOva = glideBotPct/glidePct;
glideDescOva = glideDescPct/glidePct;

segPctStack = [flukeAscOva flukeBotOva flukeDescOva;
            glideAscOva glideBotOva glideDescOva];
        
figure(thisFigNum); clf; thisFigNum = thisFigNum+1;
bar(segPctStack, 'hist')
title('Percent of Fluke & Glide during Swimming')
xlabel('Events'), ylabel('Percent [%]')
xTickLabel = [{'fluke'}; {'glide'}];
set(gca,'XTick', 1:numel(xTickLabel), 'XTickLabel', xTickLabel)
legend('Asc', 'Bot', 'Desc')


%% swim (fluke+glide) avrg duration
sampleFreq = TagData.sampleFreq;
swimAscDur = (flukeAsc(:,2)-...
    flukeAsc(:,1))/sampleFreq;
swimBotDur = (flukeBot(:,2)-...
    flukeBot(:,1))/sampleFreq;
swimDescDur = (flukeDesc(:,2)-...
    flukeDesc(:,1))/sampleFreq;

swimAscDurAvrg = mean(swimAscDur);
swimBotDurAvrg = mean(swimBotDur);
swimDescDurAvrg = mean(swimDescDur);

swimAscDurStd = std(swimAscDur);
swimBotDurStd = std(swimBotDur);
swimDescDurStd = std(swimDescDur);

swimDurAvrg = [swimAscDurAvrg swimBotDurAvrg swimDescDurAvrg];

swimDurStd = [swimAscDurStd swimBotDurStd swimDescDurStd];

% error bar
figure(thisFigNum); clf; thisFigNum = thisFigNum+1;
xTickLabel = [{'Asc'}; {'Bot'}; {'Desc'}];
errorbarMod(swimDurAvrg, swimDurStd, xTickLabel)
title('Average duration of swimming (fluke+glide)')
xlabel('Interval'), ylabel('Avrg Duration [sec]')
%% duty factor avrg and std
dutyFacAsc = cell2mat(GlideSeg.Asc.glide(2:end,4));
dutyFacBot = cell2mat(GlideSeg.Bot.glide(2:end,4));
dutyFacDesc = cell2mat(GlideSeg.Desc.glide(2:end,4));

dutyFacAscAvrg = nanmean(dutyFacAsc);
dutyFacBotAvrg = nanmean(dutyFacBot);
dutyFacDescAvrg = nanmean(dutyFacDesc);

dutyFacAscStd = nanstd(dutyFacAsc);
dutyFacBotStd = nanstd(dutyFacBot);
dutyFacDescStd = nanstd(dutyFacDesc);

dutyFacAvrg = [dutyFacAscAvrg dutyFacBotAvrg dutyFacDescAvrg];
dutyFacStd = [dutyFacAscStd dutyFacBotStd dutyFacDescStd];


% error bar
figure(thisFigNum); clf; thisFigNum = thisFigNum+1;
xTickLabel = [{'Asc'}; {'Bot'}; {'Desc'}];
errorbarMod(dutyFacAvrg, dutyFacStd, xTickLabel)
title('Average duty factor (glide/(glide+fluke))')
xlabel('Interval'), ylabel('Avrg Duty Factor')

% box plot
figure(thisFigNum); clf; thisFigNum = thisFigNum+1;
dataPlot = {dutyFacAsc; dutyFacBot; dutyFacDesc};
xTickLabel = [{'Asc'}; {'Bot'}; {'Desc'}];
boxplotMod(dataPlot, xTickLabel)
title('Average duty factor (glide/(glide+fluke))')
xlabel('Interval'), ylabel('Avrg Duty Factor')
% hist
figure(thisFigNum); clf; thisFigNum = thisFigNum+1;
h = histMod(dutyFacBot);
title('Bot duty factor hist')
xlabel('Duty Factor'), ylabel('Numbers')
set(h,'FaceColor',0.7*ones(1,3),'EdgeColor','k')

%% odba

flukeAscOdba = calcFlukeOdba(TagData, flukeAsc, FlukeSeg.Asc.num);
flukeBotOdba = calcFlukeOdba(TagData, flukeBot, FlukeSeg.Bot.num);
flukeDescOdba = calcFlukeOdba(TagData, flukeDesc, FlukeSeg.Desc.num);

flukeAscOdbaAvrg = nanmean(flukeAscOdba);
flukeBotOdbaAvrg = nanmean(flukeBotOdba);
flukeDescOdbaAvrg = nanmean(flukeDescOdba);
flukeAscOdbaStd = nanstd(flukeAscOdba);
flukeBotOdbaStd = nanstd(flukeBotOdba);
flukeDescOdbaStd = nanstd(flukeDescOdba);
flukeOdbaAvrg = [flukeAscOdbaAvrg flukeBotOdbaAvrg flukeDescOdbaAvrg];
flukeOdbaStd = [flukeAscOdbaStd flukeBotOdbaStd flukeDescOdbaStd];

% error bar
figure(thisFigNum); clf; thisFigNum = thisFigNum+1;
xTickLabel = [{'Asc'}; {'Bot'}; {'Desc'}];
errorbarMod(flukeOdbaAvrg, flukeOdbaStd, xTickLabel)
title('Average Odba')
xlabel('Interval'), ylabel('Avrg Odba [g]')

% box plot
figure(thisFigNum); clf; thisFigNum = thisFigNum+1;
dataPlot = {flukeAscOdba; flukeBotOdba; flukeDescOdba};
xTickLabel = [{'Asc'}; {'Bot'}; {'Desc'}];
boxplotMod(dataPlot, xTickLabel)
title('Average Odba')
xlabel('Interval'), ylabel('Avrg Odba [g]')

% hist
figure(thisFigNum); clf; thisFigNum = thisFigNum+1;
h = histMod(flukeBotOdba);
title('Bot Odba hist')
xlabel('Odba [g]'), ylabel('Numbers')
set(h,'FaceColor',0.7*ones(1,3),'EdgeColor','k')

figure(thisFigNum); clf; thisFigNum = thisFigNum+1;
h = histMod(flukeDescOdba);
title('Desc Odba hist')
xlabel('Odba [g]'), ylabel('Numbers')
set(h,'FaceColor',0.7*ones(1,3),'EdgeColor','k')
end

function flukeOdba = calcFlukeOdba(TagData, fluke, flukeNum)

    flukeOdba = nan(flukeNum, 1);
    for iFluke = 1:flukeNum
        flukeOdba(iFluke) = nanmean(TagData.AccelStat.odba(...
            fluke(iFluke,1):fluke(iFluke,2)));
    end

end

function boxplotMod(dataPlot, xTickLabel)    
    group = [];
    for iData = 1:numel(dataPlot)
        if numel(dataPlot{iData}) == 0
            dataPlot{iData} = nan;
        end
            group = [group; (iData-1)*ones(numel(dataPlot{iData}),1)];
    end
    boxplot(cell2mat(dataPlot), group)
    set(gca,'XTick', 1:numel(xTickLabel), 'XTickLabel', xTickLabel)
end

function errorbarMod(avrg, std, xTickLabel, LINE_WIDTH, ERRORBAR_WIDTH)
if nargin < 5
    ERRORBAR_WIDTH = 0.2;
    if nargin < 4
        LINE_WIDTH = 2;
    end
end
h = errorbar(avrg, std, 'LineWidth', LINE_WIDTH);
errorbar_tick(h, ERRORBAR_WIDTH, 'UNITS')
set(gca,'XTick', 1:numel(xTickLabel), 'XTickLabel', xTickLabel)
end

function h = histMod(data, NBINS)
if nargin < 2
    NBINS = 10;
end
hist(data, NBINS);
h = findobj(gca,'Type','patch');
end