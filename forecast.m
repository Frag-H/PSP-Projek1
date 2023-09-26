EstMdl1 = estimate(SARIMA_hlo1,data);
[YF1,YMSE1] = forecast(EstMdl1,120,data);
figure
%h1 = plot(1:746,data(3600:4345),'Color',[.7,.7,.7]);
h1 = plot(1:431,tested_data,'Color',[.7,.7,.7]);
hold on
h2 = plot(73:433,YF1,'b','LineWidth',2);
% h3 = plot(101:130,YF + 1.96*sqrt(YMSE),'r:',...
% 		'LineWidth',2);
% plot(101:130,YF - 1.96*sqrt(YMSE),'r:','LineWidth',2);
legend([h1 h2],'Observed','Forecast','Location','NorthWest');
title(['Forecast'])
hold off