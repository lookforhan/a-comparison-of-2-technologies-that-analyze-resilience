% generate EPA_format
function t=formatFile2Mat(EPA_format_file,EPA_format_mat)
fid2=fopen(EPA_format_file,'r'); %打开EPA水力模型文件的数据存储格式参数；
if fid2<0
    t = 1;
    return
end
EPA_format=textscan(fid2,'%q%q%s','delimiter','|');%读取inp文件中的关键词及数据存储类型格式的文件；
fclose(fid2);
save( EPA_format_mat ,'EPA_format')
t = 0;
end