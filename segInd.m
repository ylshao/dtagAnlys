
% due to the current def of enctr, the selected segment may not satisfy the
% "surface" condition

fluke = [42476:42697 79153:79312 79432:79515 91971:92088 345206:345461];
enctrAz = {139272:140389 385419:385725 388323:389960 397550:398114};
enctrAy = {138075:139298 392752:393729};


anlysEnctrAy = [{'avrg'}, {'std'}; cell(numel(enctrAy), 2);...
            {'oaAvrg'}, {'oaStd'}; cell(1, 2)];
anlysEnctrAz = [{'avrg'}, {'std'}; cell(numel(enctrAz), 2);...
            {'oaAvrg'}, {'oaStd'}; cell(1, 2)];

accel = TagData(1).accelTagOrig(:,2);
for iEnctr = 1:numel(enctrAy)
thisSeg = enctrAy{iEnctr};
anlysEnctrAy{iEnctr+1, 1} = mean(accel(thisSeg));
anlysEnctrAy{iEnctr+1, 2} = std(accel(thisSeg));
end
anlysEnctrAy{end, 1} = mean(abs(cellfun(@mean, ...
                anlysEnctrAy(2:(numel(enctrAy)+1), 1))));
anlysEnctrAy{end, 2} = mean(abs(cellfun(@mean, ...
                anlysEnctrAy(2:(numel(enctrAy)+1), 2))));
accel = TagData(1).accelTagOrig(:,3);
for iEnctr = 1:numel(enctrAz)
thisSeg = enctrAz{iEnctr};
anlysEnctrAz{iEnctr+1, 1} = mean(accel(thisSeg));
anlysEnctrAz{iEnctr+1, 2} = std(accel(thisSeg));
end
anlysEnctrAz{end, 1} = mean(abs(cellfun(@mean, ...
                anlysEnctrAz(2:(numel(enctrAz)+1), 1))));
anlysEnctrAz{end, 2} = mean(abs(cellfun(@mean, ...
                anlysEnctrAz(2:(numel(enctrAz)+1), 2))));