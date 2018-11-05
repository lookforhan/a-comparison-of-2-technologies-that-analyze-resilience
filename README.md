# a-comparison-of-2-technologies-that-analyze-resilience

## 前言

本项目是为了对比供水管网韧性分析的两种技术方法。

方法1：采用epanet2.dll自带的延时分析方法，分析供水管网从破坏到修复时间内的供水能力曲线。

方法2：采用epanet2.dll自带的单时刻分析方法，人工确定分析时间步，分析供水管网从破坏到修复时间内的供水能力曲线。

## 理论与材料

本项目所采用的工具为**EPANETx64PDD.dll**、**toolkit.h**[@morley2008pressure]进行水力分析和pdd模型的水力计算。
