% name:creat_new_inp.m
% 1. �޸Ĺ����ܵ����ڵ㵥λ��ԭʼanytown.inp�ļ����õ�λΪGPM�����ǹ��ʵ�λ����ˣ����Ƚ���תΪΪ���߸�Ϊ��Ϥ��LPS��λ��
% 2. ɾ���ļ��е�tank
% 3. ɾ���ļ��е�pump���޸�Դ����ˮͷ��
% 4. �ڵ���ˮ��ģʽ��Ϊ1����˲����޸ġ�
% 5. ģʽ1�нڵ���ˮ�����Ϊ1.3�����Ϊ0.6����ȡ����ֵ��Ϊ��̬����ʱ�̣�ģ������ݡ�


% 0 Ԥ����
clear;clc;close all;tic;
hfileName = 'toolkit.h';
libName = 'EPANETx64PDD';
inpfile_origin = '..\materials\anytown_copy1.inp';
out_inp_1 = '..\materials\anytown_01.inp'; % ��һ�������inp�ļ�����origin��ʽת��Ϊ��̬���ӿ�Ĭ��ģʽ��
try
    load EPA_F
catch
%    path('..\lib\toolkit',path);
%    path('..\lib\readNet',path);% �����ļ�
%    path('..\lib\damageNet',path);% �ƻ���صĺ���
%    path('..\lib\EPS',path);% EPS��صĺ���
%    path('..\lib\getValue',path);% ���ֵ
%    path('..\lib\eventTime',path);% �¼�ʱ��
%    path('..\lib\random',path);% ���������
%    path('..\lib\random_singleTime',path);% ��ʱ��ģ��
%    load EPA_F % �����ļ�����ĸ�ʽ
end

% ���ض�̬���ӿ�
try
    loadlibrary('..\materials\EPANETx64PDD.dll','..\materials\toolkit.h');% epanet��̬���ӿ�
catch
    keyboard
end
% ����anytown.inp

errcode=calllib(libName,'ENopen',inpfile_origin,'inpfile_origin.rpt','');% ����inp�ļ�
if errcode~=0
    keyboard
end
% ���
errcode=calllib(libName,'ENsaveinpfile',out_inp_1);% ����14
if errcode~=0
    keyboard
end
% 1 �޸ĵ�λ
 

% 2 ɾ��tank

% 3 ɾ��pump

% 4 �����޸�
% 5 ����
errcode=calllib(libName,'ENclose');% �ر��ļ�
unloadlibrary(libName) % ж�ض�̬���ӿ�