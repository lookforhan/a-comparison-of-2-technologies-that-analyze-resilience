
%% 1.�������Ĺ���Ϊ������Ӧ��inp����ʽ���ı��ļ���
% ��ʽ�ɲ���p_data����
%% 2.���˼·�������ص㣻
%% 3.�����д�ˣ��޸�ʱ�䣺�������ݣ�
% ������2017-5-13 19��43�������ļ�ͷ��˵����
% ������2017-6-2 9��43�������ļ�ͷ��˵�����м����˵������������ļ���
% ������2017-6-5 9��43��ȡ������ȫ�ֱ���������������ļ����룻
% ������2017-6-6 9��43��ÿ������ע�ͣ�
% ������2017-6-6 21��43��ɾ��RF_size��RF_read������ԭ��������ת����Read_File����
% ������2017-6-6 21��43��ɾ��data2������
% ������2017-6-6 21��43�������ļ����������ݸ�ʽ��
% ������2017-07-26 11:01:54��Ϊ��Ӧmain12,epanet2.dll���ˮ��ģ���ļ���ʽ��96��textscan�����ļ��ļ������ԭ'/t'��ΪĬ�ϣ�
% �ΰ��2018-07-23 15:53�������˹ؼ��ʷ���'['�м���ں��ո�Ŀ��У�empty_line_count���Ĵ�����䣻
%% 4.����������Ҫ���õ������Աࣨ�Զ��壩���򣨺��������ļ�
%% 4.1 ����
% [1]findmatch
%% 4.2 �ļ�

%% 5.���ô˳��򣨺������ĳ���
% [1]main_s.m
%% 6.���������ƣ��������ͣ�ÿ�У��У����ݵĺ��弰��λ�������������Դ������ֵ�������ļ����룬�����������򣨺�����¼�룻
%% 6.1�������
% [1]input_filename,char,�����ļ���ַ
% [2]p_data,cell,�����ļ����������ͼ��洢��ʽ
% % p_data{1,1}��������
% % p_data{1,2},������ʽ
%% 6.2�������
% [1]t,double,t=0��ʾ���������޴���
% [2]data,cell,input_net_filename,�ļ�����
% % data��1��Ϊ��������
% % data��2��Ϊ��������
%% 6.3�м����
% [1]input_filename,char,�����ļ���ַ,input_filename��ֵ
% [2]keyword,cell,��������,p_data����ֵ
% [3]format_data,cell,���ݴ洢��ʽ,p_data����ֵ
% [4]keyword_num,����������Ŀ��size(keyword)��ֵ
% [5]lines_num,double,ĳһ�����������ļ��е�������,����ֵ
% [6]lines_end,double,ĳһ�����������ļ��еĽ����к�,����ֵ
% [7]fid,double,�ļ��ľ������,fopen������ֵ
% [8]fid1,double,�ļ��ľ������,fopen������ֵ
% [9]lines_num,double,����,����ֵ
% [10]str1,char,fgetl���ļ��ж���һ������,fgetl��ֵ
% [11]str2,char,���ݵ�uint8��ʽ,����ֵ
% [12]newsect,double,�������ͱ�־,����ֵ
% [13]sect,double,�������ͱ�־,����ֵ
% [14]data_size,double,�����ļ�һЩ����,����ֵ
% % ��1�У�ĳһ�����������ļ��е�������
% % ��2�У�ĳһ�����������ļ��еĽ����к�
% % ��3�У�ĳһ�����������ļ��еĿ�ʼ�к�
% [15]m,double,����,size��ֵ,����ֵ
% [16]data_origin,cell,��������,����ֵ
% [17]data,cell,�ļ��е��������ͼ���������,����ֵ
function [t,data]=Read_Inpfile6(input_filename,EPA_format)
%% ��ȡ�ؼ��ʲ�ȷ���ؼ��ʵ�����
keyword=EPA_format{1};%
format_data=[EPA_format{2},EPA_format{4}];%
keyword_num=numel(keyword(:,1));%
kw_data_lines_num=zeros(keyword_num,1);%ĳ�ؼ����������������ļ��е���������
kw_data_lines_st=zeros(keyword_num,1);%ĳ�ؼ����������������ļ��еĿ�ʼ�к�
kw_data_lines_end=zeros(keyword_num,1);%ĳ�ؼ����������������ļ��еĽ����к�
%% ���ҹؼ����ڵ��кţ�ÿ���ؼ����������������,������ʼ�к�,���ݽ����кţ�
lines_count=0;%�ļ��������кż�����
empty_line_count=0; %�����ؼ���('[')֮��Ŀ�����������
title_line_count=0; %ĳ���ؼ���('[')֮������Ա����м�����
fid=fopen(input_filename);
sect=-1;
while ~feof(fid)
    str1=fgetl(fid);    
    lines_count=lines_count+1;
    if isempty(str1) %����Ϊ�մ������Ϊ�գ��������� ��        
        if sect>0
            empty_line_count=empty_line_count+1;
        end
        continue; %���ļ��е���һ��
    end
%     if sum(isspace(str1(1:2)))>1 %������ڿո��ַ��������Ϊ�գ��������У�
%         if sect>0
%             empty_line_count=empty_line_count+1;
%         end
%         continue; %���ļ��е���һ��
%     end
    if str1(1)==';' %�����һ�ַ�Ϊ��;������ʾ����Ϊĳ�ؼ����µ����������� ;
        if sect>0
            title_line_count=title_line_count+1;
        end
        continue; %���ļ��е���һ�У�
    end
    if str1(1)=='[' %�����һ�ַ�Ϊ��[������ʾ�½ڿ�ʼ��
        str2=deblank(str1);%ȥ��ĩβ�ո�
        newsect=findmatch(str2,keyword,5);%newsectΪ��ǰ�а����ڼ����ؼ��ʵ������ţ�
        sect=-1; %��ǰ���Ƿ�����ؼ��ʵ��б������
        if newsect>0 %��ʾ��������ƥ��Ĺؼ��֣�
            sect=newsect;
            lines_st=lines_count;
            empty_line_count=0;
            title_line_count=0;
            continue; %���ļ��е���һ�У�
        end
    end
    if sect>0
        kw_data_lines_st(sect)=lines_st+title_line_count;
        kw_data_lines_end(sect)=lines_count-empty_line_count;
    end  
end
fclose(fid);
kw_data_lines_num=kw_data_lines_end-kw_data_lines_st;
data_size=[kw_data_lines_num,kw_data_lines_end,kw_data_lines_st];%ÿ���ؼ��ʶ�Ӧ�������������ݽ����кţ����ݿ�ʼ�кţ�
%% ��ȡ�ļ�����
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