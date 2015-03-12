function TagData = estOrient(TagData, nTagData, orientTab)

%% If want to continue to save all the data with p,r,h estimation
% accelTag = TagData(nTagData).accelTag;
recdir = 'M:\DQ_All_Day_Data';
prefix = TagData(nTagData).deployName;
df = TagData(nTagData).desampFreq;
% % sampleFreq = TagData(nTagData).sampleFreq;
isDeg = find(orientTab(:, 3:5) > pi/2);
if isDeg
TagData(nTagData).orientTabDeg = orientTab;    
orientTab = deg2rad(orientTab);
    else
TagData(nTagData).orientTabRad = orientTab;
end
% [accelAnim, magAnim] = tag2whale(accelTag,magTag,OrientTab,sampleFreq);
% All_Plot(p, Aw, Mw, fs)
d3savecal(prefix,'OTAB',orientTab);
% d3makeprhfile(recdir,prefix,deploy_name,df)
TagData = d3makeprhfile_simple(prefix,df, TagData, nTagData);
% TagData = d3makeprhfile_mod(recdir,prefix,prefix,df, TagData, nTagData);

end