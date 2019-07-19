classdef CreatPDDNet < handle
    %CreatPDDNet 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        InputFile
    end
    properties
        lib_name = 'EPANETx64PDD';
        h_name = 'toolkit.h';
        root
        err
    end
    properties( Dependent)
        temp_rpt
    end
    methods
        function obj = CreatPDDNet(varargin)
            %CreatPDDNet 构造此类的实例
            %   此处显示详细说明
            if nargin == 0
                return
            else
                obj.InputFile = which(varargin{1});
            end
            obj.root = [fileparts(which('CreateDamageNet.m')),'\..\..\'];
            
        end
    end
    methods
        function addPDDParameter(obj,Node_index,Hcritical,Hminimum)
            obj.err.addPDDHminimum = calllib (obj.lib_name,'ENsetnodevalue',Node_index,120,Hminimum);
            obj.err.addPDDHcritical = calllib(obj.lib_name,'ENsetnodevalue',Node_index,121,Hcritical);
        end
        function openInp(obj)
            obj.err.openInp = calllib(obj.lib_name,'ENopen',obj.InputFile,obj.temp_rpt,'');
        end
        function closeInp(obj)
            obj.err.closeInp = calllib(obj.lib_name,'ENclose');
        end  
        function loadLibrary(obj)
            if libisloaded(obj.lib_name)
            else
                loadlibrary([obj.root,'materials\',obj.lib_name],[obj.root,'materials\',obj.h_name]);
            end
        end
        function unloadLibrary(obj)
            if libisloaded(obj.lib_name)
                unloadlibrary(obj.lib_name);
            end
        end
    end
    methods
         function temp_rpt = get.temp_rpt(obj)
            [filePath,fileName,~] = fileparts(obj.InputFile);
            temp_rpt = fullfile(filePath,[fileName,'.rpt']);
        end
    end
end

