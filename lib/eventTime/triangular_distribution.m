%% 2017-12-12
%% ���� hanzhao@emails.bjut.edu.cn
%% ���ɷ������Ƿֲ������
%% ����
% a;��Сֵ
% b;���ֵ
% c;����
%% ���
% num_rnd;�����
function num=triangular_distribution(a,b,c)
y = rand(1,1);%�����������0��1�����ȷֲ������
if y<=((c-a)/(b-a))
    x=a+sqrt(y*(b-a)*(c-a));
else
    x=b-sqrt((b-a)*(b-c)*(1-y));
end
num=x;

end