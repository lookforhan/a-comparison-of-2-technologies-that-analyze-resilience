%% ���������ݹ����ƻ���������Ϣ�������ƻ��ܶ���Ϣ����š���ʼ���š���ֹ���� ���ȡ�ֱ�����ֲ�ϵ����
%% 2.���˼·�������ص㣻
%% 3.�����д�ˣ��޸�ʱ�䣺�������ݣ�
% ������2017-5-13 19��43�������ļ�ͷ��˵����
% ������2017-6-2 9��43�������ļ�ͷ��˵�����м����˵������������ļ���
% ������2017-6-5 9��43��ȡ������ȫ�ֱ���������������ļ����룻
% ������2017-6-6 9��43��ÿ������ע�ͣ�
% ������2017-6-6 21��43��ɾ��PDD_main.m��PDD_Set.m��PDD_hydraulic.m��User_Number.m��PcR.m������ԭ��������ת����������
% ������2017-07-26 10:56:01��Ϊ��Ӧmain12.m�޸�36��pipe_new_add�ṹ��ԭ�����Ը�Ϊ�����ԡ�ԭ�ڰ�����Ϊ����״̬;
% ������2018-06-25 10:56:01���޸�й¶�ƻ����ģ�ⷽ��;

%% 4.����������Ҫ���õ������Աࣨ�Զ��壩���򣨺��������ļ�
%% 4.1 ����
% [1]Net_Damage.m

%% 4.2 �ļ�

%% 5.���ô˳��򣨺������ĳ���
% [1]Net_Damage
%% 6.���������ƣ��������ͣ�ÿ�У��У����ݵĺ��弰��λ�������������Դ������ֵ�������ļ����룬�����������򣨺�����¼�룻
%% 6.1�������
% damage_node_data,cell,�洢������ÿ���ƻ����������Ϣ,ÿ��Ԫ�ش洢ÿ���ƻ����������Ϣ�ṹ��damage_node_character��
%   ÿ��damage_node_character�ṹ������ƻ����������Ϣ��'id',[],'x',[],'y',[],'Elve',[],'type',[],'pipe',{},'pipe_index',[],'order',[],'length',[],'Coefficient',[]��
% damage_pipe_info,Ԫ������,���4��������ͬ�����ݣ�1�ƻ����ߵ�λ�ú�(����)��2�����ƻ���֮ǰ�ĳ��ȱ���(����)��3�ƻ�����ƻ�����(����)��4��©�ƻ������ɢ��ϵ��(����);
% pipe_data,cell,��ʼ�����й��ߵ�������Ϣ�����߱��(�ַ���),�����(�ַ���),�յ���(�ַ���),���߳���(m),�ܶ�ֱ��(mm),�س�ˮͷ��ʧĦ��ϵ��,�ֲ�ˮͷ��ʧĦ��ϵ��;
%% 6.2�������
% t,double,t=0��ʾ���������޴���
% pipe_new_add���ṹ�壬���ÿ1�������ƻ��ܶ�������Ϣ�����߱��(�ַ���),�����(�ַ���),�յ���(�ַ���),���߳���(m),�ܶ�ֱ��(mm),�س�ˮͷ��ʧĦ��ϵ��,�ֲ�ˮͷ��ʧĦ��ϵ��
%% 6.3�м����
% [2]pipe_new_add,struct,����¹ܵ���Ϣ�Ľṹ��
% [3]D2,double,�ƻ����ڹ����ϵı���
% [4]M1,double,�ƻ����ߵ�λ��
% [8]add_pipe_count��double,%�����ӵĹܶμ�������
% [9]damage_pipe_loc,%�ƻ�������ڹ����ڹ��������й�����Ϣ�����е���λ�ñ��
% [10]pipe_damage_num,double,�������ƻ������
%%
function [t,pipe_new_add,pipe_relative]=ND_Pipe5(damage_node_data,damage_pipe_info,pipe_data)
pipe_new_add=struct('id',[],'N1',[],'N2',[],'Length',[],'Diameter',[],'Roughness',[],'MinorLoss',[],'Statues','Open'); 
%pipe_new_add�ṹ�壬���ÿ1�������ƻ��ܶ�������Ϣ�����߱��(�ַ���),�����(�ַ���),�յ���(�ַ���),���߳���(m),�ܶ�ֱ��(mm),�س�ˮͷ��ʧĦ��ϵ��,�ֲ�ˮͷ��ʧĦ��ϵ��
M1=damage_pipe_info{1,1};%�ƻ����ߵ�λ�ú�(����)
m1_ID = pipe_data(M1,1);
D2=damage_pipe_info{1,2};
%D2�����ƻ���λ�þ��󣻵�1��Ϊ��1���ƻ��������ĳ���������ܳ��ı�������2��Ϊ��2���ƻ�����1���ƻ���ĳ���������ܳ��ı���...��
n1=numel(M1);%n1�������ƻ����ߵ�������
%% ��ÿ���ƻ������Ͻ����ƻ��ܶ�������Ϣ��
pipe_damage_num=zeros(n1,1); %��ÿ��������Ӧ�÷ָ�ɵĹܶ�������
add_pipe_count=0; %�����ӵĹܶμ�������
for i=1:n1 %���ƻ��Ĺܵ�����¹ܶ�
    damage_pipe_loc=M1(i);%�ƻ�������ڹ����ڹ��������й�����Ϣ�����е���λ�ñ��
    pipe_damage_num(i)=sum(D2(i,:)>0); %��ÿ��������Ӧ�÷ָ�ɵĹܶ�������
    for j=1:pipe_damage_num(i) %��ÿ��������Ӧ�÷ָ�ɵĹܶ���ѭ����
        add_pipe_count=add_pipe_count+1;
        pipe_new_add(add_pipe_count,1).id=['addP-',damage_pipe_info{1,5}{i,1},'-',num2str(j)];%�����ɵĹܶα��
        m2_ID{1,j}=pipe_new_add(add_pipe_count,1).id;
        m3_ID{i,1} =m2_ID;
        switch j
            case 1 %��1����������ԭ�������
                pipe_new_add(add_pipe_count,1).N1=pipe_data{damage_pipe_loc,2};
                pipe_new_add(add_pipe_count,1).N2=damage_node_data{i,j}.id;
            case pipe_damage_num(i) %����������ԭ�����յ�
                pipe_new_add(add_pipe_count,1).N1=damage_node_data{i,j-1}.id;
                pipe_new_add(add_pipe_count,1).N2=pipe_data{damage_pipe_loc,3};
            otherwise %�������
                pipe_new_add(add_pipe_count,1).N1=damage_node_data{i,j-1}.id;
                pipe_new_add(add_pipe_count,1).N2=damage_node_data{i,j}.id;
        end
        pipe_new_add(add_pipe_count,1).Length=pipe_data{damage_pipe_loc,4}*D2(i,j);%���ߵĳ��ȣ�m��
        pipe_new_add(add_pipe_count,1).Diameter=pipe_data{damage_pipe_loc,5};%���ߵ�ֱ����mm��
        pipe_new_add(add_pipe_count,1).Roughness=pipe_data{damage_pipe_loc,6};%���ߵĴֲ�ϵ��
        pipe_new_add(add_pipe_count,1).MinorLoss=pipe_data{damage_pipe_loc,7};%���ߵľֲ���ʧϵ��  
    end
    clear m2_ID
end

pipe_relative = [m1_ID,m3_ID];
t=0;
end