function plotSegFromCell(time, Data, Seg, color)
plot(time(cell2mat(Seg.indCell)),...
    Data(cell2mat(Seg.indCell)), color);
end