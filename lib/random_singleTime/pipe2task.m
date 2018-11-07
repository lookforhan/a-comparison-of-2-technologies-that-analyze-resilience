%% 画队伍工作甘特图
% 韩朝
% 2018-1-7
function task=pipe2task(BreakPipe_result)
n=numel(BreakPipe_result(:,1));%共有n行，就有2*n个任务
n2=2*n;%任务数目
task=cell(n2,5);
for i=1:n
    if i>n/2
        task_class=2;
    else
        task_class=1;
    end
    k=2*i-1;
    task{k,1}=BreakPipe_result{i,5};task{k,2}=0;task{k,3}=BreakPipe_result{i,2};task{k,4}=BreakPipe_result{i,3};task{k,5}='travel';
    task{k+1,1}=BreakPipe_result{i,5};task{k+1,2}=task_class;task{k+1,3}=BreakPipe_result{i,3};task{k+1,4}=BreakPipe_result{i,4};task{k+1,5}=BreakPipe_result{i,1};
end
end