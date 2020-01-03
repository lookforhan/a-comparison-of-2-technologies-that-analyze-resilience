function [t, net_data ] = read_net( input_net_filename,EPA_format)
%read_net 读入inp文件中的数据
%   该函数需调用Read_File_dll_inp4.m；epanet2.dll；epanet2.h；EPA_F.mat等文件
%   输入inp文件地址
%   输出inp文件内容,输出为元胞数组。
%   2018-8-1修改：增加line20-34.解决[PATTERNS]中可能出现的[NaN]问题。该问题出现，当管网为延时模拟，且模式数非6的倍数。
%%
funcName = 'read_net';
disp([funcName,'开始读取：',input_net_filename]);
Before_Earthq_rpt='read_net_Before_Earthq.rpt';
Before_Earthq_out='read_net_Before_Earthq.out';
internal_inpfile='read_net_internal.inp';
% loadlibrary('epanet2.dll','epanet2.h'); %加载EPA动态链接库
code=calllib('epanet2','ENopen',input_net_filename,Before_Earthq_rpt,Before_Earthq_out);% 打开管网数据文件
if code==0%判断Read_File读取input_net_filename文件数据是否成功
    calllib('epanet2','ENsaveinpfile',internal_inpfile);
    [t,net_data]=Read_File_dll_inp4(internal_inpfile,EPA_format);%读取水力模型inp文件的数据；
   if t ~=0
       disp([funcName,'读取错误：',input_net_filename])
       keyboard
   end
    disp([funcName,'读取完成：',input_net_filename]);
    %========================================
    calllib('epanet2','ENclose'); %关闭计算
%     unloadlibrary epanet2;%卸载epanet2.dll
else
    disp('errors==================');
    disp('read_net.m');
    disp(['读入net.inp文件出错！错误代码',num2str(code)]);
    calllib('epanet2','ENreport'); %输出计算报告
    calllib('epanet2','ENclose'); %关闭计算
%     unloadlibrary epanet2;%卸载epanet2.dll
    net_data=0;
    t=1;
    return
end
delete(Before_Earthq_rpt);
% delete(Before_Earthq_out);
% delete(internal_inpfile);
t=0;
end

