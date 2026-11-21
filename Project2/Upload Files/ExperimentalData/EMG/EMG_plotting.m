clear all
%%
Walking_EMG = readtable('Walking_EMG.csv','HeaderLines',0,'ReadVariableNames',true);
time=Walking_EMG.time;
rect_fem=Walking_EMG.Rect_Fem;
sol=Walking_EMG.Sol;


start_idx=551;
end_idx=1431;

figure(1)
plot(time(start_idx:end_idx),rect_fem(start_idx:end_idx))

figure(2)
plot(time(start_idx:end_idx),sol(start_idx:end_idx))
