%% 2017-12-15
%% ���� hanzhao@emails.bjut.edu.cn
%% ���ܣ�����ÿ��ʱ�䲽�ܵ�״̬���������ƻ�����ˮ��ģ��
%% ����
% PipeStatus_timeStep ��(nB,1)�ܵ�״̬����
% damage_pipe_info_after���ܵ��ƻ���Ϣ��
% net_data,��ˮ��������
%% ���
% t
% outdata ˮ��ģ���ļ�
function [outdata]=timeStepNet(PipeStatus_timeStep,damage_pipe_info,net_data)
% ��ʼ������


% ��ʼ����
[damage_pipe_info_after,close_pipe_info]=timeStepdamage(PipeStatus_timeStep,damage_pipe_info);% ���ݹܵ�״̬��������ÿ��״̬�Ĺܵ��ƻ���Ϣ
if isempty(damage_pipe_info_after{1})
%     disp('û���ƻ�')
    pipe_new_add=[];
    all_add_node_data=[];
    %     outdata=[];
else
    %% �����ƻ��������Ϣ
    [t_j,damage_node_data]=ND_Junction4(net_data,damage_pipe_info_after);%���ɹ����е��ƻ�������
    % t_j,double,t=0��ʾ���������޴���
    % damage_node_data,cell,�洢������ÿ���ƻ����������Ϣ,ÿ��Ԫ�ش洢ÿ���ƻ����������Ϣ�ṹ��damage_node_character��
    % ÿ��damage_node_character�ṹ������ƻ����������Ϣ��'id',[],'x',[],'y',[],'Elve',[],'type',[],'pipe',{},'pipe_index',[],'order',[],'length',[],'Coefficient',[]��
    if t_j==0
%         disp('ND_Junctions��ɣ�')
    else
%         disp('ND_Junctions����')
        return
    end
    [t_p,pipe_new_add]=ND_Pipe4(damage_node_data,damage_pipe_info_after,net_data{5,2});%���ɹ����ƻ�����ڽӹܶ�����
    % pipe_new_add���ṹ�壬����Ϊ�����������ƻ��ܶ��������ÿ1�������ƻ��ܶ�������Ϣ�����߱��(�ַ���),�����(�ַ���),�յ���(�ַ���),���߳���(m),�ܶ�ֱ��(mm),�س�ˮͷ��ʧĦ��ϵ��,�ֲ�ˮͷ��ʧĦ��ϵ��
    if t_p==0
%         disp('ND_Pipes��ɣ�')
    else
%         disp('ND_Pipes����')
        return
    end
    %% ���ڶϿ��ƻ��㣬������1�ڵ㣬���ı����ڽӹܶε���ʼ�ڵ㣻
    [t,all_add_node_data,pipe_new_add]=ND_P_Leak3(damage_node_data,damage_pipe_info_after,pipe_new_add);
    % t,double,t=0��ʾ���������޴���
    % all_add_node_data��Ԫ�����飬���������ƻ����������Ϣ�������ƻ���=�����ƻ���+�Ͽ�����������1�ƻ��㣻������Ϣ������id(�ַ���),x,y,Elve(m),type(��©1/�Ͽ�2),pipe(���ڹ��߱���ַ���),pipe_index(���ڹ���λ�ú�),order(���ڹ��ߵĵڼ����ƻ���),length(�����ƻ����ܶγ��ȱ���),Coefficient(��Ϊ��©�����Ӧ����ɢ��ϵ��,ת��ΪLPS������λ)��
    % pipe_new_add���Ѹ��¶Ͽ�����ڽӹܶεĽڵ�ţ����ÿ1�������ƻ��ܶ�������Ϣ�ṹ���������Ϊ�����������ƻ��ܶ�������������Ϊ�����߱��(�ַ���),�����(�ַ���),�յ���(�ַ���),���߳���(m),�ܶ�ֱ��(mm),�س�ˮͷ��ʧĦ��ϵ��,�ֲ�ˮͷ��ʧĦ��ϵ��
    % ����˵����1. damage_node_data��Ԫ������ÿ�б�ʾ�ƻ������ڹ���λ�úţ�ÿ��Ϊ�ù�����ÿ���ƻ��������������Ϣ�ṹ�壻
    %           2. all_add_node_data��Ԫ������ÿ��Ϊÿ���ƻ���ı�ţ�ÿ��Ϊ���ƻ��ڵ��ĳ��������Ϣ��
    if t==0
%         disp('ND_P_Leak�ɹ���')
    else
%         disp('ND_P_Leakʧ�ܣ�')
    end
end
%% �ϲ����й�����Ϣ
%ɾ���ƻ����ߵ�ԭʼ������Ϣ��
pipe_data=net_data{5,2}; %cell,��ʼ�����й��ߵ�������Ϣ�����߱��(�ַ���),�����(�ַ���),�յ���(�ַ���),���߳���(m),�ܶ�ֱ��(mm),�س�ˮͷ��ʧĦ��ϵ��,�ֲ�ˮͷ��ʧĦ��ϵ��;
pipe_data(close_pipe_info,:)=[]; %ɾ���ƻ����ߵ�ԭʼ������Ϣ,damage_pipe_info_after{1,1}���ƻ�������ԭʼ�������Ծ����е���λ�ú�(����)��
if isempty(pipe_new_add)
    mid_data=[];
else
    mid_data=(struct2cell(pipe_new_add))';
end
pipe_data(:,8) =[];
all_pipe_data=[pipe_data;mid_data];%cell,��ʼ�����й���+�ƻ����ߵ�������Ϣ�����߱��(�ַ���),�����(�ַ���),�յ���(�ַ���),���߳���(m),�ܶ�ֱ��(mm),�س�ˮͷ��ʧĦ��ϵ��,�ֲ�ˮͷ��ʧĦ��ϵ��;
%% �ƻ���������˽ṹ��ͨ�Լ�飬�жϲ�ɾ��������
dataP=all_pipe_data(:,1:3); %������Ϣ,cell,���߱��,�����,ֹ���ţ�
dataR=net_data{3,2}(:,1); %ˮԴ��ţ�
if isempty(all_add_node_data)
    dataC=net_data{23,2}(:,1);
    all_node_coordinate=net_data{23,2};
else
    dataC=[net_data{23,2}(:,1);all_add_node_data(:,1)]; %���нڵ��ţ�����ˮԴ��ˮ�ء��û��ڵ㣩��
    all_node_coordinate=[net_data{23,2};all_add_node_data(:,1:3)]; %���нڵ����꣨����ˮԴ��ˮ�ء��û��ڵ㣩��!!!!!!!!!!!!!!!!!!!!!!!!!!!!
end
if ~isempty(net_data{4,2}) %ˮ�ؽڵ���
    dataT=net_data{4,2}(:,1);
else
    dataT=[];
end
[isolated_node_num,Nid,Nloc,Pid,Ploc]=NC_bfs3(dataP,dataR,dataC,dataT);%����ƻ���������˽ṹ�Ƿ�ȫ��ͨ��
% isolated_node_num,double,�����ڵ��������Nid,double,�����ڵ�ı�ţ�Nloc,double,�����ڵ��λ�úţ�Pid,double,�������ߵı�ţ�Ploc,double,�������ߵ�λ�úţ�

if isolated_node_num==0
%     disp('���������ͨ�Լ�����,�����ڹ����ڵ㣡')
    [~,outdata]=ND_Out_no_delete(all_pipe_data,all_add_node_data,all_node_coordinate,net_data);
else
%     disp(['���������ͨ�Լ����ɣ�����', num2str(isolated_node_num),'�������ڵ㣬�����ڵ㼰���ڽӹܶ���ɾ����'])
    [~,outdata]=ND_Out_delete4(Nid,Nloc,Ploc,all_pipe_data,all_add_node_data,all_node_coordinate,net_data);
end



end