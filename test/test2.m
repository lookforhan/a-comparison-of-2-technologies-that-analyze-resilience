% test2.m
% ����һ�����ԣ������ƻ�����inp����������������Ǹ�ʲô�����
% ���Գɹ����õ������ǣ����ɵ��ƻ������ļ���ʽ�����⣬��EPANETx64PDD����󣬳��ֵĲ�������
clear;clc;close all;tic;
lib_name = 'EPANETx64PDD';
h_name = 'toolkit.h';
net_file = '..\materials\MOD_3.inp';
damage_net = '..\feature_recovery_process_eps\results\damage_net1.inp';
out_dir = '..\feature_recovery_process_eps\results\';
loadlibrary(['..\materials\',lib_name],['..\materials\',h_name]);
errcode1 = calllib(lib_name,'ENopen',damage_net,[out_dir,'damage.rpt'],'');% from 'EPANETx64PDD.dll'
value=libpointer('doublePtr',0);%ָ�����--ֵ
[~,value1]=calllib(lib_name,'ENgetnodevalue',1,120,value)%120�������ˮѹ
[~,value2]=calllib(lib_name,'ENgetnodevalue',1,121,value)%1121��������ˮѹ
[~,value3]=calllib(lib_name,'ENgetnodevalue',1,122,value)%122����PDD����
[~,value4]=calllib(lib_name,'ENgetnodevalue',1,123,value)%123����PDD״̬
errcode2 = calllib(lib_name,'ENsaveinpfile','out.inp')
calllib(lib_name,'ENreport');
calllib(lib_name,'ENclose');
calllib(lib_name,'ENopen','out.inp','out.rpt','')
value=libpointer('doublePtr',0);%ָ�����--ֵ
[~,value1]=calllib(lib_name,'ENgetnodevalue',1,120,value)%120�������ˮѹ
[~,value2]=calllib(lib_name,'ENgetnodevalue',1,121,value)%1121��������ˮѹ
[~,value3]=calllib(lib_name,'ENgetnodevalue',1,122,value)%122����PDD����
[~,value4]=calllib(lib_name,'ENgetnodevalue',1,123,value)%123����PDD״̬
calllib(lib_name,'ENsolveH')
errcode5 = calllib(lib_name,'ENsetstatusreport',2);
calllib(lib_name,'ENreport');
calllib(lib_name,'ENclose');