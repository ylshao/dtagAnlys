function filtData = lowpassFilt(rawData, method, option)

if nargin < 2 || isempty(method)
    method = 'moveAvrg';
end
filtData = [];

if strcmpi(method, 'moveAvrg')
    if nargin < 3; option = 10; end
    avrgWindow = option; % Number of data points that are summed and averaged
    coeffVec = ones(1, avrgWindow)/avrgWindow; % The coeff in filter
    filtData = filter(coeffVec, 1, rawData);
end

end