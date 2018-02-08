classdef Cal < handle
    %Calcul Pressure and the the temperature compensation
%Example : 
%     -Creat a object  : s = Cal
%     -Calcul Pressure and temperature : s.Calcul

    properties (Access = private)
        filenamecoeff
        filenamedata
    end
    
    properties
        coeff
        datas
    end
    
    methods
        
        % constructor
        function obj = Cal(filenamecoeff, filenamedata, varargin)
            
            % select filenamecoeff
            if nargin < 1 || isempty(filenamecoeff)
                [filenamecoeff, pathName] = uigetfile('*.xml','Select file');
                if isnumeric(filenamecoeff)
                    if filenamecoeff == 0
                        error('readfile: fileNamecoeff');
                    end
                end
                obj.filenamecoeff = fullfile(pathName, filenamecoeff);
            else
                obj.filenamecoeff = filenamecoeff;
            end
            
            % select filenamecoeff
            if nargin < 1 || isempty(filenamedata)
                [filenamedata, pathName] = uigetfile('*.txt','Select file');
                if isnumeric(filenamedata)
                    if filenamedata == 0
                        error('readfile: fileNamedata');
                    end
                end
                obj.filenamedata = fullfile(pathName, filenamedata);
            else
                obj.filenamedata = filenamedata;
            end
            
            
        end % end of constructor
        
        %function read data all files
        function readdatafile(obj)
            
            %Read file datas
            filedatas = fopen(obj.filenamedata,'r');
            while ~feof(filedatas)
                data = fscanf(filedatas,'%f');
                key = {'prim_temp','prim_cond','pres','sec_temp',...
                    'sec_cond','v1','v2','v3','v4','v5','v6','v7',...
                    'v8','par','pt','count'};
                
                for i=1:16
                value(i) = data(i);
                end
                obj.datas = containers.Map(key, value);
                %disp(obj.data);
            end
            
            
            fclose(filedatas);
            %call function : Get coeff file xml 
            obj.coeff = readXmlFile(obj.filenamecoeff);
        end
        
        
        %function calcul_Pressure and temperature compensation
        
        %Pressure temperature compensation
        %Td = (M*N)-B
        
        %Calcul Pressure (psia)
        %C = C1 + C2*T + C3*T^2
        %D = D1 + D2*T
        %To = T1 + T2*T + T3*T^2 + T4*T^3
        %T = pressure period (microsec)
        %P = C(1-(To^2/T^2)(1-D(1-To^2/T^2))
        
        function Calcul(obj)
            %Call function read for get coeff and datas
            obj.readdatafile;
            
            %Pressure temperature compensation Td = (M*N)-B
            Td = (obj.coeff('AD590M')*obj.datas('pt'))-obj.coeff('AD590B');
            
%             disp(Td);
            
            %Calcul Pressure (psia)
            C = obj.coeff('C1') + obj.coeff('C2')*Td + obj.coeff('C3')*Td^2;
            D = obj.coeff('D1') + obj.coeff('D2')*Td;
            T = 1/obj.datas('pres')*10^(6);
            To = obj.coeff('T1') + obj.coeff('T2')*Td + obj.coeff('T3')*Td^2 + ...
                obj.coeff('T4')*Td^3 + obj.coeff('T5')*Td^4;

            Pressure = C*(1-(To^2/T^2))*(1-D*(1-(To^2/T^2)));
            disp(Pressure);
            
        end
    end
    
end
