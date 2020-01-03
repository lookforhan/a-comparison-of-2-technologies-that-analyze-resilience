
%% 1.本函数的功能为读入相应（inp）格式的文本文件；
% 格式由参数p_data定义
%% 2.编程思路，程序特点；
%% 3.程序编写人；修改时间：更新内容；
% 韩朝；2017-5-13 19：43；增加文件头部说明；
% 韩朝；2017-6-2 9：43；增加文件头部说明中中间变量说明；输出报告文件名
% 韩朝；2017-6-5 9：43；取代所有全局变量，输入参数由文件读入；
% 韩朝；2017-6-6 9：43；每行增加注释；
% 韩朝；2017-6-6 21：43；删除RF_size、RF_read函数，原函数功能转移至Read_File程序；
% 韩朝；2017-6-6 21：43；删除data2变量；
% 韩朝；2017-6-6 21：43；调整文件读入后的数据格式；
% 韩朝；2017-07-26 11:01:54；为适应main12,epanet2.dll输出水力模型文件格式，96行textscan读入文件的间隔符由原'/t'改为默认；
% 侯本伟：2018-07-23 15:53；增加了关键词符号'['中间存在含空格的空行（empty_line_count）的处理语句；
%% 4.正常运行需要调用的其他自编（自定义）程序（函数）或文件
%% 4.1 程序
% [1]findmatch
%% 4.2 文件

%% 5.调用此程序（函数）的程序？
% [1]main_s.m
%% 6.变量：名称，数据类型，每列（行）数据的含义及单位，输入变量的来源：程序赋值，数据文件读入，调用其他程序（函数）录入；
%% 6.1输入变量
% [1]input_filename,char,输入文件地址
% [2]p_data,cell,输入文件的数据类型及存储格式
% % p_data{1,1}参数类型
% % p_data{1,2},参数格式
%% 6.2输出变量
% [1]t,double,t=0表示程序运行无错误
% [2]data,cell,input_net_filename,文件内容
% % data第1列为数据类型
% % data第2列为数据内容
%% 6.3中间变量
% [1]input_filename,char,输入文件地址,input_filename赋值
% [2]keyword,cell,数据类型,p_data程序赋值
% [3]format_data,cell,数据存储格式,p_data程序赋值
% [4]keyword_num,数据类型数目，size(keyword)赋值
% [5]lines_num,double,某一类型数据在文件中的行总数,程序赋值
% [6]lines_end,double,某一类型数据在文件中的结束行号,程序赋值
% [7]fid,double,文件的句柄参数,fopen函数赋值
% [8]fid1,double,文件的句柄参数,fopen函数赋值
% [9]lines_num,double,计数,程序赋值
% [10]str1,char,fgetl从文件中读入一行数据,fgetl赋值
% [11]str2,char,数据的uint8格式,程序赋值
% [12]newsect,double,数据类型标志,程序赋值
% [13]sect,double,数据类型标志,程序赋值
% [14]data_size,double,数据文件一些参数,程序赋值
% % 第1列：某一类型数据在文件中的行总数
% % 第2列：某一类型数据在文件中的结束行号
% % 第3列：某一类型数据在文件中的开始行号
% [15]m,double,计数,size赋值,程序赋值
% [16]data_origin,cell,数据内容,程序赋值
% [17]data,cell,文件中的数据类型及数据内容,程序赋值
function [t,data]=Read_Inpfile6(input_filename,EPA_format)
%% 读取关键词并确定关键词的数量
keyword=EPA_format{1};%
format_data=[EPA_format{2},EPA_format{4}];%
keyword_num=numel(keyword(:,1));%
kw_data_lines_num=zeros(keyword_num,1);%某关键词下属的数据在文件中的数据行数
kw_data_lines_st=zeros(keyword_num,1);%某关键词下属的数据在文件中的开始行号
kw_data_lines_end=zeros(keyword_num,1);%某关键词下属的数据在文件中的结束行号
%% 查找关键词在的行号，每个关键词下面的数据行数,数据起始行号,数据结束行号；
lines_count=0;%文件遍历的行号计数；
empty_line_count=0; %两个关键词('[')之间的空行数计数；
title_line_count=0; %某个关键词('[')之间的属性标题行计数；
fid=fopen(input_filename);
sect=-1;
while ~feof(fid)
    str1=fgetl(fid);    
    lines_count=lines_count+1;
    if isempty(str1) %矩阵为空代表该行为空，跳过改行 ；        
        if sect>0
            empty_line_count=empty_line_count+1;
        end
        continue; %读文件中的下一行
    end
%     if sum(isspace(str1(1:2)))>1 %矩阵存在空格字符代表该行为空，跳过改行；
%         if sect>0
%             empty_line_count=empty_line_count+1;
%         end
%         continue; %读文件中的下一行
%     end
    if str1(1)==';' %代表第一字符为‘;’，表示此行为某关键词下的属性名称行 ;
        if sect>0
            title_line_count=title_line_count+1;
        end
        continue; %读文件中的下一行；
    end
    if str1(1)=='[' %代表第一字符为‘[’；表示新节开始；
        str2=deblank(str1);%去掉末尾空格
        newsect=findmatch(str2,keyword,5);%newsect为当前行包含第几个关键词的索引号；
        sect=-1; %当前行是否包含关键词的判别变量；
        if newsect>0 %表示当行行有匹配的关键字；
            sect=newsect;
            lines_st=lines_count;
            empty_line_count=0;
            title_line_count=0;
            continue; %读文件中的下一行；
        end
    end
    if sect>0
        kw_data_lines_st(sect)=lines_st+title_line_count;
        kw_data_lines_end(sect)=lines_count-empty_line_count;
    end  
end
fclose(fid);
kw_data_lines_num=kw_data_lines_end-kw_data_lines_st;
data_size=[kw_data_lines_num,kw_data_lines_end,kw_data_lines_st];%每个关键词对应数据行数，数据结束行号，数据开始行号；
%% 读取文件数据
fid1=fopen(input_filename);
data_origin=cell(keyword_num,1);
for i=1:keyword_num 
    if data_size(i,1)==0
        continue;
    end
    frewind(fid1);
    mid_data=textscan(fid1,format_data{i,1},data_size(i,1),'delimiter',format_data{i,2},'headerlines',data_size(i,3));
    data_character_num=numel(mid_data);
    mid_data2=[];
    for j=1:data_character_num
        if isnumeric(mid_data{j})
            mid_data1=num2cell(mid_data{j});
        else
            mid_data1=deblank(mid_data{j});
        end        
        mid_data2=[mid_data2,mid_data1];
    end
    data_origin{i}=mid_data2;
end
fclose(fid1);
data=[EPA_format{1},data_origin];
t=0;
end