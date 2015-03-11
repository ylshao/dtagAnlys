clear all
clc
%%
recdir = 'E:\DQ_All_Day_Data';
prefix = 'tt13_268a';

settagpath('cal',[recdir, '\cal']);
%settagpath('raw','c:/tag/data/raw');
settagpath('prh',[recdir, '\prh']);
settagpath('audit',[recdir, '\audit']) ;
df = 10; % sample the data with 1/df rate


nTagData = 1;
TagData(nTagData) = struct;
TagData(nTagData).deployName = prefix;
TagData(nTagData).desampFreq = df;
%%
TagData = readSwv(TagData, nTagData, recdir);
%%
TagData = optCalib(TagData, nTagData);
%%
TH = 0.2;
surface = 0.1;
METHOD = 2;
[PRH, T] = prhpredictor(p,A,fs,TH, METHOD, [], surface);

%% If want to continue to save all the data with p,r,h estimation
OTAB = [0 0 0 180 0];
OTAB = deg2rad(OTAB);
[Aw,Mw] = tag2whale(A,M,OTAB,fs);
% All_Plot(p, Aw, Mw, fs)
d3savecal(prefix,'OTAB',OTAB);
% d3makeprhfile(recdir,prefix,deploy_name,df)
d3makeprhfile_simple(recdir,prefix,prefix,df, filename);