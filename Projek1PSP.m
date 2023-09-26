clear all;clc;
load('wsProjek1.mat');

%% Plot Data Pasar Surut Air Laut Januari-Juni
figure(1)
plot(data_ke,data);
title('Data Ketinggian Pasang Surut Air Laut Januari-Juni /jamnya');
xlabel('Data /jam') ;
ylabel('Ketinggian (m)');
difdata = diff(data)
%% Uji Distribusi
figure(2)
hold on;
a = histfit(data,100,'Normal')
set(a(1),'facecolor','g'); set(a(2),'color','g')
b =histfit(data,100,'wbl')
set(b(1),'facecolor','g'); set(b(2),'color','b')
c =histfit(data,100,'Lognormal')
set(c(1),'facecolor','w'); set(c(2),'color','r')
h = get(gca,'Children');
legend('','Normal Distribution','','Weibul','','LogNormal')
%% Uji QQPlot dan NormPlot
figure (3)
qq = qqplot(data);
figure (4)
Np = normplot(data);

%% Apabila belum Linear atau terdistribusi Normal, Lanjut ini
% %% Transformasi Box-Cox
% [transdat,lambda] = boxcox(data);
% m = min(transdat)-10  ;
% transdat = transdat-m;
% [transdat1,lambda1] = boxcox(transdat);
% [transdat2,lambda2] = boxcox(transdat1);
% %   karna box-cox membutuhkan daata yang >= 0 sehingga harus 
% %   dilakukan penggeseran data.
% [transdat3,lambda3] = boxcox(transdat2);
% [transdat4,lambda4] = boxcox(transdat3);
% [transdat5,lambda5] = boxcox(transdat4);
% data_baru = transdat3+(-0.153231573574128);
% data_baru_dif = diff(data_baru);
% figure(99);
% data_ke_baru=1:4368;
% plot(data_ke_baru,data_baru_dif);
% %% Cek Distribusi Normalnya lagi
% figure(5)
% hold on;
% a = histfit(data_baru,100,'Normal')
% set(a(1),'facecolor','g'); set(a(2),'color','g')
% b =histfit(data_baru,100,'wbl')
% set(b(1),'facecolor','g'); set(b(2),'color','b')
% c =histfit(data_baru,100,'Lognormal')
% set(c(1),'facecolor','w'); set(c(2),'color','r')
% h = get(gca,'Children');
% legend('','Normal Distribution','','Weibul','','LogNormal')
% %% Uji QQPlot dan NormPlot
% figure (6)
% qq = qqplot(data_baru);
% figure (7)
% Np = normplot(data_baru);
%% Cek Zero Mean-nya
Z = zscore(data,0);
rata_ratanya=mean(Z);

%Z1 = zscore(data_baru,0);
%mean(Z1);
%% Pemodelan
figure(11)
autocorr(diff(data))
figure(12)
parcorr(data)

%% Differensiasi Data
D1 = LagOp({1 -1},'Lags',[0,1]);
D12 = LagOp({1 -1},'Lags',[0,12]);
D = D1*D12
ddata = filter(D,data);
hlo1 = diff(ddata);