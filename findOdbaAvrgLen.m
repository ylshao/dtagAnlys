% The module is used to examine the selection of averaging window.
%
% Four segments of flukes (around 0.47, 0.88, 1.02, 3.82 hour) are selected
% and combined together as dummy signal. During flukes, the ocillation of
% acceleration is mostly due to the motion of animal, so we can use these
% segments to examine the effetiveness of the acceleration averaging
% method. Note that the assumption here is that during all the selected
% flukes, the ODBA shall be constant, which also implies that the forward
% swimming speed shall be constant. By increasing the averaging window
% length, the window length that ODBA converges will be a reference for
% selecting static acceleration averaging window.

% For the current dummy signal, the suggested averaging window shall be 8
% sec, which is 200 index
%   avrgWindow = 200;
% Note that the last fluke segment is different with others on offset,
% while whether or not include the segment, it gives similar results.
% 
% Yunli Shao, Mar-03-2015


accelTagOrig = TagData(1).accelTagOrig;
sampleFreq = TagData(1).sampleFreq;

% select the data for comparing different ODBA
seleSeg = [42476:42697 79153:79312 79432:79515 91971:92088 345206:345461];
repNum = 10;
time = TagData(1).timeHour(seleSeg);
totalAccel = accelTagOrig(seleSeg, :); % accel for averaging
time = repmat(time, repNum, 1);
totalAccel = repmat(totalAccel, repNum, 1);

% initialize avrg windows and lists for storing all the accels
avrgWindowList = (10:5:300)'; % 10->0.4sec; 200->8secs
avrgWindowNum = numel(avrgWindowList);
staAccelMeanList = nan(avrgWindowNum, 1);
odbaMeanList = nan(avrgWindowNum, 1);

% begin iteration to get ODBA for different averaging window
for iAvrgWindow = 1:avrgWindowNum
    thisAvrgWindow = avrgWindowList(iAvrgWindow); % 25Hz 35 points -> 1.4sec, 0.78Hz -> 1.28sec
    delayIndNum = floor((thisAvrgWindow-1)/2); % compensate for the delay in filtered data
    
    % need to dummy accel, so that the length shall be consistent
    avrgLastSegAccel = mean(totalAccel(end-delayIndNum+1:end, :));
    rawAccel = [totalAccel; repmat(avrgLastSegAccel, delayIndNum, 1)];
    % get static/dynamic/ODBA
    filtAccel = lowpassFilt(rawAccel, [], thisAvrgWindow);
    thisStaticAccel = filtAccel(1+delayIndNum:end, :);
    thisDynAccel = totalAccel - thisStaticAccel;
    thisOdba = abs(thisDynAccel(:,1)) + abs(thisDynAccel(:,2)) + abs(thisDynAccel(:,3));
    thisStat = abs(thisStaticAccel(:,1)) + abs(thisStaticAccel(:,2)) + abs(thisStaticAccel(:,3));
    % store to accel lists
    staAccelMeanList(iAvrgWindow) = mean(thisStat);
    odbaMeanList(iAvrgWindow) = mean(thisOdba);
end
figure; ax = [];
ax(1) = subplot(211);
plot(totalAccel(:,1), '.--'); hold on;
ax(2) = subplot(212);
plot(avrgWindowList/sampleFreq, odbaMeanList, '.--'); hold on
xlabel('averaging window [sec]'); ylabel('ODBA [g]')


