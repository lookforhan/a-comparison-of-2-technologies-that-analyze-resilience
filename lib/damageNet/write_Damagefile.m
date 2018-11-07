function [ output_args ] = write_Damagefile( damageInfo, out_file )
%writer_Damagefile 此处显示有关此函数的摘要
%   此处显示详细说明
funcName = 'write_Damagefile';
fid = fopen(out_file,'w');
if fid <0
    output_args=1;
    disp('errors==================');
    disp([funcName,'errors','行5',"fid = fopen(out_file,'w');"])
    disp(out_file);
end

damage_n = sum(sum(damageInfo{1,3}~=0));% 破坏总数
data = cell(damage_n+1,6);
pipe_damage_n = sum(damageInfo{1,3}~=0,2);%每个管道上的破坏数
pipe_num = numel(damageInfo{1,1});
data{1,1} = '破坏编号';
data{1,2} = '所在管线编号';
data{1,3} = '该管线上破坏破坏次序';
data{1,4} = '破坏点与前点之间长度比例';
data{1,5} = '破坏类型';
data{1,6} = '渗漏面积等效直径（mm）';
damage_n_one = 1;
for i = 1:pipe_num
    for j = 1:pipe_damage_n(i)
        damage_n_one = damage_n_one+1;
        data{damage_n_one,1} = num2str(damage_n_one-1);%第一列：破坏编号
        data{damage_n_one,2} = damageInfo{1,5}{i};%第二列：管道id
        data{damage_n_one,3} = num2str(j);%第三列：管道上的破坏次序
        data{damage_n_one,4} = num2str(damageInfo{1,2}(i,j));%第四列：管道上的破坏点与之前破坏点的距离与整个管道长度的比例
        data{damage_n_one,5} = num2str(damageInfo{1,3}(i,j));%第五列：破坏类型：1泄露，2断开
        data{damage_n_one,6} = num2str(damageInfo{1,6}(i,j));%第五列：等效面积
    end
end 
for n = 1:(damage_n+1)
    fprintf(fid,'%s \t %s \t %s \t %s \t %s \t %s',data{n,:});
    fprintf(fid,'\r\n');
end
out_xlsfile = [out_file(1:end-3),'xls'];
xlswrite(out_xlsfile,data)
fclose(fid);
output_args=0;
end

