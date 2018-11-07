function [ output_args ] = write_Damagefile( damageInfo, out_file )
%writer_Damagefile �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
funcName = 'write_Damagefile';
fid = fopen(out_file,'w');
if fid <0
    output_args=1;
    disp('errors==================');
    disp([funcName,'errors','��5',"fid = fopen(out_file,'w');"])
    disp(out_file);
end

damage_n = sum(sum(damageInfo{1,3}~=0));% �ƻ�����
data = cell(damage_n+1,6);
pipe_damage_n = sum(damageInfo{1,3}~=0,2);%ÿ���ܵ��ϵ��ƻ���
pipe_num = numel(damageInfo{1,1});
data{1,1} = '�ƻ����';
data{1,2} = '���ڹ��߱��';
data{1,3} = '�ù������ƻ��ƻ�����';
data{1,4} = '�ƻ�����ǰ��֮�䳤�ȱ���';
data{1,5} = '�ƻ�����';
data{1,6} = '��©�����Чֱ����mm��';
damage_n_one = 1;
for i = 1:pipe_num
    for j = 1:pipe_damage_n(i)
        damage_n_one = damage_n_one+1;
        data{damage_n_one,1} = num2str(damage_n_one-1);%��һ�У��ƻ����
        data{damage_n_one,2} = damageInfo{1,5}{i};%�ڶ��У��ܵ�id
        data{damage_n_one,3} = num2str(j);%�����У��ܵ��ϵ��ƻ�����
        data{damage_n_one,4} = num2str(damageInfo{1,2}(i,j));%�����У��ܵ��ϵ��ƻ�����֮ǰ�ƻ���ľ����������ܵ����ȵı���
        data{damage_n_one,5} = num2str(damageInfo{1,3}(i,j));%�����У��ƻ����ͣ�1й¶��2�Ͽ�
        data{damage_n_one,6} = num2str(damageInfo{1,6}(i,j));%�����У���Ч���
    end
end 
for n = 1:(damage_n+1)
    fprintf(fid,'%s \t %s \t %s \t %s \t %s \t %s',data{n,:});
    fprintf(fid,'\r\n');
end
out_xlsfile = [out_file(1:end-3),'xls'];
xlswrite(out_xlsfile,data)
fclose(fid);
output_args=0;
end

