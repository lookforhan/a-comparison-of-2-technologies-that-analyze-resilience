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
errcode=calllib(libName,'ENclose');% �ر��ļ�
unloadlibrary(libName) % ж�ض�̬���ӿ�
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
% ɾ��tank��Ϊ�򵥣������˹��ֶ�ɾ����ɾ�����ļ�����Ϊ��out_inp_2 
% 2.1 ��[TANKS]��ɾ��41��42
% 2.1 ��[PIPES]��ɾ���漰21��42�Ĺܵ�
% 2.3 ��[COORDINATE]��ɾ��41��42
% 3 ɾ��pump
% ɾ��pump��Ϊ�򵥣������˹��ֶ�ɾ����ɾ�����ļ�����Ϊ��out_inp_3 
% 3.1 ��[PUMPS]����ɾ��78��79��80
% 3.2 ��[ENERGY]��ɾ��79��79��80
% 3.3 ��[PIPES]������һ������Դ��40��ڵ�20��
% ��126  40  20  1   762 130 0����ʼ�ڵ�Ϊ40����ֹ�ڵ�Ϊ20���ܳ�Ϊ1m���ܾ�Ϊ762mm,�ֲ�ϵ��Ϊ130���ֲ���ʧϵ��Ϊ0
% 4 �����޸�
% 5 �����޸ĺ����һЩ���⣬����������ָ�ѹ����out_inp_3�ļ��ڱ�׼EPANET 2Ӧ���н���ƽ����㣬Ӧ�ø���������Ϣ�������ָ�ѹ��Ϊ�˽����ѹ���⣬��inp�ļ�����һЩ�޸ġ�
% 5.1 �ܵ�110��113��114��115��116��125�ܾ�̫СΪ��0.002540mm���޸�Ϊ203.2mm
% 5.2 Դ��ˮͷΪ3.048m,̫�ͣ���Ϊ263.048m
