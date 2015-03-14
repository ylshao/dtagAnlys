function [time_pks, data_pks, indPeak] = getPeaks(time, data, thld_rub, thld_zero, loc_min_flag)
% [time_pks, data_pks] = getPeaks(time, data, thld_rub, thld_zero, loc_min_flag)
%   The function searches through all the data points to find local peaks.
%   A rubbish bound is defined, start from previous peak, only points
%   exceed the rubbish bound will be considered as possible peaks.
%
%   thld_rub threshold to decide a the rubbish bound
%       0: find all trivial peaks
%   thld_zero threshold to decide a small amplitude peak
%       0: keep all small data
%   loc_min_flag determine which peak to find 
%       1: find local maxima & minima, 0: only find local maxima

% Add index output since last version
% Want to do two improvements, 
%   1) check the idea of rainflow, see if I can add some features
%   2) check the idea of the papers, see if I can modify something
% 
% Note: Realize this generates result equal to 
%     [~, locs_p] = findpeaks(data, 'MinPeakProminence', thld_rub);
%     [~, locs_n] = findpeaks(-data, 'MinPeakProminence', thld_rub);
%     locs = sort([locs_p; locs_n]);
%     data_all = data(locs); time_all = t_h(locs); 
% though my codes improved the speed. Checked the documentation, suspect
% why the two give same results
%
% Yunli Shao, Mar-8-2015

    if nargin < 5
        loc_min_flag = 1; 
        if nargin < 4
            thld_zero = 0; 
            if nargin < 3
                thld_rub = 0; 
            end
        end
    end
    if isempty(thld_zero); thld_zero = 0; end
    if isempty(thld_rub); thld_rub = 0; end
    
    if numel(data) < 5
        time_pks = nan;
        data_pks = nan;
        indPeak = nan;
    else
        cur_ind = 1;
        trend = 0;
        data_m = [data(1); nan(length(data), 1)];
        time_m = [time(1); nan(length(data), 1)];
        indPeak_m = [1; nan(length(data), 1)];
        time_pks = [];
        data_pks = [];
        indPeak = [];
        ind = 2;
        while cur_ind < length(data)
            data_cur = data(cur_ind); % 
            cur_ind = cur_ind + 1;
            done = 0;
            while ~done && cur_ind < length(data) % store next non-rubbish value
                if ~(abs(data(cur_ind)-data_cur)>thld_rub) % if next data is rubbish
                    if ((data(cur_ind)-data_cur)*trend > 0) 
                        ind = max(ind-1, 1);
                        data_m(ind) = data(cur_ind);
                        time_m(ind) = time(cur_ind);
                        indPeak_m(ind) = cur_ind;
                        ind = ind+1;
                        data_cur = data(cur_ind);
                    end
                    cur_ind = cur_ind + 1;
                else % if next data is not rubbish
                    if ((data(cur_ind)-data_cur)*trend > 0) 
                        ind = max(ind-1, 1);
                    end              
                    data_m(ind) = data(cur_ind);
                    time_m(ind) = time(cur_ind);
                    indPeak_m(ind) = cur_ind;
                    if data(cur_ind)>data_cur; trend = 1; 
                    elseif data(cur_ind)<data_cur; trend = -1; 
                    end
                    ind = ind+1;
                    done = 1;
                end
            end
        end
        if (ind)<3
%             fprintf('Error: could not find more than three peaks\n')
            return
        end

        if loc_min_flag
            time_pks = time_m(2:ind-1);
            data_pks = data_m(2:ind-1);
            indPeak = indPeak_m(2:ind-1);
        else % if do not want to get local minima
            if data_m(2)>data_m(1)
                time_pks = time_m(2:2:ind-1);
                data_pks = data_m(2:2:ind-1);
                indPeak = indPeak_m(2:2:ind-1);
            else
                time_pks = time_m(3:2:ind-1);
                data_pks = data_m(3:2:ind-1);
                indPeak = indPeak_m(3:2:ind-1);
            end
        end

        if thld_zero
            locs_f = find(abs(data_pks)>=thld_zero);
            data_pks = data_pks(locs_f); time_pks = time_pks(locs_f);
        end
    end