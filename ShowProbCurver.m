%% 显示在不同的phit和pmiss下，各个概率更新后的值组成的曲线
close all;
phit = 0.55;
pmiss = 0.3;
hittable = [];
misstable = [];
oddhit = phit/(1-phit);
oddmiss = pmiss/(1-pmiss);
for i=0.01:0.01:0.99
    oddi = i/(1-i);
    hittable = [hittable; oddi*oddhit/(1+oddi*oddhit)];
    misstable = [misstable; oddi*oddmiss/(1+oddi*oddmiss)];
end
plot(0.01:0.01:0.99,hittable)
hold on;
plot(0.01:0.01:0.99,misstable)