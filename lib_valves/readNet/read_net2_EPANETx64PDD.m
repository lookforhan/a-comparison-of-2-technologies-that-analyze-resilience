function [t, net_data ] = read_net2_EPANETx64PDD( input_net_filename,EPA_format)
%read_net ����inp�ļ��е�����
%   �ú��������Read_File_dll_inp4.m��epanet2.dll��epanet2.h��EPA_F.mat���ļ�
%   ����inp�ļ���ַ
%   ���inp�ļ�����,���ΪԪ�����顣
%   2018-8-1�޸ģ�����line20-34.���[PATTERNS]�п��ܳ��ֵ�[NaN]���⡣��������֣�������Ϊ��ʱģ�⣬��ģʽ����6�ı�����
%%
funcName = mfilename;
disp([funcName,'��ʼ��ȡ��',input_net_filename]);
Before_Earthq_rpt='temp_read_net_Before_Earthq.rpt';
% Before_Earthq_out='temp_read_net_Before_Earthq.out';
internal_inpfile='temp_read_net_internal.inp';
% loadlibrary('epanet2.dll','epanet2.h'); %����EPA��̬���ӿ�
code=calllib('EPANETx64PDD','ENopen',input_net_filename,Before_Earthq_rpt,'');% �򿪹��������ļ�
if code==0%�ж�Read_File��ȡinput_net_filename�ļ������Ƿ�ɹ�
    calllib('EPANETx64PDD','ENsaveinpfile',internal_inpfile);
    [t,net_data]=Read_File_dll_inp4(internal_inpfile,EPA_format);%��ȡˮ��ģ��inp�ļ������ݣ�
   if t ~=0
       disp([funcName,'��ȡ����',input_net_filename])
       keyboard
   end
    disp([funcName,'��ȡ��ɣ�',input_net_filename]);
    %========================================
    calllib('EPANETx64PDD','ENclose'); %�رռ���
%     unloadlibrary epanet2;%ж��epanet2.dll
else
    disp('errors==================');
    disp('read_net.m');
    disp(['����net.inp�ļ������������',num2str(code)]);
    calllib('EPANETx64PDD','ENreport'); %������㱨��
    calllib('EPANETx64PDD','ENclose'); %�رռ���
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

