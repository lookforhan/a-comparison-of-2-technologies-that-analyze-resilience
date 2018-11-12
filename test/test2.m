% test2.m
% 进行一个测试，读入破坏管网inp后，立即输出，看看是个什么情况。
% 测试成功，得到结论是，生成的破坏管网文件格式有问题，在EPANETx64PDD读入后，出现的参数错误。
clear;clc;close all;tic;
lib_name = 'EPANETx64PDD';
h_name = 'toolkit.h';
net_file = '..\materials\MOD_3.inp';
damage_net = '..\feature_recovery_process_eps\results\damage_net1.inp';
out_dir = '..\feature_recovery_process_eps\results\';
loadlibrary(['..\materials\',lib_name],['..\materials\',h_name]);
errcode1 = calllib(lib_name,'ENopen',damage_net,[out_dir,'damage.rpt'],'');% from 'EPANETx64PDD.dll'
value=libpointer('doublePtr',0);%指针参数--值
[~,value1]=calllib(lib_name,'ENgetnodevalue',1,120,value)%120代表最低水压
[~,value2]=calllib(lib_name,'ENgetnodevalue',1,121,value)%1121代表需求水压
[~,value3]=calllib(lib_name,'ENgetnodevalue',1,122,value)%122代表PDD类型
[~,value4]=calllib(lib_name,'ENgetnodevalue',1,123,value)%123代表PDD状态
errcode2 = calllib(lib_name,'ENsaveinpfile','out.inp')
calllib(lib_name,'ENreport');
calllib(lib_name,'ENclose');
calllib(lib_name,'ENopen','out.inp','out.rpt','')
value=libpointer('doublePtr',0);%指针参数--值
[~,value1]=calllib(lib_name,'ENgetnodevalue',1,120,value)%120代表最低水压
[~,value2]=calllib(lib_name,'ENgetnodevalue',1,121,value)%1121代表需求水压
[~,value3]=calllib(lib_name,'ENgetnodevalue',1,122,value)%122代表PDD类型
[~,value4]=calllib(lib_name,'ENgetnodevalue',1,123,value)%123代表PDD状态
calllib(lib_name,'ENsolveH')
errcode5 = calllib(lib_name,'ENsetstatusreport',2);
calllib(lib_name,'ENreport');
calllib(lib_name,'ENclose');