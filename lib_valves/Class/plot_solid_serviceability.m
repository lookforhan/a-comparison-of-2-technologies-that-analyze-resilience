classdef plot_solid_serviceability < handle
    % plot_solid_serviceability ���ƹ�����ˮ���������ߣ��Բ�ͬ��ɫ��ʾ�ɿ��̶ȡ�
    %   ����epanetx64pdd����ȱ�ݣ���ʱ���������õ�������ˮ�����ʲ��ɿ���
    %   p = plot_solid_serviceability(solid_code,value)
    %   f1 = figrue()
    %   p.plot(f1)
    
    properties
        Serviceability
        Calculate_code
        plt
    end
    properties (Dependent)
        %         code2
%         code3
        code4
        loc_solid
        loc_not_solid
        loc_all
    end
    methods
        function code4 = get.code4(obj)
            code2 = zeros(numel(obj.Calculate_code),1);
            code2(obj.Calculate_code~=0) = 1;
            code2 = [code2;1];
            code4 = code2(1:end-1)-code2(2:end);
        end
        function loc_all= get.loc_all(obj)
            loc1 = find(obj.code4==-1);
            loc2 = find(obj.code4 ==1);
            loc_all = unique([loc1;loc2]);
        end
        
        
    end
    methods
        function obj = plot_solid_serviceability(calculate_code,serviceability)
            %plot_solid_serviceability ��������ʵ��
            %   �˴���ʾ��ϸ˵��
            obj.Calculate_code = calculate_code;
            obj.Serviceability = serviceability;
            try
                a = [calculate_code,calculate_code];
            catch err_message
                rethrow(err_message)
            end
        end
        
        function plot(obj,figure_handle)
            %plot ��ͼ
            %   obj.plot(figure_handle)
            figure(figure_handle)
            hold on
            x2 = 1;
%             code4 = obj.code4;
            loc3 = obj.loc_all;
            for i = 1:numel(obj.loc_all)
                x1 = x2;
                x2 = loc3(i);
                if obj.code4(loc3(i))==-1
                    obj.plt(i) = plot((x1:x2),obj.Serviceability(x1:x2),'b');
                else
                    obj.plt(i) = plot((x1:x2),obj.Serviceability(x1:x2),'r');
                end
            end
        end
    end
end

