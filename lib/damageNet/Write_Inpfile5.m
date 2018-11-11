
%% 1.本函数的功能，将水力模型数据写入inp格式文本文件；
%% 2.编程思路，程序特点；
%% 3.程序编写人；修改时间：更新内容；
% 韩朝；2017-5-13 19：43；增加文件头部说明；
% 韩朝；2017-6-2 9：43；增加文件头部说明中中间变量说明；输出报告文件名
% 韩朝；2017-6-5 9：43；取代所有全局变量，输入参数由文件读入；
% 韩朝；2017-6-6 9：43；每行增加注释；
% 韩朝；2017-07-26 10:56:01；为适应main12.m修改65行j_data2结构，原三列改为二列。原第三列为0;
%% 4.正常运行需要调用的其他自编（自定义）程序（函数）或文件
%% 4.1 程序
% 无
%% 4.2 文件
% [1]output_net_name
%% 5.调用此程序（函数）的程序？
% main_s.m
%% 6.变量：名称，数据类型，每列（行）数据的含义及单位，输入变量的来源：程序赋值，数据文件读入，调用其他程序（函数）录入；
%% 6.1输入变量
% [1]net_data
% [2]format_data
% [3]outdata
% [4]output_net_name
%% 6.2输出变量
% [1]t,double,t=0表示程序运行无错误
% [2]output_net_name文件
%% 6.3中间变量
% [1]formatSpec_out,cell,fprintf输出数据格式,format_data{3}赋值
% [2]list,cell,新建节点类型[JUNCTIONS][RESERVOIRS],outdata{3}赋值
% [3]j_data_index,double,新建节点中类型为[JUNCTIONS]的节点,程序赋值
% [4]j_data2,cell,新建节点[JUNCTIONS]的节点数据,程序赋值
% [5]j_data,cell,需水节点数据,程序赋值
% [6]e_data2,cell,新建节点[JUNCTIONS]的节点扩散系数数据,程序赋值
% [7]e_data,cell,扩散系数数据,程序赋值
% [8]d_data2,cell,新建节点[JUNCTIONS]的节点需水量数据,程序赋值
% [9]d_data,cell,需水节点需水量数据,程序赋值
% [10]r_data_index,double,新建节点中类型为[RESERVOIRS]的节点,程序赋值
% [11]r_data2,cell,新建节点[RESERVOIRS]的节点数据,程序赋值
% [12]r_data,cell,水厂节点数据,程序赋值
% [13]t_data,cell,水池节点数据,程序赋值
% [14]c_data,cell,坐标数据,程序赋值
% [15]p_data,cell,管线数据,程序赋值
% [16]o_data,cell,option数据,程序赋值
% [17]new_net_data,cell,管网数据文件,程序赋值
% [17]fid,double,文件的句柄参数,fopen函数赋值
function t=Write_Inpfile5(net_data,EPA_format,outdata,output_net_filename)
%% 处理数据格式1
formatSpec_out=EPA_format{1,3};
for i = 2:27
    new_net_data{i,1}=net_data{i,2};
end
if isempty(outdata)
    new_net_data{1,1}=net_data{1,1};%数据类型
    %     new_net_data{2,1}=net_data{2,2};%需水节点数据
    %     new_net_data{3,1}=net_data{3,2};%水厂节点数据
    %     new_net_data{4,1}=net_data{4,2};%水池节点数据
    %     new_net_data{5,1}=net_data{5,2};%管线数据
    %     new_net_data{8,1}=net_data{8,2};%扩散系数数据
    %     new_net_data{15,1}=net_data{15,2};%需水节点需水量数据
    %     new_net_data{20,1}=net_data{20,2};%option数据
    %     new_net_data{23,1}=net_data{23,2};%坐标数据
%     for i = 2:27
%         new_net_data{i,1}=net_data{i,2};
%     end
else
    if isempty(outdata{3})
        j_data2=[];
        e_data2=[];
        d_data2=[];
        r_data2=[];%新建节点[RESERVOIRS]的节点数据
    else
        num=numel(outdata{3}(:,5));
        for i=1:num
            list(i,1)=outdata{3}{i,5};%新建节点类型[JUNCTIONS][RESERVOIRS]
        end
        j_data_index=find(list==1);%新建节点中类型为[JUNCTIONS]的节点
        j_data2=[outdata{3}(j_data_index,1),outdata{3}(j_data_index,4)];%新建节点[JUNCTIONS]的节点数据
        e_data2=[];%新建节点[JUNCTIONS]的节点扩散系数数据
        temp_mid = cell(length(outdata{3}(j_data_index,4)),1);
        d_data2=[outdata{3}(j_data_index,1),num2cell(zeros(length(outdata{3}(j_data_index,4)),1)),temp_mid];%需水量
        r_data_index=find(list==2);%新建节点中类型为[RESERVOIRS]的节点
        r_data2=[outdata{3}(r_data_index,1),outdata{3}(r_data_index,4)];%新建节点[RESERVOIRS]的节点数据
    end
    
    j_data=[outdata{2};j_data2];%需水节点数据
    
    e_data=[outdata{7};e_data2];%扩散器
    
    d_data=[outdata{6};d_data2];% 需水量
    
    
    r_data=[outdata{4};r_data2];%水厂
    t_data=outdata{5};%水池
    c_data=outdata{8};%坐标
    p_data=outdata{1};%管道
    o_data=net_data{20,2};%option数据
    
    %% 处理数据格式2
    new_net_data{1,1}=net_data{1,1};%数据类型
    new_net_data{2,1}=j_data;%需水节点数据
    new_net_data{3,1}=r_data;%水厂节点数据
    new_net_data{4,1}=t_data;%水池节点数据
    new_net_data{5,1}=p_data;%管线数据
    new_net_data{8,1}=e_data;%扩散系数数据
    new_net_data{15,1}=d_data;%需水节点需水量数据
    new_net_data{20,1}=o_data;%option数据
    new_net_data{23,1}=c_data;%坐标数据
end
%% 打开文件,写入数据
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