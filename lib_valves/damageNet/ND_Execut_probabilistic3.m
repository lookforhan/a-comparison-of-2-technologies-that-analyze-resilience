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
function [t,damage_pipe_info]=ND_Execut_probabilistic3(net_data,RR_data,probability,pipe_break_rate,pipe_damage_num_max,C,mu,par_data)


MATERIAL={'CI','DI','RS','STL','CON'};%�ֱ��ǣ���ͨ��������ī�������ֹ�(í��)���ֹ�(����)����������
pipe_num=numel(RR_data{1}); %���ߵ�������
pipe_Length=RR_data{1,2}(:,1); %���й��ߵĳ���(km)��pipe_num*1��
pipe_RR=RR_data{1,3}(:,1); %���й��ߵ�ƽ������(��/km)��pipe_num*1��
D1=zeros(pipe_num,1); %�����Ƿ�����ƻ����б����0���ƻ�; 1���ƻ�;
D2=zeros(pipe_num,pipe_damage_num_max);
%D2�����ƻ���λ�þ��󣻵�1��Ϊ��1���ƻ��������ĳ���������ܳ��ı�������2��Ϊ��2���ƻ�����1���ƻ���ĳ���������ܳ��ı���...��
D3=zeros(pipe_num,pipe_damage_num_max);
%D3�����ƻ����ƻ����;��󣻵�1��Ϊ��1���ƻ�������ͣ�1��©/2�Ͽ�����2��Ϊ��2���ƻ�������ͣ�1��©/2�Ͽ�...��
D4=zeros(pipe_num,pipe_damage_num_max);
%D4����й©�����ɢ��ϵ�����󣺵�1��Ϊ��1���ƻ����й©��ɢ��ϵ�������˵�Ϊ�Ͽ��㣬�����ֵΪ0����ɢ��ϵ������©ˮ��LPS��λ���㣻
D5=zeros(pipe_num,pipe_damage_num_max);
%D5����й©�����ɢ��ϵ�����󣺵�1��Ϊ��1���ƻ����й©��ɢ��Чֱ�������˵�Ϊ�Ͽ��㣬�����ֵΪ0����ɢ��ϵ������©ˮ��LPS��λ���㣻
D6=zeros(pipe_num,pipe_damage_num_max);
%D6����й©�����ɢ��ϵ�����󣺵�1��Ϊ��1���ƻ���Ĵֲڶ�ϵ�������˵�Ϊ�Ͽ��㣬�����ֵΪ0����ɢ��ϵ������©ˮ��LPS��λ���㣻
%-------------
%-------------
% fid=fopen(parameter_pro_of_leak_area_filename,'r');
% par_data=textscan(fid,'%s%f','delimiter','\t','headerlines',1);%��
% fclose(fid);
t=par_data{1,2}(1);
k=par_data{1,2}(2);
thita1=par_data{1,2}(3);
thita2=par_data{1,2}(4);
l=par_data{1,2}(5);
k1=par_data{1,2}(6);
k2=par_data{1,2}(7);
w=par_data{1,2}(8);
%-------------
for i=1:pipe_num %�����й��߽���ѭ��
    L=0; %�������Ĺ��߳��ȼ�¼
    j=0; %���ߵ��ƻ���������¼
    d=net_data{5,2}{i,5};%����ֱ����mm��
    %     A=(pi*d^2)/4;%���߽����(m2)
    while L<pipe_Length(i)
        mu1=rand(1);
        L1=-log(1-mu1)/pipe_RR(i);
        L=L+L1;
        j=j+1;
        if L>pipe_Length(i)
            D2(i,j)=1-sum(D2(i,1:j-1));
            break;
        else
            D1(i)=1;%���ƻ�
            D2(i,j)=L1/pipe_Length(i);
            mu2=rand(1);
            if mu2<pipe_break_rate
                D3(i,j)=2;%�Ͽ�
                D4(i,j)=0;
                AL= 0.25*pi*d^2;
                D5(i,j) = d;
                D6(i,j)=1e6;
            else
                D3(i,j)=1;%��©
                mu3=rand(1);%�����
                [~,pipe_material]=ismember(RR_data{4}(i),MATERIAL);%���߹ܲ�
                
                type_sum=find(probability.data(pipe_material,:));%��Ӧ�ܲķ���й©����
                mid_probabbility=probability.data(pipe_material,type_sum);%��Ӧй©���͵ķ�������
                num_probability=numel(mid_probabbility);%й©���͵ĸ���
                sum_probability=cumsum(mid_probabbility);%��Ӧй©���͵ķ����ۼӸ���
                for k_n=1:num_probability
                    switch k_n
                        case 1
                            if mu3<sum_probability(k_n)
                                leak_type=type_sum(k_n);
                                break
                            end
                        otherwise
                            if mu3>sum_probability(k_n-1)&&mu3<sum_probability(k_n)
                                leak_type=type_sum(k_n);
                                break
                            end
                    end
                end
                %----------------------------------------------
                switch leak_type%��ͬй©���͵�й©������㹫ʽ
                    case 1
                        %                         t=10;%(mm)
                        %                         k=0.3;
                        AL=t*k*d*pi;
                    case 2
                        thita=thita1*(2*pi/360);
                        AL=0.5*thita*d^2*pi;
                    case 3
                        %                         l=13*1000;%(mm)
                        thita=(thita2/360)*2*pi;
                        AL=l*d*thita;
                    case 4
                        %                         k1=0.05;
                        %                         k2=0.05;
                        AL=k1*k2*d*d;
                    case 5
                        %                         w=12;
                        AL=k*pi*d*w;
                end
            end
            AL1=AL/1000000;
            D4(i,j)=C*mu*AL1;%��ɢ��ϵ��
            D5(i,j)=sqrt(4*AL/pi);%й¶�ڵ��Чֱ��(mm)
            if D5(i,j)==0
                D6(i,j)=0;
            else
                D6(i,j)=D4(i,j)/(((D5(i,j)*0.001)^2.63)*(10.67)^(-0.54)*1000);%�ֲڶ�ϵ��
            end
        end
    end
end
M1=find(D1>0);
pipe_damage_num=sum(sum(D2)>0); %sum(D2)Ϊ1*pipe_damage_num_max��Ϊ���б���ߵ�ʵ���ƻ�����������ֵ��
pipe_id = net_data{5,2}(M1);
damage_pipe_info=[{M1},{D2(M1,1:pipe_damage_num)},{D3(M1,1:pipe_damage_num)},{D4(M1,1:pipe_damage_num)},{pipe_id},{D5(M1,1:pipe_damage_num)},{D6(M1,1:pipe_damage_num)}];
%damage_pipe_info,Ԫ������,���4�����ݣ�1�ƻ����ߵ�λ�ú�(����)��2�����ƻ���֮ǰ�ĳ��ȱ���(����)��3�ƻ�����ƻ�����(����)��4��©�ƻ������ɢ��ϵ��(����);
%damage_pipe_info����Ԫ������洢����Ϊ�˷������D2~D4��ÿ�е����ݣ��������ؼ���ÿ�еľ����кţ�
t=0;
end