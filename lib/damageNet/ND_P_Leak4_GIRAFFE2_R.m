%% ���������������ƻ���Ĺ���ˮ��ģ�Ͳ��������幦����2��
% 1.���ƻ����������Ϣdamage_node_data���Ӷ�άԪ������ת��ΪһάԪ������damage_node_data_solo������ÿ������Ԫ��Ϊ1���ṹ��;
% 2.�б�����ƻ������ͣ���©/�Ͽ���,��Ϊ�Ͽ���������1���ƻ���,���ƻ�������Ϊ����ˮ�أ����ı�Ͽ����ڽӹܶεĽڵ���Ϣ��
% 3.���ƻ���Ľṹ��������Ϣת��ΪԪ�����飬�������ÿ��Ԫ��Ϊ1���������
%% 2.���˼·�������ص㣻
%% 3.�����д�ˣ��޸�ʱ�䣺�������ݣ�
% ������2017-5-13 19��43�������ļ�ͷ��˵����
% ������2017-6-2 9��43�������ļ�ͷ��˵�����м����˵������������ļ���
% ������2017-6-5 9��43��ȡ������ȫ�ֱ���������������ļ����룻
% ������2017-6-6 9��43��ÿ������ע�ͣ�
% ������2018-6-25 9��43���޸�ģ��й¶�ƻ����ģ�ⷽʽ��
% ������2018-6-25 9��43���޸�ģ��Ͽ��ƻ����ģ�ⷽʽ��
%% 4.����������Ҫ���õ������Աࣨ�Զ��壩���򣨺��������ļ�
%% 4.1 ����
% [1]
% 4.2 �ļ�
% ��%% 5.���ô˳��򣨺������ĳ���
% [1]
% 6.���������ƣ��������ͣ�ÿ�У��У����ݵĺ��弰��λ�������������Դ������ֵ�������ļ����룬�����������򣨺�����¼�룻
% 6.1�������
% damage_node_data,cell,�洢������ÿ���ƻ����������Ϣ,ÿ��Ԫ�ش洢ÿ���ƻ����������Ϣ�ṹ��damage_node_character��
% ÿ��damage_node_character�ṹ������ƻ����������Ϣ��'id',[],'x',[],'y',[],'Elve',[],'type',[],'pipe',{},'pipe_index',[],'order',[],'length',[],'Coefficient',[]��
% damage_pipe_info,Ԫ������,���4��������ͬ�����ݣ�1�ƻ����ߵ�λ�ú�(����)��2�����ƻ���֮ǰ�ĳ��ȱ���(����)��3�ƻ�����ƻ�����(����)��4��©�ƻ������ɢ��ϵ��(����);
% pipe_new_add���ṹ���������Ϊ�����������ƻ��ܶ��������ÿ1�������ƻ��ܶ�������Ϣ�����߱��(�ַ���),�����(�ַ���),�յ���(�ַ���),���߳���(m),�ܶ�ֱ��(mm),�س�ˮͷ��ʧĦ��ϵ��,�ֲ�ˮͷ��ʧĦ��ϵ��
% 6.2�������
% t,double,t=0��ʾ���������޴���
% all_add_node_data��Ԫ�����飬���������ƻ����������Ϣ�������ƻ���=�����ƻ���+�Ͽ�����������1�ƻ��㣻������Ϣ��������id(�ַ���),x,y,Elve(m),type(��©1/�Ͽ�2),pipe(���ڹ��߱���ַ���),pipe_index(���ڹ���λ�ú�),order(���ڹ��ߵĵڼ����ƻ���),length(�����ƻ����ܶγ��ȱ���),Coefficient(��Ϊ��©�����Ӧ����ɢ��ϵ��,ת��ΪLPS������λ)��
% pipe_new_add���Ѹ��¶Ͽ�����ڽӹܶεĽڵ�ţ����ÿ1�������ƻ��ܶ�������Ϣ�ṹ���������Ϊ�����������ƻ��ܶ�������������Ϊ�����߱��(�ַ���),�����(�ַ���),�յ���(�ַ���),���߳���(m),�ܶ�ֱ��(mm),�س�ˮͷ��ʧĦ��ϵ��,�ֲ�ˮͷ��ʧĦ��ϵ��
% 6.3�м����
% [1]D2,double,�ƻ����ڹ����ϵı���
% [2]M1,double,�ƻ����ߵ�λ��
% [3]n,double,����
% [4]BRO_PIPEMUN,double,�ƻ�����
% [5]data5,cell,
% [6]c,cell,
% [7]c1,cell,
%
function [t,all_add_node_data,pipe_new_add_new]=ND_P_Leak4_GIRAFFE2_R(damage_node_data,damage_pipe_info,pipe_new_add)

M1=damage_pipe_info{1,1}; %�ƻ����ߵ�λ�ú�(����)
D2=damage_pipe_info{1,2};
%D2�����ƻ���λ�þ��󣻵�1��Ϊ��1���ƻ��������ĳ���������ܳ��ı�������2��Ϊ��2���ƻ�����1���ƻ���ĳ���������ܳ��ı���...��
D3=damage_pipe_info{1,3};
%D3�����ƻ����ƻ����;��󣻵�1��Ϊ��1���ƻ�������ͣ�1��©/2�Ͽ�����2��Ϊ��2���ƻ�������ͣ�1��©/2�Ͽ�...��
n1=numel(M1);%n1�������ƻ����ߵ�������
% D5=damage_pipe_info{1,6};
% D6=damage_pipe_info{1,7};
pipe_new_add_2=struct('id',[],'N1',[],'N2',[],'Length',0.15,'Diameter',[],'Roughness',[],'MinorLoss',0,'Statues','CV');%��©�ƻ����ӹܵ�
pipe_new_add_1=struct('id',[],'N1',[],'N2',[],'Length',0.15,'Diameter',[],'Roughness',[],'MinorLoss',0,'Statues','CV');%�Ͽ��ƻ����ӹܵ�
% ���ƻ����������Ϣdamage_node_data���Ӷ�άԪ������ת��ΪһάԪ������damage_node_data_solo;
damage_node_num=sum(sum(D2>0))-n1;%ȫ��������ȫ���ƻ���������������Ͽ������ӵ���1�ڵ㣩��
damage_node_data_solo=cell(damage_node_num,1); %�洢�ƻ���������Ϣ�ṹ���Ԫ������������ÿ��Ԫ��Ϊ���ƻ����������Ϣ�ṹ�壻
damage_node_count=0; %�ƻ����������
for i=1:n1
    pipe_damage_num=sum(D2(i,:)>0)-1; %��ÿ���������ƻ����������
    for j=1:pipe_damage_num
        damage_node_count=damage_node_count+1;
        damage_node_data_solo{damage_node_count,1}=damage_node_data{i,j};
    end
end
%  �б��ƻ��ڵ�����ͣ���Ϊ�Ͽ��������µ��ƻ��㣬��Ϊ��©�򲻱ش���
break_node_num=sum(sum(D3==2)); %ȫ�������жϿ��ƻ������������Ҫ���ӵ���1�ڵ����������
leak_node_num=sum(sum(D3==1));
break_node_data=cell(break_node_num,1); %�洢�Ͽ��ƻ���������1�ڵ��������Ϣ�ṹ���Ԫ������������ÿ��Ԫ��Ϊ�������ڵ��������Ϣ�ṹ�壻
leak_node_data=cell(leak_node_num,1);
n2=0; %Ϊ�Ͽ����������ƻ����������
n3=0; %Ϊй¶���������ƻ����������
for i=1:length(damage_node_data_solo) %�����ƻ���ѭ����
    if damage_node_data_solo{i}.type==2 %���ֶϿ��ڵ�
        n2=n2+1;%�����ƻ��ڵ������
        %         n4 =
        damage_node_data_solo{i}.Coefficient =0;
        break_node_data{n2,1}=damage_node_data_solo{i};%������1���ڵ�
        damage_node_data_solo{i}.type =1;
        break_node_data{n2,1}.type = 1;
        break_node_data{n2,1}.id=[damage_node_data_solo{i}.id,'-b-',num2str(1),'2-r'];%�ڵ�ID
        
        %         m2_ID{1,j} = break_node_data{n2,1}.id;
        %         pipe_relative_2{i,2} = [pipe_relative{i,2},m2_ID];
        for j=1:length(pipe_new_add) %���������ӵĹܶ�ѭ���������ĸ������ܶε����Ϊ�˽ڵ㣻
            if strncmp(pipe_new_add(j).N2,damage_node_data_solo{i}.id,255)
                pipe_new_add(j).Statues ='';
            end
            if strncmp(pipe_new_add(j).N1,damage_node_data_solo{i}.id,255)
                temp = pipe_new_add(j).N2;
                pipe_new_add(j).N2=break_node_data{n2,1}.id;
                pipe_new_add(j).N1 = temp;
                pipe_new_add(j).Statues ='';
            end
        end
        %
        break_node_data{n2,2}=damage_node_data_solo{i};%������2���ڵ�
        break_node_data{n2,2}.type =2;
        break_node_data{n2,2}.id=[damage_node_data_solo{i}.id,'-',num2str(2),'-R','2-r'];%�ڵ�ID
        pipe_new_add_1(n2,1).id = [break_node_data{n2,2}.id,'-pipe','2-r'];%�¼ӹܵ�id
        pipe_new_add_1(n2,1).N1 =damage_node_data_solo{i}.id;
        pipe_new_add_1(n2,1).N2 =break_node_data{n2,2}.id;
        pipe_new_add_1(n2,1).Diameter = damage_node_data_solo{i}.Diameter;
        pipe_new_add_1(n2,1).Length=0.1;%�ܵ�����Ϊ0.1m
        pipe_new_add_1(n2,1).Roughness=1e6;
        pipe_new_add_1(n2,1).MinorLoss=0;
        pipe_new_add_1(n2,1).Statues='CV';
        %=====================================================================
        break_node_data{n2,3}=damage_node_data_solo{i};%������3���ڵ�
        break_node_data{n2,3}.id=[break_node_data{n2,1}.id,'-',num2str(3),'-R','2-r'];%�ڵ�ID
        break_node_data{n2,3}.type =2;
        pipe_new_add_1(n2,2).id = [break_node_data{n2,3}.id,'-pipe-2','2-r'];%�¼ӹܵ�id
        pipe_new_add_1(n2,2).N1 =break_node_data{n2,1}.id;
        pipe_new_add_1(n2,2).N2 =break_node_data{n2,3}.id;
        pipe_new_add_1(n2,2).Diameter = damage_node_data_solo{i}.Diameter;
        pipe_new_add_1(n2,2).Length=0.1;%�ܵ�����Ϊ0.1m
        pipe_new_add_1(n2,2).Roughness=1e6;
        pipe_new_add_1(n2,2).MinorLoss=0;
        pipe_new_add_1(n2,2).Statues='CV';
    else % ��©�ƻ�
        n3 = n3+1;
        damage_node_data_solo{i}.Coefficient =0;
        leak_node_data{n3,1}=damage_node_data_solo{i};
        leak_node_data{n3,1}.type = 2;%���͸�ΪˮԴ��
        leak_node_data{n3,1}.id = [damage_node_data_solo{i}.id,'-R','2-r'];%���͸�ΪˮԴ��
        pipe_new_add_2(n3,1).id = [damage_node_data_solo{i}.id,'leak-pipe','2-r'];%�¼ӹܵ�id
        pipe_new_add_2(n3,1).N1 =damage_node_data_solo{i}.id;
        pipe_new_add_2(n3,1).N2 =leak_node_data{n3,1}.id;
        pipe_new_add_2(n3,1).Diameter = damage_node_data_solo{i}.Diameter;
        pipe_new_add_2(n3,1).Length=0.1524;%�ܵ�����Ϊ1m
        pipe_new_add_2(n3,1).Roughness=1e6;
        pipe_new_add_2(n3,1).MinorLoss=2.7778;
        pipe_new_add_2(n3,1).Statues='CV';
        
    end
end
if break_node_num~=0
    pipe_new_add_3 = [pipe_new_add_1(:,1);pipe_new_add_1(:,2)];%��pipe_new_add_1���Σ���Ϊ1��
    break_node_data_2 = [break_node_data(:,1);break_node_data(:,2);break_node_data(:,3)];%��break_node_data���Σ���Ϊ1��
else
    pipe_new_add_3=[];
    break_node_data_2=[];
end
if leak_node_num~=0
else
    leak_node_data=[];
    pipe_new_add_2=[];
end
if (break_node_num~=n2) || (leak_node_num~=n3)
    keyboard
end
%% ���ƻ���Ľṹ��������Ϣת��ΪԪ�����飻���ƻ����������Ϣ���ϲ�����Ͽ������ӵ���1�ƻ���������Ϣ���²����ϲ�[�ϲ����²�]��
if isempty(damage_node_data_solo)
    keyboard
end
mid_data=(struct2cell(damage_node_data_solo{1}))'; %����ת�����м������
% n4=numel(mid_data); %�ƻ��ڵ�������Ϣ�ṹ�������Եĸ�����
n_node = numel(break_node_data_2)+numel(leak_node_data)+damage_node_num;
all_add_node_data=cell(n_node,numel(mid_data));
%----------------------------------------------------------
%�ṹ�������м�ת��
for i=1:damage_node_num
    mid_data1(i)=damage_node_data_solo{i};
end
mid_data2=struct2cell(mid_data1);
mid_data3=reshape(mid_data2,[numel(mid_data),damage_node_num]);
%-----------------------------------------------------------
all_add_node_data(1:damage_node_num,:)=mid_data3';
%----------------------------------------------------------
mid_data1=[];
mid_data2=[];
mid_data3=[];
%�ṹ�������м�ת��
if break_node_num~=0
    
    for i=1:numel(break_node_data_2)
        mid_data111(i)=break_node_data_2{i};
    end
    mid_data2=struct2cell(mid_data111);
    mid_data3=reshape(mid_data2,[numel(mid_data),numel(break_node_data_2)]);
    %-----------------------------------------------------------
    all_add_node_data(damage_node_num+1:damage_node_num+numel(break_node_data_2),:)=mid_data3';
else
    
end
mid_data1=[];
mid_data2=[];
mid_data3=[];
if leak_node_num~=0
    for i_n3 =1:leak_node_num
        mid_data1111(i_n3)=leak_node_data{i_n3};
    end
    mid_data2=struct2cell(mid_data1111);
    mid_data3=reshape(mid_data2,[numel(mid_data),leak_node_num]);
    all_add_node_data(damage_node_num+numel(break_node_data_2)+1:end,:)=mid_data3';
else
    pipe_new_add_2=[];
end
pipe_new_add_new = [pipe_new_add;pipe_new_add_3;pipe_new_add_2];
t=0;
end