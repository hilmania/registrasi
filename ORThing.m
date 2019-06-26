clc
clear
close all
% base value
projVal=200;
op=20:0.1:projVal;

opRat=100*(op/projVal);
absProf=projVal-op;
profRat1=100*absProf./op;
profRat2=100-opRat;

% plot(op,opRat,'r-', op,absProf,'g-', op,profRat1,'b-')
% grid on
% legend('OR', 'AbsProfit','Profit Rat')

plot(op,opRat,'r-', op,absProf,'g-', op,profRat1,'b-', op, profRat2,'k-','linewidth',3)
grid on
legend('Operational Rasio (BO/NilaiProject)', 'Nilai Nominal Profit (Nilai Project-BO)','Profit Rasio Konvensional (Profit/BO)','Profit Rasio versi Pak War (100%-OR)')
title(sprintf('Biaya operasional vs Profit dsb berdasar nilai Project %d',projVal))
xlabel('Biaya Operasional (BO)')
ylabel('Nilai Variable sesuai legend')

