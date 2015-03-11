%% shift pressure data
figure(456); clf; hold on
% DataPlot(fname, 'dep');%, 'p dot sec')

ind_nan = find(isnan(A_total));
p_trc = p;
p_trc(ind_nan) = nan;
p_trc = -(p_trc+abs(min(p_trc))) + abs(min(p_trc));
DataPlot_Feb1(t_h, p_trc, 'dep');
tr_rub = 0.05;
[t_dep_all, dep_all, t_dep_pks, dep_pks] = myFindPeaks(t_h, p_trc, tr_rub, 0);
plot(t_dep_pks, dep_pks, 'r.')
p_shift = p_trc;
[~, locs] = ismember(t_dep_pks, t_h);
dep = [dep_pks(1); dep_pks; dep_pks(end)];
locs = [1; locs; length(t_h)];
avrg_pt = 10;
p_shift(1:locs(1+floor(avrg_pt/2))) = max(dep(1:1+floor(avrg_pt/2)));
for i = 1+floor(avrg_pt/2):length(locs)-floor(avrg_pt/2)
    p_shift(locs(i):locs(i+1)) = max(dep(i-floor(avrg_pt/2):i+floor(avrg_pt/2)));
end
p_shift(locs(i+1):end) = max(dep(length(locs)-floor(avrg_pt/2)+1:end));
p_shift = p_trc-p_shift;

%%
save(filename, 'pitch_pks', 't_p_pks', '-append')
%%
figure(678); clf; 
DataPlot_Feb1(t_h, p_shift, 'dep', 'b');hold on;
DataPlot_Feb1(t_h, p_trc, 'dep', 'c.--');
