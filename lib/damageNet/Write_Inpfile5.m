
%% 1.�������Ĺ��ܣ���ˮ��ģ������д��inp��ʽ�ı��ļ���
%% 2.���˼·�������ص㣻
%% 3.�����д�ˣ��޸�ʱ�䣺�������ݣ�
% ������2017-5-13 19��43�������ļ�ͷ��˵����
% ������2017-6-2 9��43�������ļ�ͷ��˵�����м����˵������������ļ���
% ������2017-6-5 9��43��ȡ������ȫ�ֱ���������������ļ����룻
% ������2017-6-6 9��43��ÿ������ע�ͣ�
% ������2017-07-26 10:56:01��Ϊ��Ӧmain12.m�޸�65��j_data2�ṹ��ԭ���и�Ϊ���С�ԭ������Ϊ0;
%% 4.����������Ҫ���õ������Աࣨ�Զ��壩���򣨺��������ļ�
%% 4.1 ����
% ��
%% 4.2 �ļ�
% [1]output_net_name
%% 5.���ô˳��򣨺������ĳ���
% main_s.m
%% 6.���������ƣ��������ͣ�ÿ�У��У����ݵĺ��弰��λ�������������Դ������ֵ�������ļ����룬�����������򣨺�����¼�룻
%% 6.1�������
% [1]net_data
% [2]format_data
% [3]outdata
% [4]output_net_name
%% 6.2�������
% [1]t,double,t=0��ʾ���������޴���
% [2]output_net_name�ļ�
%% 6.3�м����
% [1]formatSpec_out,cell,fprintf������ݸ�ʽ,format_data{3}��ֵ
% [2]list,cell,�½��ڵ�����[JUNCTIONS][RESERVOIRS],outdata{3}��ֵ
% [3]j_data_index,double,�½��ڵ�������Ϊ[JUNCTIONS]�Ľڵ�,����ֵ
% [4]j_data2,cell,�½��ڵ�[JUNCTIONS]�Ľڵ�����,����ֵ
% [5]j_data,cell,��ˮ�ڵ�����,����ֵ
% [6]e_data2,cell,�½��ڵ�[JUNCTIONS]�Ľڵ���ɢϵ������,����ֵ
% [7]e_data,cell,��ɢϵ������,����ֵ
% [8]d_data2,cell,�½��ڵ�[JUNCTIONS]�Ľڵ���ˮ������,����ֵ
% [9]d_data,cell,��ˮ�ڵ���ˮ������,����ֵ
% [10]r_data_index,double,�½��ڵ�������Ϊ[RESERVOIRS]�Ľڵ�,����ֵ
% [11]r_data2,cell,�½��ڵ�[RESERVOIRS]�Ľڵ�����,����ֵ
% [12]r_data,cell,ˮ���ڵ�����,����ֵ
% [13]t_data,cell,ˮ�ؽڵ�����,����ֵ
% [14]c_data,cell,��������,����ֵ
% [15]p_data,cell,��������,����ֵ
% [16]o_data,cell,option����,����ֵ
% [17]new_net_data,cell,���������ļ�,����ֵ
% [17]fid,double,�ļ��ľ������,fopen������ֵ
function t=Write_Inpfile5(net_data,EPA_format,outdata,output_net_filename)
%% �������ݸ�ʽ1
formatSpec_out=EPA_format{1,3};
for i = 2:27
    new_net_data{i,1}=net_data{i,2};
end
if isempty(outdata)
    new_net_data{1,1}=net_data{1,1};%��������
    %     new_net_data{2,1}=net_data{2,2};%��ˮ�ڵ�����
    %     new_net_data{3,1}=net_data{3,2};%ˮ���ڵ�����
    %     new_net_data{4,1}=net_data{4,2};%ˮ�ؽڵ�����
    %     new_net_data{5,1}=net_data{5,2};%��������
    %     new_net_data{8,1}=net_data{8,2};%��ɢϵ������
    %     new_net_data{15,1}=net_data{15,2};%��ˮ�ڵ���ˮ������
    %     new_net_data{20,1}=net_data{20,2};%option����
    %     new_net_data{23,1}=net_data{23,2};%��������
%     for i = 2:27
%         new_net_data{i,1}=net_data{i,2};
%     end
else
    if isempty(outdata{3})
        j_data2=[];
        e_data2=[];
        d_data2=[];
        r_data2=[];%�½��ڵ�[RESERVOIRS]�Ľڵ�����
    else
        num=numel(outdata{3}(:,5));
        for i=1:num
            list(i,1)=outdata{3}{i,5};%�½��ڵ�����[JUNCTIONS][RESERVOIRS]
        end
        j_data_index=find(list==1);%�½��ڵ�������Ϊ[JUNCTIONS]�Ľڵ�
        j_data2=[outdata{3}(j_data_index,1),outdata{3}(j_data_index,4)];%�½��ڵ�[JUNCTIONS]�Ľڵ�����
        e_data2=[];%�½��ڵ�[JUNCTIONS]�Ľڵ���ɢϵ������
        temp_mid = cell(length(outdata{3}(j_data_index,4)),1);
        d_data2=[outdata{3}(j_data_index,1),num2cell(zeros(length(outdata{3}(j_data_index,4)),1)),temp_mid];%��ˮ��
        r_data_index=find(list==2);%�½��ڵ�������Ϊ[RESERVOIRS]�Ľڵ�
        r_data2=[outdata{3}(r_data_index,1),outdata{3}(r_data_index,4)];%�½��ڵ�[RESERVOIRS]�Ľڵ�����
    end
    
    j_data=[outdata{2};j_data2];%��ˮ�ڵ�����
    
    e_data=[outdata{7};e_data2];%��ɢ��
    
    d_data=[outdata{6};d_data2];% ��ˮ��
    
    
    r_data=[outdata{4};r_data2];%ˮ��
    t_data=outdata{5};%ˮ��
    c_data=outdata{8};%����
    p_data=outdata{1};%�ܵ�
    o_data=net_data{20,2};%option����
    
    %% �������ݸ�ʽ2
    new_net_data{1,1}=net_data{1,1};%��������
    new_net_data{2,1}=j_data;%��ˮ�ڵ�����
    new_net_data{3,1}=r_data;%ˮ���ڵ�����
    new_net_data{4,1}=t_data;%ˮ�ؽڵ�����
    new_net_data{5,1}=p_data;%��������
    new_net_data{8,1}=e_data;%��ɢϵ������
    new_net_data{15,1}=d_data;%��ˮ�ڵ���ˮ������
    new_net_data{20,1}=o_data;%option����
    new_net_data{23,1}=c_data;%��������
end
%% ���ļ�,д������
fid=fopen(output_net_filename,'w');
if fid < 0
    keyboard
end
% fid = 1;
fprintf(fid,'%s',net_data{1,1});
fprintf(fid,'\r\n');
fprintf(fid,'\r\n');
for i=2:length(new_net_data)
    if isempty(new_net_data{i,1})
        continue;
    else
        fprintf(fid,'%s',net_data{i,1});
        fprintf(fid,'\r\n');
        [rows,~]=size(new_net_data{i,1});
        for row=1:rows
            if isempty(new_net_data{i,1}{row,1})
                continue
            end
            fprintf(fid,formatSpec_out{i},new_net_data{i,1}{row,:});
            fprintf(fid,'\r\n');
        end
        fprintf(fid,'\r\n');
    end
end
fprintf(fid,'%s','[END]');
fclose(fid);
t=0;
end