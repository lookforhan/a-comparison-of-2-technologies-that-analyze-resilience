function  [t_W,pipe_relative]=damageNetInp2(net_data,damage_pipe_info,EPA_format,output_net_filename)
%damageNetInp2 �����ƻ����������
%   �ú��������Read_File_dll_inp4.m��epanet2.dll��epanet2.h��EPA_F.mat���ļ�
%   ���룺[1]net_data-��������
%   ���룺[2]damage_pipe_info-�ƻ���Ϣ
%   ���룺[3]EPA_format-����ļ���ʽ
%   ���룺[4]output_net_filename-����ļ���ַ
%   �����[1]inp�ļ�
%   �����[2]pipe_relative-�����ܵ���ԭ�ܵ���ϵ
%%
[t_j,damage_node_data]=ND_Junction5(net_data,damage_pipe_info);%���ɹ����е��ƻ�������
[t_p,pipe_new_add,pipe_relative]=ND_Pipe5(damage_node_data,damage_pipe_info,net_data{5,2});%���ɹ����ƻ�����ڽӹܶ�����
[t,all_add_node_data,pipe_new_add]=ND_P_Leak4(damage_node_data,damage_pipe_info,pipe_new_add);
pipe_data=net_data{5,2}; %cell,��ʼ�����й��ߵ�������Ϣ�����߱��(�ַ���),�����(�ַ���),�յ���(�ַ���),���߳���(m),�ܶ�ֱ��(mm),�س�ˮͷ��ʧĦ��ϵ��,�ֲ�ˮͷ��ʧĦ��ϵ��;
%     pipe_data(damage_pipe_info{1,1},:)=[]; %ɾ���ƻ����ߵ�ԭʼ������Ϣ,damage_pipe_info{1,1}���ƻ�������ԭʼ�������Ծ����е���λ�ú�(����)��
for i = 1:numel(pipe_data(:,1))
    if ismember(i,damage_pipe_info{1,1})
        pipe_data{i,8}='Closed;';
    end
end
mid_data=(struct2cell(pipe_new_add))';
all_pipe_data=[pipe_data;mid_data];%cell,��ʼ�����й���+�ƻ����ߵ�������Ϣ�����߱��(�ַ���),�����(�ַ���),�յ���(�ַ���),���߳���(m),�ܶ�ֱ��(mm),�س�ˮͷ��ʧĦ��ϵ��,�ֲ�ˮͷ��ʧĦ��ϵ��;
all_node_coordinate=[net_data{23,2};all_add_node_data(:,1:3)]; %���нڵ����꣨����ˮԴ��ˮ�ء��û��ڵ㣩��
[~,outdata]=ND_Out_no_delete(all_pipe_data,all_add_node_data,all_node_coordinate,net_data);
t_W=Write_Inpfile5(net_data,EPA_format,outdata,output_net_filename);% д���¹���inp
end
