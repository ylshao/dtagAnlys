clear all
clc
cd('C:\Users\shaoy\Documents\MATLAB\Archive\Dropbox\SpeedSensor\dtagAnlys')
addpath(genpath('C:\Users\shaoy\Documents\MATLAB\Archive\Dropbox\SpeedSensor\dtagAnlys'))

%%
% % recdir = 'C:\Users\shaoy\Documents\MATLAB\Archive\Dropbox\SpeedSensor\DTAG\Data';
% prefix = 'tt13_268a';
% % prefix = 'OrientTest105';
% % prefix = 'PandR106';
% filename = sprintf('%s_Data.mat', prefix);
% if exist(filename, 'file')
%     load(filename); % load .mat with only A, M, p if pitch roll head data unavailable
%     fname = sprintf('%sprh%d.mat',prefix,round(fs));
%     if exist(fname, 'file')
%         load(fname); % load .mat with extra pitch roll head if the prh file exists
%     end
% end
% %%
% tempFeb24
load('dataMar7')
%% Moving Average
rawData = TagData(1).depthShift;
avrgWindow = 10;
filtData = lowpassFilt(rawData, [], avrgWindow);
TagData(1).depthShiftFilt = filtData; 

% figure; 
% plot(TagData(1).timeHour, TagData(1).depthShift)
% hold on;
% delayIndNum = floor((avrgWindow-1)/2); % compensate for the delay in filtered data
% plot(TagData(1).timeHour(1:end-delayIndNum), filtData(1+delayIndNum:end), 'c.-')
% xlabel('time [hour]'); ylabel('depth')
% legend('orig', 'avrg')

%% divide data into segments based on diving phases
% change: better way to divide segment, e.g. too long for bottom swimming;

DepthSeg = getSeg(TagData(1));
TagData(1).DepthSeg = DepthSeg;
% plotSeg(TagData(1))

%% get statical data
% add: speed estimation
% change: segment index instead of logic; 
%         main Amp instead of mean Amp;
%         the cut peak is p2p or peak? comment clearly;
%         already selected flukes, average the fft
tic;
TagData(1).AccelStat = getOdba(TagData);
% plotStaAccel(TagData(1))
SegStat = getSegStat(DepthSeg, TagData(1));
TagData(1).SegStat = SegStat;
toc

%% Get fluke segments
% change: better way to estimate freq and amp;

% define the criteria for flukes
freqAvrg = 0.7882; freqStd = 2*0.1255;
ampAvrg = 0.25; ampStd = 0.05;
FlukeThld = struct;
FlukeThld.minFreq = freqAvrg-freqStd; FlukeThld.maxFreq = freqAvrg+freqStd;
FlukeThld.minAmp = ampAvrg-ampStd; FlukeThld.maxAmp = ampAvrg+ampStd;

% find flukes
FlukeSeg = getFluke(DepthSeg, SegStat, TagData, FlukeThld);
TagData(1).FlukeSeg = FlukeSeg;
plotFluke(TagData(1))
%% Get glide
GlideSeg = getGlide(TagData(1));
TagData(1).GlideSeg = GlideSeg;
% plotGlide(TagData(1))
%% Get encounter
% change: need to improve the detection of surface

EnctrSeg = getEnctr(TagData);
TagData(1).EnctrSeg = EnctrSeg;
plotEnctr(TagData(1))

%% Get training
TrainSeg = getTrain(TagData);
TagData(1).TrainSeg = TrainSeg;

plotTrain(TagData(1))
%% hist portion of each segments
% thisFigNum = randi([1000 2000]);


postProcess(TagData(1))

%% histogram all the fluke freq and peaks, relation with desc/asc/bot

%% histogram energy vs time

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Test Module
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%%
time = t_h;
data = A(:, 2);
figure; plot(time, data); hold on
%%
[~, ~, ind] = RecSel_v1(time, data);
fprintf('\nind = %d:%d;\n', ind(1), ind(end))
%%
figure(1011);clf; ax = [];
data = TagData.accelTagOrig(:,:);
ax(1) = subplot(211);
plot(TagData.timeHour, TagData.depthShiftFilt, 'b')
xlabel('time [hour]'); ylabel('depth')
legend('orig', 'surf', 'desc', 'asc')
ax(2) = subplot(212);
plot(TagData.timeHour, data); hold on; 
plot(TagData.timeHour, zeros(numel(TagData.timeHour), 3), 'k--')
xlabel('time [hour]'); ylabel('accel X [m/s^2]')
legend('x', 'y', 'z')
linkaxes(ax, 'x')
%%
figure(1012);clf; ax = [];
data = [TagData.pitchDeg TagData.headDeg];
ax(1) = subplot(211);
plot(TagData.timeHour, TagData.depthShiftFilt, 'b')
hold on
plot(TagData.timeHour(TagData.DepthSeg.surfSeg),...
    TagData.depthShiftFilt(TagData.DepthSeg.surfSeg), 'r.');
plot(TagData.timeHour(TagData.DepthSeg.descSeg),...
    TagData.depthShiftFilt(TagData.DepthSeg.descSeg), 'c.');
plot(TagData.timeHour(TagData.DepthSeg.ascSeg),...
    TagData.depthShiftFilt(TagData.DepthSeg.ascSeg), 'g.');
plot(TagData.timeHour(TagData.DepthSeg.botSeg),...
    TagData.depthShiftFilt(TagData.DepthSeg.botSeg), 'm.');
xlabel('time [hour]'); ylabel('depth')
legend('orig', 'surf', 'desc', 'asc')
ax(2) = subplot(212);
plot(TagData.timeHour, data); hold on; 
plot(TagData.timeHour, zeros(numel(TagData.timeHour), 3), 'k--')
xlabel('time [hour]'); ylabel('orient [deg]')
legend('pitch', 'head')
linkaxes(ax, 'x')
    
%% PIP test
length = TagData(1).dataLength;
pipSegSel = nan(length, 1);
pipSegSel(1) = 1; pipSegSel(end) = 1;
pipSeg = find(~isnan(pipSegSel));
% initialization
THLD_MIN_DIST = 0.2;
maxDist = THLD_MIN_DIST;
% while maxDist >= THLD_MIN_DIST
for i = 1:3
    for iPipSeg = 1:(numel(pipSeg)-1)
        thisSeg = pipSeg(iPipSeg):pipSeg(iPipSeg+1);
        if numel(thisSeg) > 2
            [thisPipPoint, maxDist] = getPipPoint(TagData(1), thisSeg);
            pipSegSel(thisPipPoint) = 1;
        end
    end
    pipSeg = find(~isnan(pipSegSel));
% end
end

figure;
plot(TagData.timeHour, TagData.depthShiftFilt)
hold on
plot(TagData.timeHour(pipSeg), TagData.depthShiftFilt(pipSeg), 'r.')
%% FFT
figure; hold on; DataPlot_Feb1([], TagData(1).depth.shiftFilt, 'fft', '', fs)