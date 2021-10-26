TMS_E = readmatrix('TMS_E_train.txt');
TMS_t = readmatrix('TMS_t_train.txt');
figure
plot(TMS_t,TMS_E,'o--')
grid minor