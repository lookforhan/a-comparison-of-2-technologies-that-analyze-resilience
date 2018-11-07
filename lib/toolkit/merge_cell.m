function [ output_args ] = merge_cell( input_args1,input_args2,input_args3 )
%merge_cell ����ͬά�ȵ�Ԫ��������кϲ���hanzhao
%   input_args1 ��һ��Ԫ������
%   input_args2 �ڶ���Ԫ������
%   input_args3 �ϲ��ķ���1Ϊ���з���ϲ���2Ϊ���кϲ�
%   output_args �����Ԫ������
%   ʾ��
%   A = {1;2} ; B = {4,5,6}
%   C = merge_cell(A,B,1)
%   C = {1,4,5,6;2,,,}
%   D = merge_cell(A,B,1)
%   D = {1,,;2,,;4,5,6}
[c1,r1] = size(input_args1);
[c2,r2] = size(input_args2);
if input_args3 == 1
    mid_1 = max(c1,c2);
    mid_1_cell = cell(mid_1 - c1,r1);
    mid_2_cell = cell(mid_1 - c2,r2);
    next_1 = [input_args1;mid_1_cell];
    next_2 = [input_args2;mid_2_cell];
    output_args = [next_1,next_2];
else
    mid_1 = max(r1,r2);
    mid_1_cell = cell(c1,mid_1 - r1);
    mid_2_cell = cell(c2,mid_1 - r2);
    next_1 = [input_args1,mid_1_cell];
    next_2 = [input_args2,mid_2_cell];
    output_args = [next_1;next_2];
    
end
end

