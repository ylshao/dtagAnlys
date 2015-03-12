clear all
clc
%%
if strcmpi(getenv('COMPUTERNAME'), 'shao')
    recdir = 'M:\DQ_All_Day_Data';
else
    recdir = 'E:\DQ_All_Day_Data';
end
prefix = 'tt13_268a';

df = 10; % sample the data with 1/df rate
initPath(recdir)
nTagData = 1;
TagData(nTagData) = struct;
TagData(nTagData).deployName = prefix;
TagData(nTagData).desampFreq = df;
%%
TagData = readSwv(TagData, nTagData, recdir);
TagData(nTagData).dataLength = numel(TagData(nTagData).depthOrig);
%%
TagData = optCalib(TagData, nTagData);
%%
orientTab = [0 0 0 180 0];
TagData = estOrient(TagData, nTagData, orientTab);
%%
TagData = orderfields(TagData);
%%
TH = 0.2;
surface = 0.1;
METHOD = 2;
[PRH, T] = prhpredictor(p,A,fs,TH, METHOD, [], surface);