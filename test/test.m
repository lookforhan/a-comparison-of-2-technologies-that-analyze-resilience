% ≤‚ ‘MOD_2.inp°¢MOD_3.inp «∑Òø…“‘À≥¿˚ƒ£ƒ‚
clear;clc;close all;tic;
root_file = 'C:\Users\hc042\Documents\GitHub\a-comparison-of-2-technologies-that-analyze-resilience\materials\';
loadlibrary([root_file,'EPANETx64PDD.dll'],[root_file,'toolkit.h'])

func_name = 'EPANETx64PDD';
libfunctionsview(func_name )
p1 = libpointer('int32Ptr',0);
p2 = libpointer('doublePtr',0);
%%
% ≤‚ ‘MOD.inp
% errcode1 = calllib(func_name,'ENopen',[root_file,'MOD.inp'],'test.rpt','')
% errcode2 = calllib(func_name,'ENsolveH')
% errcode3 = calllib(func_name, 'ENsaveH')
% errcode4 = calllib(func_name,'ENresetreport')
% errcode5 = calllib(func_name,'ENsetstatusreport',2)
% errcode6 = calllib(func_name,'ENsetreport','LINK ALL')
% errcode6_1 = calllib(func_name,'ENsetreport','NODE ALL')
% errcode7 = calllib(func_name,'ENreport')
% errcode8 = calllib(func_name,'ENclose');
% unloadlibrary(func_name)
%% ≤‚ ‘MOD_2.inp
% errcode = calllib(func_name,'ENopen',[root_file,'MOD_2.inp'],'test2.rpt','');
% errcode1 = calllib(func_name,'ENsetoption',0,50);
% errcode2 = calllib(func_name,'ENsolveH')
% errcode3 = calllib(func_name, 'ENsaveH')
% errcode4 = calllib(func_name,'ENresetreport')
% errcode5 = calllib(func_name,'ENsetstatusreport',2);
% errcode6 = calllib(func_name,'ENsetreport','LINK ALL')
% errcode6_1 = calllib(func_name,'ENsetreport','NODE ALL')
% errcode7 = calllib(func_name,'ENreport')
% % errcode7_1 = calllib(func_name,'ENgetversion',p1)
% [errcode7_2,p1] = calllib(func_name,'ENgetnodeemittertype',60,p1)
% [errcode7_1,p1] = calllib(func_name,'ENgetversion',p1)
% errcode8 = calllib(func_name,'ENclose')
% unloadlibrary(func_name)
% ≤‚ ‘MOD_3.inp
errcode = calllib(func_name,'ENopen',[root_file,'MOD_3.inp'],'test2.rpt','');
errcode1 = calllib(func_name,'ENsetoption',0,50);
errcode2 = calllib(func_name,'ENsolveH')
errcode3 = calllib(func_name, 'ENsaveH')
errcode4 = calllib(func_name,'ENresetreport')
errcode5 = calllib(func_name,'ENsetstatusreport',2);
errcode6 = calllib(func_name,'ENsetreport','LINK ALL')
errcode6_1 = calllib(func_name,'ENsetreport','NODE ALL')
errcode7 = calllib(func_name,'ENreport')
[errcode7_2,p1] = calllib(func_name,'ENgetnodeemittertype',60,p1)
[errcode7_1,p1] = calllib(func_name,'ENgetversion',p1)
errcode8 = calllib(func_name,'ENclose')
unloadlibrary(func_name)