clear all
clc
%%
if strcmpi(getenv('COMPUTERNAME'), 'shao')
    recdir = 'M:\DQ_All_Day_Data';
else
    recdir = 'E:\DQ_All_Day_Data';
end

deployArray = {'tt13_266a', 'tt13_267a', 'tt13_268a', ...
            'tt13_269a', 'tt13_270a', 'tt13_270d', 'tt13_271c'};

nDeploy = numel(deployArray);
TagData(nDeploy, 1) = struct; 
%%
for iTagData = 1:nDeploy
%%
thisDeploy = deployArray{iTagData};

df = 10; % sample the data with 1/df rate
initPath(recdir)

TagData(iTagData).deployName = thisDeploy;
TagData(iTagData).desampFreq = df;
%%
TagData = readSwv(TagData, iTagData, recdir);
TagData(iTagData).dataLength = numel(TagData(iTagData).depthOrig);
%%
TagData = optCalib(TagData, iTagData);
%%
orientTab = [0 0 0 180 0];
TagData = estOrient(TagData, iTagData, orientTab);
%%
TagData = orderfields(TagData);
end
%%
TH = 0.2;
surface = 0.1;
METHOD = 2;
[PRH, T] = prhpredictor(p,A,fs,TH, METHOD, [], surface);