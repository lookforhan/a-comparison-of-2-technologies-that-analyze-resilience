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
out_inp_0 = '..\materials\anytown_00.inp'; % ��һ�������inp�ļ�����origin��ʽת��Ϊ��̬���ӿ�Ĭ��ģʽ��
out_inp_1 = '..\materials\anytown_01.inp'; % �ڶ��������inp�ļ�����λת�����inp�ļ���
out_inp_2 = '..\materials\anytown_02.inp'; % �����������inp�ļ���ɾ��tank��inp�ļ���
out_inp_3 = '..\materials\anytown_03.inp'; % �����������inp�ļ���ɾ��pump��inp�ļ���
try
    load EPA_F
catch
%    path('..\lib\toolkit',path);
   path('..\lib\Unit_conversion',path);% ��λת������
   path('..\lib\readNet',path);% �����ļ�
   path('..\lib\damageNet',path);% �ƻ���صĺ���
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
errcode=calllib(libName,'ENsaveinpfile',out_inp_0);% ����14
if errcode~=0
    keyboard
end
% 1 �޸ĵ�λ
% �ڿ�Unit_conversion��GPM2LPS.m��������ת�����ݵ�λ 
% ����GPM2LPS.m������������ɵ�λ�޸ġ�
% GPM2LPS.m������Ҫ���ñ�׼epanet2.dll
% GPM2LPS.m������ҪdamageNet����Write_inpfile5.m
% GPM2LPS.m������ҪreadNet����findmatch.m/Read_File_dll_inp4.m������
% GPM2LPS.m������Ϊ��ת��ǰinp��ת����inp��
errcode = GPM2LPS(out_inp_0,out_inp_1);
if errcode ~=0
    keyboard
end

% 2 ɾ��tank

% 3 ɾ��pump

% 4 �����޸�
% 5 ����
errcode=calllib(libName,'ENclose');% �ر��ļ�
unloadlibrary(libName) % ж�ض�̬���ӿ�
