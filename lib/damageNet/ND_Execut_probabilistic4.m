%% 1.���������ݹ��ߵľ������ʡ��ܳ������ɹ�����ÿ�����ߵ�й©/�Ͽ��������������Ϣ:
%     1.�����Ƿ��ƻ�; 2. �����ƻ����ڹܳ��еı���λ��; 3.�����ƻ�������ͣ�й©/�Ͽ���;
%     4.����ƻ���Ϊй©��ʱ,й©�����ɢ��ϵ��,��ɢ��ϵ�����������[1]��
%     5.���ݹ��߹ܲĲ�ͬ���ɲ�ͬй©���ͣ���ͬй©���͵�й©������㹫ʽ��ͬ[2].
%[1] �ΰ��������. �����ƻ�����©�����ģ�ͶԱ��о�[J]. ���𹤳��빤����.2013(05):67-75.
%[2] GIRAFFE USER'S MANUAL4.2
%% 2.���˼·�������ص㣻
%% 3.�����д�ˣ��޸�ʱ�䣺�������ݣ�
% ������2017-5-13 19��43�������ļ�ͷ��˵����
% ������2017-6-2 9��43�������ļ�ͷ��˵�����м����˵������������ļ���
% ������2017-6-5 9��43��ȡ������ȫ�ֱ���������������ļ����룻
% ������2017-6-6 9��43��ÿ������ע�ͣ�
% ������2017-6-6 21��43��ɾ��PDD_main.m��PDD_Set.m��PDD_hydraulic.m��User_Number.m��PcR.m������ԭ��������ת����������
% ������2017-07-26 14:49:30����72���ļ�����Ϊ����parameter_pro_of_leak_area_filename�ɺ������ݣ�
% ������2018-06-25 14:49:30�����ӵ�Чֱ����
% ������2019-08-18 14:51:54�������������Ϊtable���ͣ��������ÿ�����ݵĺ��塣
%% 4.����������Ҫ���õ������Աࣨ�Զ��壩���򣨺��������ļ�
%% 4.1 ����
%% 4.2 �ļ�
%% 5.���ô˳��򣨺������ĳ���
% Net_Damage.m
%% 6.���������ƣ��������ͣ�ÿ�У��У����ݵĺ��弰��λ�������������Դ������ֵ�������ļ����룬�����������򣨺�����¼�룻
%% 6.1�������
% input_RR_filename, �ַ��������ߵľ������������ļ���;
% net_data,cell,Read_File������ȡ'input_net_filename'�ļ�����,��1��,��������(����); ��2��,��Ӧ��������cell,��net.inp�ļ����;
% pipe_break_rate,�����ƻ����жϿ�����ռ�ı���;
% pipe_damage_num_max,ÿ�����߿��ܲ������ƻ����������ֵ;
% C,©ˮ�㵥λת��ϵ��;
% mu,�׿�����ϵ��;
% AL_para,©�����ϵ��;
% n_seed,ģ�����©����������ֵ��
%% 6.2�������
% t,double,t=0��ʾ���������޴���
% damage_pipe_info,Ԫ������,���4�����ݣ�1�ƻ����ߵ�λ�ú�(����)��2�����ƻ���֮ǰ�ĳ��ȱ���(����)��3�ƻ�����ƻ�����(����)��4��©�ƻ������ɢ��ϵ��(����);
%% 6.3�м����
% [1]input_RR_name���ַ�����RR�ļ�����·�����ļ�parametric.txt����
% [2]C ��double����λת��ϵ�����ļ�parametric.txt����
% [3]mu ��double���׿�����ϵ�����ļ�parametric.txt����
% [4]AL1 ��double���׿����ϵ�����ļ�parametric.txt����
% [5]n_seed��double ��������������ɵ����ӣ��ļ�parametric.txt����
% [6]D1 ��%���ɹܵ��ƻ�������0�������ƻ���1����ùܵ��ƻ�
% [7]D2 ��%�ƻ�λ�þ���ÿһ�У���һ��Ϊ��һ���ƻ������ʼ��ĳ���������ܳ��ı�����
%                                              �ڶ���Ϊ�ڶ����ƻ�����һ���ƻ���ĳ���������ܳ��ı���...
% [8]D3 ��%�ƻ����;���ÿһ�У���һ��Ϊ��һ���ƻ�������ͣ�1��©/2�Ͽ���
%                                              �ڶ���Ϊ�ڶ����ƻ�������ͣ�1��©/2�Ͽ���...
% [9]D4 ��%��ɢ��ϵ��ϵ���;���
% [10] M1 ��D1������
% [11]pipe_break_rate,�Ͽ�����©�ͱ���
% [12]AL,double,������©�������m2��
% [13]RR_data,cell,�޸�������,
% [14]pipe_damage_num_max,double,��������ƻ�����
% [15]d,double,����ֱ����m��
% [16]cross_area,double,���߽������m2��
% [17]mu1,�����
% [18]L1,�ƻ����ȣ�m��
%%
function [t,output]=ND_Execut_probabilistic4(net_pipe_id,damage_data,pipe_damage_num_max,C,mu)
pipe_damage_data = damage_data;
% pipe_num = numel(net_pipe_id);% �ܵ�����
damage_num=numel(pipe_damage_data{1}); %�ƻ����������
damage_pipe_id=deblank(pipe_damage_data{2}); %�ƻ����ڹ��߱�ţ�
damage_pipe_num=numel(unique(damage_pipe_id));%�����ƻ���Ĺܵ�������
damage_pipe_node=pipe_damage_data{3}; %�ƻ����ڸù����ϵ��ƻ�����
damage_pipe_length=pipe_damage_data{4}; %�ƻ������֮��ĳ��ȱ�����
damage_node_kind=pipe_damage_data{5}; %�ƻ�������ͣ�
damage_node_diameter=pipe_damage_data{6}; %�ƻ���ĵ�Чֱ��
damage_node_area=(pi*damage_node_diameter.^2)/4;%���������
damage_node_e=damage_node_area*C*mu; %�ƻ������ɢ��ϵ����

% D1=zeros(pipe_num,1); %�����Ƿ�����ƻ����б����0���ƻ�; 1���ƻ�;
D1=cell(damage_pipe_num,1);%ÿ���ƻ��ܵ���ID�ţ�
D2=zeros(damage_pipe_num,pipe_damage_num_max);
%D2�����ƻ���λ�þ��󣻵�1��Ϊ��1���ƻ��������ĳ���������ܳ��ı�������2��Ϊ��2���ƻ�����1���ƻ���ĳ���������ܳ��ı���...��
D3=zeros(damage_pipe_num,pipe_damage_num_max);
%D3�����ƻ����ƻ����;��󣻵�1��Ϊ��1���ƻ�������ͣ�1��©/2�Ͽ�����2��Ϊ��2���ƻ�������ͣ�1��©/2�Ͽ�...��
D4=zeros(damage_pipe_num,pipe_damage_num_max);
%D4����й©�����ɢ��ϵ�����󣺵�1��Ϊ��1���ƻ����й©��ɢ��ϵ�������˵�Ϊ�Ͽ��㣬�����ֵΪ0����ɢ��ϵ������©ˮ��LPS��λ���㣻
D5=zeros(damage_pipe_num,pipe_damage_num_max);
%D5����й©�����ɢ��ϵ�����󣺵�1��Ϊ��1���ƻ����й©��ɢ��Чֱ�������˵�Ϊ�Ͽ��㣬�����ֵΪ0����ɢ��ϵ������©ˮ��LPS��λ���㣻
D6=zeros(damage_pipe_num,pipe_damage_num_max);
%D6����й©�����ɢ��ϵ�����󣺵�1��Ϊ��1���ƻ���Ĵֲڶ�ϵ�������˵�Ϊ�Ͽ��㣬�����ֵΪ0����ɢ��ϵ������©ˮ��LPS��λ���㣻
%-------------
% �������һ���Լ��
pipe_test = ismember(damage_pipe_id,net_pipe_id);%����ƻ��ļ�������ļ��Ƿ���Ϣһ��
    if ~all(pipe_test)
        disp('errors==================');
        disp(mfilename)
        disp('damage.txt���ƻ��ܵ������inp�ļ��в�һ�¡�');
        t = 1;
        output = l;
        return
    end
%--------------
n_h = 0;%�����ƻ���Ĺܵ�������
for i = 1:damage_num
%     pipe_loc = ismember(net_pipe_id,damage_pipe_id{i});
    if damage_pipe_node(i) == 1 %�ƻ�����
        n_h = n_h + 1;
        D1(n_h) = damage_pipe_id(i);
    end
    n_l=damage_pipe_node(i);
    D2(n_h,n_l)=damage_pipe_length(i);
    D3(n_h,n_l)=damage_node_kind(i);
    D4(n_h,n_l)=damage_node_e(i);
    D5(n_h,n_l)=damage_node_diameter(i);
    diameter = damage_node_diameter(i)*0.001;%��λת��
    D6(n_h,n_l) = (damage_node_e(i)/((diameter)^2.435*(10.67^(-0.5))*1000))^(1/0.926);% �ֲڶ�ϵ��
%     D6(n_h,n_l)=D4(i,j)/(((D5(i,j)*0.001)^2.63)*(10.67)^(-0.54)*1000);%�ֲڶ�ϵ��
end
%-------------
%-------------

[~,M1]=ismember(D1,net_pipe_id);%ÿ���ƻ��ܵ�ID�������й����е�����ţ�
mid_D2=1-sum(D2,2);
for i=1:damage_pipe_num
    damage_pipe_node_num=sum(D2(i,:)~=0,2);
    D2(i,damage_pipe_node_num+1)=mid_D2(i); %�ƻ��ܵ������е����1��������ֵΪ��1���ƻ����ܵ��յ�ĳ��ȱ�����
end
pipe_damage_node_num=sum(sum(D2)>0); %sum(D2)Ϊ1*pipe_damage_num_max��Ϊ���б���ߵ�ʵ���ƻ�����������ֵ��
% pipe_id = net_pipe_id(M1);
% damage_pipe_info=[{M1},{D2(M1,1:pipe_damage_num)},{D3(M1,1:pipe_damage_num)},{D4(M1,1:pipe_damage_num)},{pipe_id},{D5(M1,1:pipe_damage_num)},{D6(M1,1:pipe_damage_num)}];
%damage_pipe_info,Ԫ������,���4�����ݣ�1�ƻ����ߵ�λ�ú�(����)��2�����ƻ���֮ǰ�ĳ��ȱ���(����)��3�ƻ�����ƻ�����(����)��4��©�ƻ������ɢ��ϵ��(����);
%damage_pipe_info����Ԫ������洢����Ϊ�˷������D2~D4��ÿ�е����ݣ��������ؼ���ÿ�еľ����кţ�
t=0;
damage_pipe_info.Pipe_loc = M1;
damage_pipe_info.Interval_Length = D2(:,1:pipe_damage_node_num);
damage_pipe_info.Damage_Type = D3(:,1:pipe_damage_node_num-1);
damage_pipe_info.Emitter_Coeff = D4(:,1:pipe_damage_node_num-1);
damage_pipe_info.Pipe_ID = D1;% pipe_id
damage_pipe_info.Pipe_Diameter = D5(:,1:pipe_damage_node_num-1);
damage_pipe_info.Pipe_Roughness = D6(:,1:pipe_damage_node_num-1);
damage_pipe_info_table = struct2table(damage_pipe_info);
% ����������Ϊtable��ʽ�ı���������˵��ÿ�б����ĺ��塣
output = damage_pipe_info_table;
end