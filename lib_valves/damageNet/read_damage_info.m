function [ t,damage_data ] = read_damage_info( input_damage_filename )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
disp('ND_Execut_deterministic:开始，读入破坏信息');
fid=fopen(input_damage_filename,'r');
if fid <0
    disp(['ND_Execut_deterministic:破坏信息文件出错',input_damage_filename]);
    t =1;
    damage_data = 0;
    return
end
damage_data=textscan(fid,'%f%s%f%f%f%f','delimiter','\t','headerlines',1);%读取管线震害修复率数据pipe_num*5: 第1列管段号(字符),2管长(km),3平均震害率(处/km),4管材(字符)
fclose(fid);
disp('ND_Execut_deterministic:开始，读入破坏信息结束');
t =0;
end

