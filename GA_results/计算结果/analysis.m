% clear;clc;clear all;tic;

net_file = 'E:\hanzhao\a-comparison-of-2-technologies-that-analyze-resilience\\materials\MOD\MOD_5_mean.inp';
damage_info_file = 'damage_scenario_case_07.txt';
out_dir = '.\results\';
inputArg2 = damage_info_file;
% load('damage_scenario_case_09relay50_50.mat')
load('damage_scenario_case_07.mat')
% ga_results.best_indivi_recovery = ga_results.best_indivi_replacement;
inputArg4 = ga_results.best_indivi_isolation;
inputArg5 = ga_results.best_indivi_recovery;
% ENnum = sum(sum(ga_results.isolation_fit_record+ga_results.replacement_ENrun_num))
% indivi_num = sum(sum((ga_results.isolation_ENrun_num~=0)+(ga_results.recovery_ENrun_num~=0)))
% ENnum = sum(sum(ga_results.isolation_ENrun_num+ga_results.recovery_ENrun_num))
% addpath('E:\hanzhao\a-comparison-of-2-technologies-that-analyze-resilience\lib')
% addpath('E:\hanzhao\a-comparison-of-2-technologies-that-analyze-resilience\lib\Class')
% addpath('E:\hanzhao\a-comparison-of-2-technologies-that-analyze-resilience\lib\readNet')
% addpath('E:\hanzhao\a-comparison-of-2-technologies-that-analyze-resilience\lib\toolkit')
% addpath('E:\hanzhao\a-comparison-of-2-technologies-that-analyze-resilience\lib\getValue')
% addpath('E:\hanzhao\a-comparison-of-2-technologies-that-analyze-resilience\lib\GA')

lib_name = 'EPANETx64PDD';
h_name = 'toolkit.h';
% loadlibrary(['..\materials\',lib_name],['..\materials\',h_name]);
[outputArg1] = resilienceAnalysis(net_file,inputArg2,out_dir,inputArg4,inputArg5);
outputArg1.serviceability
outputArg1.resilience_mean_serviceability