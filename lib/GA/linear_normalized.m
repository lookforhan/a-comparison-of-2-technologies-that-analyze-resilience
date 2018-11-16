%% 韩朝 hanzhao@emails.bjut.edu.cn
%% 2017-12-19
% 将适应度值线性化处理
%{
fitvalue={23;15;165;7}
a=100
b=2.5
 %}
function Fitvalue=linear_normalized(fitvalue,a,b)

n=numel(fitvalue);%适应度值个数（种群个数）
fitvalue1=fitvalue;%转化为矩阵，fitvalue第一列为个体对应的适应度值
order=[1:n]';%标记次序
% order=1:n;
try
fitvalue2=[fitvalue1,order];
catch
    keyboard
    fitvalue2=[fitvalue1',order];
end
fitvalue3=sortrows(fitvalue2,-1);%按照适应度值从大到小排列
Fitvalue1=zeros(n,1);
for i=1:n
    Fitvalue1(i,1)=max(a-b*i,1);
end
Fitvalue2=[Fitvalue1,fitvalue3];
Fitvalue3=sortrows(Fitvalue2,3);
Fitvalue=num2cell(Fitvalue3(:,1));
end