function [ t,damage_data ] = read_damage_info( input_damage_filename )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
disp('ND_Execut_deterministic:��ʼ�������ƻ���Ϣ');
fid=fopen(input_damage_filename,'r');
if fid <0
    disp(['ND_Execut_deterministic:�ƻ���Ϣ�ļ�����',input_damage_filename]);
    t =1;
    damage_data = 0;
    return
end
damage_data=textscan(fid,'%f%s%f%f%f%f','delimiter','\t','headerlines',1);%��ȡ�������޸�������pipe_num*5: ��1�йܶκ�(�ַ�),2�ܳ�(km),3ƽ������(��/km),4�ܲ�(�ַ�)
fclose(fid);
disp('ND_Execut_deterministic:��ʼ�������ƻ���Ϣ����');
t =0;
end

