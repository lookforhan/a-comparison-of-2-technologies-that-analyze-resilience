function [t, net_data ] = read_net( input_net_filename,EPA_format)
%read_net ����inp�ļ��е�����
%   �ú��������Read_File_dll_inp4.m��epanet2.dll��epanet2.h��EPA_F.mat���ļ�
%   ����inp�ļ���ַ
%   ���inp�ļ�����,���ΪԪ�����顣
%   2018-8-1�޸ģ�����line20-34.���[PATTERNS]�п��ܳ��ֵ�[NaN]���⡣��������֣�������Ϊ��ʱģ�⣬��ģʽ����6�ı�����
%%
funcName = 'read_net';
disp([funcName,'��ʼ��ȡ��',input_net_filename]);
Before_Earthq_rpt='read_net_Before_Earthq.rpt';
Before_Earthq_out='read_net_Before_Earthq.out';
internal_inpfile='read_net_internal.inp';
% loadlibrary('epanet2.dll','epanet2.h'); %����EPA��̬���ӿ�
code=calllib('epanet2','ENopen',input_net_filename,Before_Earthq_rpt,Before_Earthq_out);% �򿪹��������ļ�
if code==0%�ж�Read_File��ȡinput_net_filename�ļ������Ƿ�ɹ�
    calllib('epanet2','ENsaveinpfile',internal_inpfile);
    [t,net_data]=Read_File_dll_inp4(internal_inpfile,EPA_format);%��ȡˮ��ģ��inp�ļ������ݣ�
   if t ~=0
       disp([funcName,'��ȡ����',input_net_filename])
       keyboard
   end
    disp([funcName,'��ȡ��ɣ�',input_net_filename]);
    %========================================
    calllib('epanet2','ENclose'); %�رռ���
%     unloadlibrary epanet2;%ж��epanet2.dll
else
    disp('errors==================');
    disp('read_net.m');
    disp(['����net.inp�ļ������������',num2str(code)]);
    calllib('epanet2','ENreport'); %������㱨��
    calllib('epanet2','ENclose'); %�رռ���
%     unloadlibrary epanet2;%ж��epanet2.dll
    net_data=0;
    t=1;
    return
end
delete(Before_Earthq_rpt);
% delete(Before_Earthq_out);
% delete(internal_inpfile);
t=0;
end

