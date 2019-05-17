classdef CreateDamageNet < handle
    %CreateDamageNet 生成破坏管网inp文件
    %   此处显示详细说明
    
    properties % input
        net_inp
        damage_txt
    end
    properties (SetAccess = private, GetAccess = private, Dependent)
        check_net_inp
        check_damage_txt
        temp_dll_inp
        temp_dll_rpt
        temp_rpt
        net_data
        damage_info
        epa_inp_format
    end
    properties
        root = 'C:\Users\hc042\Documents\GitHub\a-comparison-of-2-technologies-that-analyze-resilience\';
        lib_name = 'EPANETx64PDD';
        h_name = 'toolkit.h';
        err
        damage_net
    end
    methods
        function check_net_inp = get.check_net_inp(obj)
            fileType = textscan(obj.net_inp,'%s','delimiter','.');
            fileType = fileType(end);
            if strcmpi(fileType,'inp')
                check_net_inp = 0;
            else
                check_net_inp = 1;
            end
        end
        function check_damage_txt = get.check_damage_txt(obj)
            fileType = textscan(obj.damage_txt,'%s','delimiter','.');
            fileType = fileType(end);
            if strcmpi(fileType,'inp')
                check_damage_txt = 0;
            else
                check_damage_txt = 1;
            end
        end
        function temp_dll_inp = get.temp_dll_inp(obj)
            [filePath,fileName,ext] = fileparts(obj.net_inp);
            temp_dll_inp = fullfile(filePath,['temp-',fileName,ext]);
        end
        function temp_dll_rpt = get.temp_dll_rpt(obj)
            [filePath,fileName,~] = fileparts(obj.temp_dll_inp);
            temp_dll_rpt = fullfile(filePath,[fileName,'.rpt']);
        end
        function temp_rpt = get.temp_rpt(obj)
            [filePath,fileName,~] = fileparts(obj.net_inp);
            temp_rpt = fullfile(filePath,[fileName,'.rpt']);
        end
        function net_data = get.net_data(obj)
            obj.loadLibrary;
            obj.err.openNet=calllib(obj.lib_name,'ENopen',obj.net_inp,obj.temp_rpt,'');% 打开管网数据文件
            if code==0%判断Read_File读取input_net_filename文件数据是否成功
                obj.err.saveinpfile = calllib(obj.lib_name,'ENsaveinpfile',obj.temp_dll_inp);
                obj.err.closeNet = calllib(obj.lib_name,'ENclose'); %关闭计算
                [obj.err.readNet,net_data]=Read_File_dll_inp4(obj.temp_dll_inp,obj.epa_inp_format);%读取水力模型inp文件的数据；
                if obj.err.readNet ~=0
                    disp([funcName,'读取错误：',obj.temp_dll_inp])
                    keyboard
                end
            else
                obj.err.closeNet = calllib(obj.lib_name,'ENclose'); %关闭计算
                net_data=0;
                return
            end
            obj.unloadLibrary;
        end
        function damage_info = get.damage_info(obj)
            [ obj.err.readDamageInfo,damage_data ] = read_damage_info( obj.damage_txt );% from 'damageNet\'
            [obj.err.changeDamgeInfo,damage_info] = ND_Execut_deterministic1(obj.net_data,damage_data);% from 'damageNet\'
        end
        function epa_inp_format = get.epa_inp_format(obj)
            load([obj.root,'lib\readNet\EPA_F.mat']);
            epa_inp_format = EPA_format;
        end
    end
    
    methods
        function obj = CreateDamageNet(inputArg1,inputArg2)
            %CreateDamageNet 构造此类的实例
            %   inputArg1:管网inp文件，后缀为.inp;为动态链接库生成的标准文件
            %   inputArg2:破坏信息文件，后缀为.txt
            obj.net_inp = inputArg1;
            obj.damage_txt = inputArg2;
            if obj.check_damage_txt ~= 0
                disp([inputArg2,':error']);
            end
            if obj.check_net_inp ~= 0
                disp([inputArg1,':error']);
            end
            obj.addLibPath;
        end
        function loadLibrary(obj)
            if libisloaded(obj.lib_name)
            else
                loadlibrary([obj.root,'materials\',obj.lib_name],[obj.root,'materials\',obj.h_name]);
            end
        end
        function addLibPath(obj)
            addpath([obj.root,'lib\readNet']);
            addpath([obj.root,'lib\damageNet']);
        end
        function unloadLibrary(obj)
            if libisloaded(obj.lib_name)
                unloadlibrary(obj.lib_name);
            end
        end
        function delete_tempFile(obj)
            delete (obj.temp_dll_inp,obj.temp_dll_rpt,obj.temp_rpt);
        end
        function outputArg = Run(obj)
            %METHOD1 此处显示有关此方法的摘要
            %   此处显示详细说明
            [obj.err.damageFile,pipe_relative] = damageNetInp2_GIRAFFE2(obj.net_data,obj.damage_info,obj.epa_inp_format,obj.damage_net);% from 'damageNet\'
            outputArg = pipe_relative;
        end
        function export(obj,out_file)
            obj.damage_net = out_file;
        end
    end
end

