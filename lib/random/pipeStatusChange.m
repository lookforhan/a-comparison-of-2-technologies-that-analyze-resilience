function [ newPipeStatusout,timeStep ] = pipeStatusChange( PipeStatus )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    [newPipeStatus_1,ia,ic]=unique(PipeStatus','rows');
    newPipeStatus_2=[ia,newPipeStatus_1];
    newPipeStatus_3=sortrows(newPipeStatus_2);
    newPipeStatus_4=newPipeStatus_3;
    newPipeStatus=newPipeStatus_4';
    timeStep = newPipeStatus(1,:);
    newPipeStatusout = newPipeStatus(2:end,:);
    if false
    filename=['damage_net_','_generation_','individual','_timeStep_'];
    dlmwrite([filename,'.txt'],newPipeStatus)
    xlswrite([filename,'.xls'],newPipeStatus)
    end
end

