% generate EPA_format
function t=formatFile2Mat(EPA_format_file,EPA_format_mat)
fid2=fopen(EPA_format_file,'r'); %��EPAˮ��ģ���ļ������ݴ洢��ʽ������
if fid2<0
    t = 1;
    return
end
EPA_format=textscan(fid2,'%q%q%s','delimiter','|');%��ȡinp�ļ��еĹؼ��ʼ����ݴ洢���͸�ʽ���ļ���
fclose(fid2);
save( EPA_format_mat ,'EPA_format')
t = 0;
end