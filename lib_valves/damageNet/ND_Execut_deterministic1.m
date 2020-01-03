%% 1.���������ݹ��ߵĹ����ƻ��ļ�damage.txt�����ɹ�����ÿ�����ߵ�й©/�Ͽ��������������Ϣ:
%     1.�����Ƿ��ƻ�; 2. �����ƻ����ڹܳ��еı���λ��; 3.�����ƻ�������ͣ�й©/�Ͽ���;

%% 2.���˼·�������ص㣻
%% 3.�����д�ˣ��޸�ʱ�䣺�������ݣ�
% ������2017-5-13 19��43�������ļ�ͷ��˵����
% ������2017-6-2 9��43�������ļ�ͷ��˵�����м����˵������������ļ���
% ������2017-6-5 9��43��ȡ������ȫ�ֱ���������������ļ����룻
% ������2017-6-6 9��43��ÿ������ע�ͣ�

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
function [t,damage_pipe_info]=ND_Execut_deterministic1(net_data,damage_data)

Pipe_id_data=net_data{5,2}(:,1);
damage_num=numel(damage_data{1});
mid_M1=zeros(damage_num,1);
damage_pipe_id=deblank(damage_data{2});
damage_pipe_node=damage_data{3};
damage_pipe_length=damage_data{4};
damage_node_kind=damage_data{5};
damage_node_diameter=damage_data{6};
damage_node_area=(pi*damage_node_diameter.^2)/4;
damage_node_e=damage_node_area*1e-6*0.62*4427;
    n_h=0;
disp('ND_Execut_deterministic:�����ƻ���Ϣ');
for i=1:damage_num
    mid_t=ismember(Pipe_id_data,damage_pipe_id{i});
    if ~any(mid_t)
        disp('errors==================');
        disp('ND_Execut_deterministic');
        disp('67��');
        disp('damage.txt���ƻ��ܵ������inp�ļ��в�һ�¡�');
        disp(damage_pipe_id{i});
        disp(num2str(i));
        t =1;
        damage_pipe_info=0;
        return
    end
    mid_M1(i)=find(mid_t);
    if damage_pipe_node(i)==1
        n_h=n_h+1;
    end
    n_l=damage_pipe_node(i);
    mid_D2(n_h,n_l)=damage_pipe_length(i);
    mid_D3(n_h,n_l)=damage_node_kind(i);
    mid_D4(n_h,n_l)=damage_node_e(i);
    
    mid_D5(n_h,n_l) = sqrt(damage_node_area(i)*4/pi);
    diameter=mid_D5(n_h,n_l)*0.001;
    mid_D6(n_h,n_l)=(damage_node_e(i)/((diameter)^2.435*(10.67^(-0.5))*1000))^(1/0.926);
end
% M1=unique(mid_M1,'stable');
[M1,ia]=unique(mid_M1);
damage_pipe_id_2=Pipe_id_data(M1);
damage_pipe_num=numel(M1);
mid2_D2=cumsum(mid_D2,2);
mid3_D2=1-mid2_D2(:,end);
D2=mid_D2;
for i=1:damage_pipe_num
    damage_pipe_node_num=sum(mid_D2(i,:)~=0,2);
    D2(i,damage_pipe_node_num+1)=mid3_D2(i);
end
D3=mid_D3;
D4=mid_D4;
D5=mid_D5;
D6 = mid_D6;
damage_pipe_info=[{M1},{D2(ia,:)},{D3(ia)},{D4(ia)},{damage_pipe_id_2},{D5(ia)},{D6(ia)}];
disp('ND_Execut_deterministic:����');
t=0;
end
