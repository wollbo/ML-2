%imageBase

pVec = 0.05:0.05:0.7;
P = length(pVec);

mseICM = [73.3276290893555 136.022869110107 208.561035156250 292.572006225586 387.492443084717 485.971599578857 593.877815246582 721.615318298340 854.577411651611 999.253307342529 1136.75406265259 1315.71604919434 1485.85343551636 1659.37095260620];
mseMS = [283.351436614990 544.340583801270 796.872661590576 1072.79187393188 1319.52383422852 1593.29507064819 1838.65864562988 2051.95890426636 2385.99497604370 2472.15077590942 2722.33984756470 3025.95482254028 3297.03313446045 3556.91985321045];
mseVar = [270.652732849121 519.199745178223 749.929599761963 973.529148101807 1208.34995651245 1381.47051239014 1521.85306167603 1816.35961151123 1875.29169845581 2043.80825424194 2210.73358917236 2270.13181304932 2397.43474578857 2657.43907165527];

ratioICM = [0.192977722035613 0.176606217920808 0.179345513847125 0.188095622270852 0.198998881759428 0.209908326072759 0.219572573005023 0.234039438791994 0.246500638590852 0.257554801372009 0.268430603046265 0.283828930225613 0.295939415037011 0.307665611369774];
ratioMS = [0.729985981954510 0.704782873584128 0.679223345025857 0.689839639104892 0.678420466200754 0.681368327394713 0.678734339639538 0.662441068422719 0.684062923875348 0.635561029016380 0.638120446229877 0.651863150076513 0.653734550971514 0.655905738633506];
ratioVar = [0.701098441073058 0.662061211896521 0.645891720620166 0.631172431870998 0.627991902468692 0.591403700352372 0.562455406712089 0.582544857252585 0.532118890818690 0.526735090382027 0.521726657016364 0.488056614207752 0.476291056590021 0.486480187758671];

%%

f1 = figure('Name','images/allMSEratio')
plot(ratioICM)
hold on
plot(ratioMS)
plot(ratioVar)
hold off
axis([1 P 0 1])
legend('ICM', 'Max-sum', 'Variational')
set(gca, 'XTick', 1:P); % Change x-axis ticks
set(gca, 'XTickLabel', pVec);
title('MSE ratio with respect to the pixel flip probability p')
xlabel('p')

%%

f2 = figure('Name','images/allMSE')
plot(mseICM)
hold on
plot(mseMS)
plot(mseVar)
hold off
axis([1 P 0 max(mseMS)])
legend('ICM', 'Max-sum', 'Variational')
set(gca, 'XTick', 1:P); % Change x-axis ticks
set(gca, 'XTickLabel', pVec);
title('MSE with respect to the pixel flip probability p')
xlabel('p')