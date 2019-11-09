% 工况1-5的收敛图
% genetic_algorithm_convergence.m
clear;clc;close all;tic;
% load('damage_scenario_case_01NEW.mat')
load('damage_scenario_case_09_new_100.mat')
% load('damage_scenario_case_05relay50.mat')
generation_lenght = 100;
% fitValue = reshape(ga_results.recovery_fit_record,300,100);
try
ga_results.replacement_fit_record = ga_results.recovery_fit_record;
catch
end
fit_all = ga_results.replacement_fit_record;
fitValue = reshape(fit_all,300,generation_lenght);
fitValue_max = max(fitValue)';
fitValue_mean = mean(fitValue)';
fitValue_min = min(fitValue)';
generation = (1:generation_lenght)';
anss = [generation,fitValue_max,fitValue_mean,fitValue_min];
fit_min = min(fitValue_min);
fit_max = max(fitValue_max);
rate = (fit_max-fit_min)/fit_min
f = figure;
p1 = plot(fitValue_max);
hold on
p2 = plot(fitValue_mean);
p3 = plot(fitValue_min);