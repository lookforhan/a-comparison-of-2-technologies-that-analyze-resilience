% 测试MOD_2.inp、MOD_3.inp是否可以顺利模拟
clear;clc;close all;tic;
root_file = 'C:\Users\hc042\Documents\GitHub\a-comparison-of-2-technologies-that-analyze-resilience\materials\';
loadlibrary([root_file,'EPANETx64PDD.dll'],[root_file,'toolkit.h'])

lib_name = 'EPANETx64PDD';
libfunctionsview(lib_name )
p1 = libpointer('int32Ptr',0);
p2 = libpointer('doublePtr',0);
%%
% 测试MOD.inp
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
%% 测试MOD_2.inp
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
% 测试MOD_3.inp
errcode = calllib(lib_name,'ENopen',[root_file,'MOD_3.inp'],'test2.rpt','');
value=libpointer('doublePtr',0);%指针参数--值
[~,value1]=calllib(lib_name,'ENgetnodevalue',1,120,value)%120代表最低水压
[~,value2]=calllib(lib_name,'ENgetnodevalue',1,121,value)%1121代表需求水压
[~,value3]=calllib(lib_name,'ENgetnodevalue',1,122,value)%122代表PDD类型
[~,value4]=calllib(lib_name,'ENgetnodevalue',1,123,value)%123代表PDD状态
calllib(lib_name,'ENsetnodevalue',2,120,50)
calllib(lib_name,'ENsetnodevalue',2,121,10)
[~,value3]=calllib(lib_name,'ENgetnodevalue',2,122,value)%122代表PDD类型
[~,value4]=calllib(lib_name,'ENgetnodevalue',2,123,value)%123代表PDD状态
calllib(lib_name,'ENsaveinpfile','test2_mod.inp')
errcode1 = calllib(lib_name,'ENsetoption',0,50);
errcode2 = calllib(lib_name,'ENsolveH')
errcode3 = calllib(lib_name, 'ENsaveH')
errcode4 = calllib(lib_name,'ENresetreport')
errcode5 = calllib(lib_name,'ENsetstatusreport',2);
errcode6 = calllib(lib_name,'ENsetreport','LINK ALL')
errcode6_1 = calllib(lib_name,'ENsetreport','NODE ALL')
errcode7 = calllib(lib_name,'ENreport')
[errcode7_2,p1] = calllib(lib_name,'ENgetnodeemittertype',60,p1)
[errcode7_1,p1] = calllib(lib_name,'ENgetversion',p1)
errcode8 = calllib(lib_name,'ENclose')
unloadlibrary(lib_name)