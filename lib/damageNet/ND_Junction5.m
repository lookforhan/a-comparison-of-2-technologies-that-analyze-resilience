%% 1.�������Ĺ���Ϊ�����ƻ���Ϣ������ˮ��ģ�������ƻ��ڵ�����ݣ���š��̡߳����ꡢ��ˮ������ɢ��ϵ����
%% 2.���˼·�������ص㣻
%% 3.�����д�ˣ��޸�ʱ�䣺�������ݣ�
% ������2017-5-13 19��43�������ļ�ͷ��˵����
% ������2017-6-2 9��43�������ļ�ͷ��˵�����м����˵������������ļ���
% ������2017-6-5 9��43��ȡ������ȫ�ֱ���������������ļ����룻
% ������2017-6-6 9��43��ÿ������ע�ͣ�
% ������2017-6-8 21��43������ѡ��ṹ,switch ����if��
% ������2017-6-16 9��43��ismember����findmatch��
% ������2018-6-25 9��43���޸�й¶���ģ�ⷽ�������ýڵ������ˮ�⣩��
%% 4.����������Ҫ���õ������Աࣨ�Զ��壩���򣨺��������ļ�
%% 4.1 ����
%% 4.2 �ļ�
%% 5.���ô˳��򣨺������ĳ���
% [1]Net_Damage.m
%% 6.���������ƣ��������ͣ�ÿ�У��У����ݵĺ��弰��λ�������������Դ������ֵ�������ļ����룬�����������򣨺�����¼�룻
%% 6.1�������
% net_data,cell,Read_File������ȡ��'input_net_filename'�ļ�����,��1��,��������(����); ��2��,��Ӧ��������cell,��net.inp�ļ����;
% damage_pipe_info,Ԫ������,���4��������ͬ�����ݣ�1�ƻ����ߵ�λ�ú�(����)��2�����ƻ���֮ǰ�ĳ��ȱ���(����)��3�ƻ�����ƻ�����(����)��4��©�ƻ������ɢ��ϵ��(����);
%% 6.2�������
% t,double,t=0��ʾ���������޴���
% damage_node_data,cell,�洢������ÿ���ƻ����������Ϣ,ÿ��Ԫ�ش洢ÿ���ƻ����������Ϣ�ṹ��damage_node_character��
% ÿ��damage_node_character�ṹ������ƻ����������Ϣ��'id',[],'x',[],'y',[],'Elve',[],'type',{},'pipe',{},'pipe_index',[],'order',[],'length',[],'Coefficient',[]��
%% 6.3�м����
% [1]D2,double,�ƻ����ڹ����ϵı���
% [2]D3,double,�ƻ������ɢϵ��
% [3]D4,double,�ƻ��������
% [4]M1,double,�ƻ����ߵ�λ��
% [5]M2,double,D2���ۼ�,
% [6]Elve_data,cell,�ڵ�߳�
% [7]node_new_add,struct,����½ڵ���Ϣ�Ľṹ��
% [8]num_1_pipe,double,�����ƻ������,
% [9]rate,�ƻ���ĳ��ȱ���
% [10]bro_pipe,double,�ƻ������ڵ��±�
% [11]N1,cell,�ƻ����ߵ����
% [12]N2,cell,�ƻ����ߵ��յ�
% [13]N1_elve,double,�ƻ����ߵ����ĸ̣߳�ˮͷ��
% [14]N2_elve,double,�ƻ����ߵ��յ�ĸ̣߳�ˮͷ��
% [15]N1_x,double,�ƻ����ߵ�����x����
% [16]N1_y,double,�ƻ����ߵ�����y����
% [17]N2_x,double,�ƻ����ߵ��յ��x����
% [18]N2_y,double,�ƻ����ߵ��յ��y����
%%
function [t,damage_node_data]=ND_Junction5(net_data,damage_pipe_info) 
%% ����׼��
M1=damage_pipe_info{1,1};%�ƻ����߱�ŵ��±�
D2=damage_pipe_info{1,2};
%D2�����ƻ���λ�þ��󣻵�1��Ϊ��1���ƻ��������ĳ���������ܳ��ı�������2��Ϊ��2���ƻ�����1���ƻ���ĳ���������ܳ��ı���...��
M2=cumsum(D2,2);%D2���ۼ�,�ƻ���λ�õ���߳��ȵı���
D3=damage_pipe_info{1,3};
%D3�����ƻ����ƻ����;��󣻵�1��Ϊ��1���ƻ�������ͣ�1��©/2�Ͽ�����2��Ϊ��2���ƻ�������ͣ�1��©/2�Ͽ�...��
 D4=damage_pipe_info{1,4};
%D4����й©�����ɢ��ϵ�����󣺵�1��Ϊ��1���ƻ����й©��ɢ��ϵ�������˵�Ϊ�Ͽ��㣬�����ֵΪ0����ɢ��ϵ������©ˮ��LPS��λ���㣻
D5=damage_pipe_info{1,6};
%D5����й©���й¶�����Чֱ������1��Ϊ��1���ƻ����й©��������˵�Ϊ�Ͽ��㣬���ֵΪ0������©ˮ��LPS��λ���㣻
D6=damage_pipe_info{1,7};
%D5����й©���й¶�����Чֱ������1��Ϊ��1���ƻ����й©��������˵�Ϊ�Ͽ��㣬���ֵΪ0������©ˮ��LPS��λ���㣻
 if isempty(net_data{4,2})
     Elve_data=[[net_data{2,2}(:,1);net_data{3,2}(:,1)],...
    [net_data{2,2}(:,2);net_data{3,2}(:,2)]]; %���������нڵ㣨�û��ڵ㣬ˮ���ڵ㣬ˮ�ؽڵ㣩�ģ�1��ţ�2�̣߳�ˮ���ڵ�߳��õ���ˮͷ��������
 else
     Elve_data=[[net_data{2,2}(:,1);net_data{3,2}(:,1);net_data{4,2}(:,1)],...
    [net_data{2,2}(:,2);net_data{3,2}(:,2);net_data{4,2}(:,2)]]; %���������нڵ㣨�û��ڵ㣬ˮ���ڵ㣬ˮ�ؽڵ㣩�ģ�1��ţ�2�̣߳�ˮ���ڵ�߳��õ���ˮͷ��������
 end

pipe_data=net_data{5,2};%���߱��,�����,�յ���,����(m),ֱ��(mm),Ħ��ϵ��,�ֲ���ʧϵ��
coordinate_data=net_data{23,2};%�ڵ��ţ�x���꣬y����
%% ����Ԥ����
damage_node_character=struct('id',[],'x',[],'y',[],'Elve',[],'type',[],'pipe',{},'pipe_index',[],'order',[],'length',[],'Coefficient',[],'Diameter',[],'Roughness',[]);%����½ڵ���Ϣ�Ľṹ��
[n1,n2]=size(D2);%n1�������ƻ����ߵ�������n2���ߵ�ʵ���ƻ�����������ֵ��
pipe_damage_num=zeros(n1,1); %��ÿ�������ϲ����ƻ����������
damage_node_data=cell(n1,n2-1); %�洢������ÿ���ƻ����������Ϣ,ÿ��Ԫ�ش洢ÿ���ƻ����������Ϣ�ṹ��damage_node_character��
%% �����к��ƻ���Ĺ��ߣ������ƻ��㣻
for i=1:n1 %�ƻ����ߵ�����
    damage_pipe_loc=M1(i); %�ƻ������ڹ��������й������ݾ������λ�úţ����ƻ����ߵı�ţ��ַ��ͣ���
    pipe_damage_num(i)=sum(D2(i,:)>0)-1;
    %% ��ʼ����������Ϣ׼��
    %������ֹ����
    N1=pipe_data{damage_pipe_loc,2};%���������
    N2=pipe_data{damage_pipe_loc,3};%�����յ���
    %������ֹ��߳�
    N1_elve=Elve_data{ismember(Elve_data(:,1),N1),2};%N1�߳�
    N2_elve=Elve_data{ismember(Elve_data(:,1),N2),2};%N2�߳�
    %������ֹ�������
    num_id1=ismember(coordinate_data(:,1),N1);%N1�ڽڵ��������ݾ����е��к�λ��
    num_id2=ismember(coordinate_data(:,1),N2);%N2�ڽڵ��������ݾ����е��к�λ��
    N1_x=coordinate_data{num_id1,2};%�ƻ����ߵ�����x����
    N1_y=coordinate_data{num_id1,3};%�ƻ����ߵ�����y����
    N2_x=coordinate_data{num_id2,2};%�ƻ����ߵ��յ��x����
    N2_y=coordinate_data{num_id2,3};%�ƻ����ߵ��յ��y����
    for j=1:pipe_damage_num(i) %�ڵ�i���ƻ������ϴ�����j���ƻ���     
        %% �����е��ƻ������Ը�ֵ
        %�����ƻ���߳�
        L_ratio=M2(i,j);%�ƻ���������㳤������߳��ȵı���
        damage_node_character(1).Elve=((1-L_ratio)*N1_elve+L_ratio*N2_elve);%�ƻ���߳�
        %�����ƻ��������
        damage_node_character(1).x=(1-L_ratio)*N1_x+L_ratio*N2_x;%�ƻ����x����
        damage_node_character(1).y=(1-L_ratio)*N1_y+L_ratio*N2_y;%�ƻ����y����
        damage_node_character(1).order=j;%�ƻ�����ȣ��ڼ�����
        damage_node_character(1).length=D2(i,j);%�ƻ���ĳ��ȱ���
        damage_node_character(1).Coefficient=D4(i,j);%�ƻ������ɢϵ��
        damage_node_character(1).Diameter=D5(i,j);%�ƻ����ֱ��
        damage_node_character(1).Roughness=D6(i,j);%�ƻ����ֱ��
        damage_node_character(1).pipe=pipe_data{damage_pipe_loc,1};%�ƻ�������ڹ��߱��
        damage_node_character(1).pipe_index=damage_pipe_loc;%�ƻ�������ڹ��ߵ�λ�ñ��
        damage_node_character(1).id=['add_node-',damage_pipe_info{1,5}{i,1},'-',num2str(j)];%�ƻ����������
        if D3(i,j)==1
            damage_node_character(1).type=1;%�ƻ�������Ϊ��©
        else
            damage_node_character(1).type=2;%�ƻ�������Ϊ�Ͽ�
        end
        %% �����ƻ������Դ洢
        damage_node_data{i,j}=damage_node_character(1);%���ƻ����������Ϣ����Ԫ�������У�
    end
end
t=0;
end
