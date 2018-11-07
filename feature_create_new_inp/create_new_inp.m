% name:creat_new_inp.m
% 1. 修改管网管道、节点单位。原始anytown.inp文件采用单位为GPM，并非国际单位，因此，首先将其转为为作者更为熟悉的LPS单位。
% 2. 删除文件中的tank
% 3. 删除文件中的pump，修改源点总水头。
% 4. 节点需水量模式均为1，因此不用修改。
% 5. 模式1中节点需水量最高为1.3，最低为0.6，提取该数值作为静态（单时刻）模拟的依据。


% 0 预处理
clear;clc;close all;tic;
hfileName = 'toolkit.h';
libName = 'EPANETx64PDD';
inpfile_origin = '..\materials\anytown_copy1.inp';
out_inp_0 = '..\materials\anytown_00.inp'; % 第一次输出的inp文件，将origin格式转化为动态链接库默认模式。
out_inp_1 = '..\materials\anytown_01.inp'; % 第二次输出的inp文件，单位转化后的inp文件。
out_inp_2 = '..\materials\anytown_02.inp'; % 第三次输出的inp文件，删除tank的inp文件。
out_inp_3 = '..\materials\anytown_03.inp'; % 第三次输出的inp文件，删除pump的inp文件。
try
    load EPA_F
catch
%    path('..\lib\toolkit',path);
   path('..\lib\Unit_conversion',path);% 单位转换函数
   path('..\lib\readNet',path);% 读入文件
   path('..\lib\damageNet',path);% 破坏相关的函数
%    path('..\lib\EPS',path);% EPS相关的函数
%    path('..\lib\getValue',path);% 获得值
%    path('..\lib\eventTime',path);% 事件时间
%    path('..\lib\random',path);% 随机函数库
%    path('..\lib\random_singleTime',path);% 单时刻模拟
%    load EPA_F % 读入文件所需的格式
end

% 加载动态链接库
try
    loadlibrary('..\materials\EPANETx64PDD.dll','..\materials\toolkit.h');% epanet动态链接库
catch
    keyboard
end
% 读入anytown.inp

errcode=calllib(libName,'ENopen',inpfile_origin,'inpfile_origin.rpt','');% 输入inp文件
if errcode~=0
    keyboard
end
% 输出
errcode=calllib(libName,'ENsaveinpfile',out_inp_0);% 见行14
if errcode~=0
    keyboard
end
errcode=calllib(libName,'ENclose');% 关闭文件
unloadlibrary(libName) % 卸载动态链接库
% 1 修改单位
% 在库Unit_conversion中GPM2LPS.m函数可以转化数据单位 
% 调用GPM2LPS.m函数，可以完成单位修改。
% GPM2LPS.m函数需要调用标准epanet2.dll
% GPM2LPS.m函数需要damageNet库中Write_inpfile5.m
% GPM2LPS.m函数需要readNet库中findmatch.m/Read_File_dll_inp4.m函数。
% GPM2LPS.m的输入为（转化前inp，转化后inp）
errcode = GPM2LPS(out_inp_0,out_inp_1);
if errcode ~=0
    keyboard
end

% 2 删除tank
% 删除tank较为简单，采用人工手动删除，删除后文件保存为：out_inp_2 
% 2.1 在[TANKS]中删除41、42
% 2.1 在[PIPES]中删除涉及21、42的管道
% 2.3 在[COORDINATE]中删除41、42
% 3 删除pump
% 删除pump较为简单，采用人工手动删除，删除后文件保存为：out_inp_3 
% 3.1 在[PUMPS]行中删除78、79、80
% 3.2 在[ENERGY]中删除79、79、80
% 3.3 在[PIPES]中增加一行连接源点40与节点20，
% “126  40  20  1   762 130 0”起始节点为40，终止节点为20，管长为1m，管径为762mm,粗糙系数为130，局部损失系数为0
% 4 无需修改
% 5 发现修改后出现一些问题，管网本身出现负压。即out_inp_3文件在标准EPANET 2应用中进行平差计算，应用给出警告信息，即出现负压。为了解决负压问题，对inp文件进行一些修改。
% 5.1 管道110、113、114、115、116、125管径太小为：0.002540mm，修改为203.2mm
% 5.2 源点水头为3.048m,太低，改为263.048m
