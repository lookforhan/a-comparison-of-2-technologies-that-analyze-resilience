%% ���� hanzhao@emails.bjut.edu.cn
%% 2017-12-19
% ����Ӧ��ֵ���Ի�����
%{
fitvalue={23;15;165;7}
a=100
b=2.5
 %}
function Fitvalue=linear_normalized(fitvalue,a,b)

n=numel(fitvalue);%��Ӧ��ֵ��������Ⱥ������
fitvalue1=fitvalue;%ת��Ϊ����fitvalue��һ��Ϊ�����Ӧ����Ӧ��ֵ
order=[1:n]';%��Ǵ���
% order=1:n;
try
fitvalue2=[fitvalue1,order];
catch
    keyboard
    fitvalue2=[fitvalue1',order];
end
fitvalue3=sortrows(fitvalue2,-1);%������Ӧ��ֵ�Ӵ�С����
Fitvalue1=zeros(n,1);
for i=1:n
    Fitvalue1(i,1)=max(a-b*i,1);
end
Fitvalue2=[Fitvalue1,fitvalue3];
Fitvalue3=sortrows(Fitvalue2,3);
Fitvalue=num2cell(Fitvalue3(:,1));
end