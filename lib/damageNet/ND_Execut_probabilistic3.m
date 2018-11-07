%% 1.本函数根据管线的经验震害率、管长，生成管网中每条管线的泄漏/断开点的如下属性信息:
%     1.管线是否破坏; 2. 管线破坏点在管长中的比例位置; 3.管线破坏点的类型（泄漏/断开）;
%     4.如果破坏点为泄漏点时,泄漏点的扩散器系数,扩散器系数计算见文献[1]。
%     5.根据管线管材不同生成不同泄漏类型，不同泄漏类型的泄漏面积计算公式不同[2].
%[1] 侯本伟，杜修力. 地震破坏管线漏损分析模型对比研究[J]. 地震工程与工程振动.2013(05):67-75.
%[2] GIRAFFE USER'S MANUAL4.2
%% 2.编程思路，程序特点；
%% 3.程序编写人；修改时间：更新内容；
% 韩朝；2017-5-13 19：43；增加文件头部说明；
% 韩朝；2017-6-2 9：43；增加文件头部说明中中间变量说明；输出报告文件名
% 韩朝；2017-6-5 9：43；取代所有全局变量，输入参数由文件读入；
% 韩朝；2017-6-6 9：43；每行增加注释；
% 韩朝；2017-6-6 21：43；删除PDD_main.m、PDD_Set.m、PDD_hydraulic.m、User_Number.m、PcR.m函数，原函数功能转移至主程序；
% 韩朝；2017-07-26 14:49:30；将72行文件名改为变量parameter_pro_of_leak_area_filename由函数传递；
% 韩朝；2018-06-25 14:49:30；增加等效直径；
%% 4.正常运行需要调用的其他自编（自定义）程序（函数）或文件
%% 4.1 程序
%% 4.2 文件
%% 5.调用此程序（函数）的程序？
% Net_Damage.m
%% 6.变量：名称，数据类型，每列（行）数据的含义及单位，输入变量的来源：程序赋值，数据文件读入，调用其他程序（函数）录入；
%% 6.1输入变量
% input_RR_filename, 字符串，管线的经验震害率数据文件名;
% net_data,cell,Read_File函数读取'input_net_filename'文件内容,第1列,数据名称(汉字); 第2列,对应数据内容cell,与net.inp文件相关;
% pipe_break_rate,管线破坏点中断开点所占的比例;
% pipe_damage_num_max,每条管线可能产生的破坏点数量最大值;
% C,漏水点单位转换系数;
% mu,孔口流量系数;
% AL_para,漏口面积系数;
% n_seed,模拟随机漏点的随机数限值。
%% 6.2输出变量
% t,double,t=0表示程序运行无错误
% damage_pipe_info,元胞数组,存放4类数据：1破坏管线的位置号(向量)；2管线破坏点之前的长度比例(矩阵)；3破坏点的破坏类型(矩阵)；4渗漏破坏点的扩散器系数(矩阵);
%% 6.3中间变量
% [1]input_RR_name，字符串，RR文件存贮路径，文件parametric.txt读入
% [2]C ，double，单位转换系数，文件parametric.txt读入
% [3]mu ，double，孔口流量系数，文件parametric.txt读入
% [4]AL1 ，double，孔口面积系数，文件parametric.txt读入
% [5]n_seed，double ，控制随机数生成的种子，文件parametric.txt读入
% [6]D1 ，%生成管道破坏向量，0代表无破坏，1代表该管道破坏
% [7]D2 ，%破坏位置矩阵；每一行，第一列为第一个破坏点距起始点的长度与管线总长的比例；
%                                              第二列为第二个破坏点距第一个破坏点的长度与管线总长的比例...
% [8]D3 ，%破坏类型矩阵；每一行，第一列为第一个破坏点的类型：1渗漏/2断开；
%                                              第二列为第二个破坏点的类型：1渗漏/2断开；...
% [9]D4 ，%扩散器系数系数型矩阵
% [10] M1 ，D1非零行
% [11]pipe_break_rate,断开与渗漏和比例
% [12]AL,double,管线渗漏截面积（m2）
% [13]RR_data,cell,修复率数据,
% [14]pipe_damage_num_max,double,管线最大破坏个数
% [15]d,double,管线直径（m）
% [16]cross_area,double,管线截面积（m2）
% [17]mu1,随机数
% [18]L1,破坏长度（m）
%%
function [t,damage_pipe_info]=ND_Execut_probabilistic3(net_data,RR_data,probability,pipe_break_rate,pipe_damage_num_max,C,mu,par_data)


MATERIAL={'CI','DI','RS','STL','CON'};%分别是：普通铸铁、球墨铸铁、钢管(铆接)、钢管(焊接)、混凝土管
pipe_num=numel(RR_data{1}); %管线的数量；
pipe_Length=RR_data{1,2}(:,1); %所有管线的长度(km)，pipe_num*1；
pipe_RR=RR_data{1,3}(:,1); %所有管线的平均震害率(处/km)，pipe_num*1；
D1=zeros(pipe_num,1); %管线是否存在破坏的判别矩阵：0无破坏; 1有破坏;
D2=zeros(pipe_num,pipe_damage_num_max);
%D2管线破坏点位置矩阵；第1列为第1个破坏点距管起点的长度与管线总长的比例，第2列为第2个破坏点距第1个破坏点的长度与管线总长的比例...；
D3=zeros(pipe_num,pipe_damage_num_max);
%D3管线破坏点破坏类型矩阵；第1列为第1个破坏点的类型：1渗漏/2断开；第2列为第2个破坏点的类型：1渗漏/2断开...；
D4=zeros(pipe_num,pipe_damage_num_max);
%D4管线泄漏点的扩散器系数矩阵：第1列为第1个破坏点的泄漏扩散器系数，若此点为断开点，则此例值为0；扩散器系数按照漏水量LPS单位计算；
D5=zeros(pipe_num,pipe_damage_num_max);
%D5管线泄漏点的扩散器系数矩阵：第1列为第1个破坏点的泄漏扩散等效直径，若此点为断开点，则此例值为0；扩散器系数按照漏水量LPS单位计算；
D6=zeros(pipe_num,pipe_damage_num_max);
%D6管线泄漏点的扩散器系数矩阵：第1列为第1个破坏点的粗糙度系数，若此点为断开点，则此例值为0；扩散器系数按照漏水量LPS单位计算；
%-------------
%-------------
% fid=fopen(parameter_pro_of_leak_area_filename,'r');
% par_data=textscan(fid,'%s%f','delimiter','\t','headerlines',1);%读
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
for i=1:pipe_num %对所有管线进行循环
    L=0; %遍历过的管线长度记录
    j=0; %管线的破坏点数量记录
    d=net_data{5,2}{i,5};%管线直径（mm）
    %     A=(pi*d^2)/4;%管线截面积(m2)
    while L<pipe_Length(i)
        mu1=rand(1);
        L1=-log(1-mu1)/pipe_RR(i);
        L=L+L1;
        j=j+1;
        if L>pipe_Length(i)
            D2(i,j)=1-sum(D2(i,1:j-1));
            break;
        else
            D1(i)=1;%有破坏
            D2(i,j)=L1/pipe_Length(i);
            mu2=rand(1);
            if mu2<pipe_break_rate
                D3(i,j)=2;%断开
                D4(i,j)=0;
                AL= 0.25*pi*d^2;
                D5(i,j) = d;
                D6(i,j)=1e6;
            else
                D3(i,j)=1;%渗漏
                mu3=rand(1);%随机数
                [~,pipe_material]=ismember(RR_data{4}(i),MATERIAL);%管线管材
                
                type_sum=find(probability.data(pipe_material,:));%对应管材发生泄漏类型
                mid_probabbility=probability.data(pipe_material,type_sum);%对应泄漏类型的发生概率
                num_probability=numel(mid_probabbility);%泄漏类型的个数
                sum_probability=cumsum(mid_probabbility);%对应泄漏类型的发生累加概率
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
                switch leak_type%不同泄漏类型的泄漏面积计算公式
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
            D4(i,j)=C*mu*AL1;%扩散器系数
            D5(i,j)=sqrt(4*AL/pi);%泄露节点等效直径(mm)
            if D5(i,j)==0
                D6(i,j)=0;
            else
                D6(i,j)=D4(i,j)/(((D5(i,j)*0.001)^2.63)*(10.67)^(-0.54)*1000);%粗糙度系数
            end
        end
    end
end
M1=find(D1>0);
pipe_damage_num=sum(sum(D2)>0); %sum(D2)为1*pipe_damage_num_max，为了判别管线的实际破坏点的数量最大值；
pipe_id = net_data{5,2}(M1);
damage_pipe_info=[{M1},{D2(M1,1:pipe_damage_num)},{D3(M1,1:pipe_damage_num)},{D4(M1,1:pipe_damage_num)},{pipe_id},{D5(M1,1:pipe_damage_num)},{D6(M1,1:pipe_damage_num)}];
%damage_pipe_info,元胞数组,存放4类数据：1破坏管线的位置号(向量)；2管线破坏点之前的长度比例(矩阵)；3破坏点的破坏类型(矩阵)；4渗漏破坏点的扩散器系数(矩阵);
%damage_pipe_info采用元胞数组存储，是为了方便调用D2~D4中每列的数据，这样不必计算每列的具体列号；
t=0;
end