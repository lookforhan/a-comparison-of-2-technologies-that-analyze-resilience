classdef CreateDamageNet < handle
    %CreateDamageNet �����ƻ�����inp�ļ�
    %   �˴���ʾ��ϸ˵��
    % t = CreateDamageNet('net.inp','damage.txt')
    % r.root = 'lib\';
    % t.Run
    % t.export('damage_net.inp')
    
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
    end
    properties
        net_data
        damage_info
        epa_inp_format
    end
    properties
        root = 'C:\Users\hc042\Documents\GitHub\a-comparison-of-2-technologies-that-analyze-resilience\';
        lib_name = 'EPANETx64PDD';
        h_name = 'toolkit.h';
        err
        pipe_relative
        write_data
    end
    properties ( Dependent)
        check_err
    end
    methods
        function check_net_inp = get.check_net_inp(obj)
            [~,~,fileType] = fileparts(obj.net_inp);
            if strcmpi(fileType,'.inp')
                check_net_inp = 0;
            else
                check_net_inp = 1;
            end
        end
        function check_damage_txt = get.check_damage_txt(obj)
            [~,~,fileType] = fileparts(obj.damage_txt);
            
            if strcmpi(fileType,'.txt')
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
        function check_err = get.check_err(obj)
            error = cell2mat(struct2cell(obj.err));
            check_err = any(error);
            if check_err
                keyboard
            end
        end
    end
    
    methods
        function obj = CreateDamageNet(inputArg1,inputArg2)
            %CreateDamageNet ��������ʵ��
            %   inputArg1:����inp�ļ�����׺Ϊ.inp;Ϊ��̬���ӿ����ɵı�׼�ļ�
            %   inputArg2:�ƻ���Ϣ�ļ�����׺Ϊ.txt
            obj.net_inp = inputArg1;
            obj.damage_txt = inputArg2;
            if obj.check_damage_txt ~= 0
                disp([inputArg2,':error']);
            end
            if obj.check_net_inp ~= 0
                disp([inputArg1,':error']);
            end
            obj.addLibPath;
            obj.get_epa_inp_format;
            obj.get_net_data;
            obj.get_damage_info;
            obj.delete_tempFile;
        end
        function get_net_data(obj)
            obj.loadLibrary;
            obj.err.openNet=calllib(obj.lib_name,'ENopen',obj.net_inp,obj.temp_rpt,'');% �򿪹��������ļ�
            if obj.err.openNet==0%�ж�Read_File��ȡinput_net_filename�ļ������Ƿ�ɹ�
                obj.err.saveinpfile = calllib(obj.lib_name,'ENsaveinpfile',obj.temp_dll_inp);
                obj.err.closeNet = calllib(obj.lib_name,'ENclose'); %�رռ���
                [obj.err.readNet,obj.net_data]=Read_File_dll_inp4(obj.temp_dll_inp,obj.epa_inp_format);%��ȡˮ��ģ��inp�ļ������ݣ�
                if obj.err.readNet ~=0
                    disp([funcName,'��ȡ����',obj.temp_dll_inp])
                    keyboard
                end
            else
                obj.err.closeNet = calllib(obj.lib_name,'ENclose'); %�رռ���
                obj.net_data=0;
                return
            end
            obj.unloadLibrary;
        end
        function  get_damage_info(obj)
            [ obj.err.readDamageInfo,damage_data ] = read_damage_info( obj.damage_txt );% from 'damageNet\'
            [obj.err.changeDamgeInfo,obj.damage_info] = ND_Execut_deterministic1(obj.net_data,damage_data);% from 'damageNet\'
        end
        function get_epa_inp_format(obj)
            load([obj.root,'lib\readNet\EPA_F.mat']);
            obj.epa_inp_format = EPA_format;
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
            if isfile(obj.temp_dll_inp)
                delete (obj.temp_dll_inp);
            end
            if isfile(obj.temp_rpt)
                delete (obj.temp_rpt);
            end
        end
        function Run(obj)
            %METHOD1 �˴���ʾ�йش˷�����ժҪ
            %   �˴���ʾ��ϸ˵��
            [obj.err.ND_j,damage_node_data]=ND_Junction5(obj.net_data,obj.damage_info);%���ɹ����е��ƻ�������
            [obj.err.ND_p,pipe_new_add,obj.pipe_relative]=ND_Pipe5(damage_node_data,obj.damage_info,obj.net_data{5,2});%���ɹ����ƻ�����ڽӹܶ�����
            [obj.err.ND_g,all_add_node_data,pipe_new_add]=ND_P_Leak4_GIRAFFE2_R(damage_node_data,obj.damage_info,pipe_new_add);
            pipe_data=obj.net_data{5,2}; %cell,��ʼ�����й��ߵ�������Ϣ�����߱��(�ַ���),�����(�ַ���),�յ���(�ַ���),���߳���(m),�ܶ�ֱ��(mm),�س�ˮͷ��ʧĦ��ϵ��,�ֲ�ˮͷ��ʧĦ��ϵ��;
            for i = 1:numel(obj.damage_info{1,1}) 
                    pipe_data{obj.damage_info{1,1}(i),8}='Closed;' ;
            end
            mid_data=(struct2cell(pipe_new_add))';
            all_pipe_data=[pipe_data;mid_data];%cell,��ʼ�����й���+�ƻ����ߵ�������Ϣ�����߱��(�ַ���),�����(�ַ���),�յ���(�ַ���),���߳���(m),�ܶ�ֱ��(mm),�س�ˮͷ��ʧĦ��ϵ��,�ֲ�ˮͷ��ʧĦ��ϵ��;
            all_node_coordinate=[obj.net_data{23,2};all_add_node_data(:,1:3)]; %���нڵ����꣨����ˮԴ��ˮ�ء��û��ڵ㣩��
            [~,outdata]=ND_Out_no_delete(all_pipe_data,all_add_node_data,all_node_coordinate,obj.net_data);
            obj.write_data = outdata; % ��������ݸ�ʽ ��ʱ����Ҫ��һ���Ż�
            %             [obj.err.damageFile,obj.pipe_relative] = damageNetInp2_GIRAFFE2(obj.net_data,obj.damage_info,obj.epa_inp_format,obj.damage_net);% from 'damageNet\'
        end
        function export(obj,out_file)
            obj.err.write=Write_Inpfile5(obj.net_data,obj.epa_inp_format,obj.write_data,out_file);% д���¹���inp
        end
    end
end

