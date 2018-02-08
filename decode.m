classdef decode < handle
%     Classe for decode a data line and save the datas in file datas.txt
%     Example : 
%     Creat a object : s = decode
%     decode a line and save data : s.save('106B570ACF6883646910BA460A87706DEFFF882FFFFFFFFFFFFFFF000000719241')
%     File data.txt : 
%     3180.464844
% Freqs :       4203.339844
%               2767.406250
%               33636.410156
%               4282.273438
%               2695.437500
% Voltages :    2.853480
%               0.000000
%               2.340659
%               0.000000
%               0.000000
%               0.000000
%               0.000000
%               0.000000
%par :          0.000000
%temp_pressure: 1817.000000
%count :        65.000000
    
    %Number frequencies and number of voltages
    properties
        nFreq = 5      % default, 5 frequency
        nVolt = 8      % default, 8 Voltage channel
        
    end
    
    %Size all parameters
    properties (Access = private)
        sizeFreq = 6   % default, 6 bytes per hex freq
        sizeVolt = 3   % default, 3 bytes per hex volt
        sizePar = 3    % default, 3 bytes
        sizeP_t = 3    % default, 3 bytes
        sizeCount = 2  % default, 2 bytes
    end
    
    methods % public
        
        % constructor
        function obj = Decode(varargin)
            
            obj.nFreq = varargin{1};
            obj.nVolt = varargin{2};
            if (nargin > 2 )
                obj.sizeFreq = varargin{3};
                obj.sizeVolt = varargin{4};
                obj.sizePar = varargin{5};
                obj.sizeCount = varargin{6};
            end
            
        end
        
        %function save data in file
        function save(obj, trame)
            
            %Open file
            fID = fopen('datas.txt','w');
            
            %Structure call all extract function
            datas = {'frequencies','voltages','par','p_t','count'};
            
            funct = {obj.extractf(trame), obj.extractv(trame),...
                obj.extractpar(trame),obj.extractp_t(trame),...
                obj.extractcount(trame)};
            
            structure = struct('datas', datas, 'f_decode', funct);
            
            %writting datas in file
            for i = 1:5
                structure(i).datas = structure(i).f_decode;
                fprintf(fID,'%f\n',structure(i).datas);
            end
            
            %Close file
            fclose(fID);
            
        end
        
        %Function extraction datas from trame
        function frequencies = extractf(obj, trame)
            frequencies = ones(obj.nFreq, 1); 
            p = 1;
            for i = 1:1:obj.nFreq
                frequencies(i) = obj.decodef(p, trame);
                p = p + obj.sizeFreq;
                
            end
            
        end
        
        function voltages = extractv(obj, trame)
            voltages = ones(obj.nVolt, 1);
            p = 1 + obj.sizeFreq * obj.nFreq ;
            for i = 1:1:obj.nVolt
                voltages(i) = obj.decodev(p, trame);
                p = p + obj.sizeVolt;
            end
        end
        
        function surface_PAR = extractpar(obj, trame)
            p = 3 + obj.sizeFreq * obj.nFreq + obj.sizeVolt * obj.nVolt;
            surface_PAR = obj.decodepar(p, trame);
        end
        
        function Pressure_temp = extractp_t(obj, trame)
            p = 4 + obj.sizeFreq * obj.nFreq + obj.sizeVolt * obj.nVolt + ...
                obj.sizePar;
            Pressure_temp = obj.decodep_t(p, trame);
        end
        
        function count = extractcount(obj, trame)
            p = 4 + obj.sizeFreq * obj.nFreq + obj.sizeVolt * obj.nVolt + ...
                obj.sizePar + obj.sizeP_t;
            count = obj.decodecount(p, trame);
        end
        
        % end of extract
        
        
    end  % end of public methods
    
    %Function Calcul data : frequencies, voltage, PAR, Compensation temp, Count
    methods(Access = private)
        
        function frequencie = decodef(obj, p, trame)
            bytes = trame(p:p+obj.sizeFreq);
            theFreq = hex2dec([bytes(1:2);bytes(3:4);bytes(5:6)]);
            frequencie = theFreq(1)*256 + theFreq(2) + theFreq(3)/256;
        end
        
        function voltage = decodev(obj, p, trame)
            bytes = trame(p:p+obj.sizeVolt);
            theVolt = hex2dec(bytes(1:3));
            voltage = 5*(1-(theVolt/4095));
        end
        
        function PAR = decodepar(obj, p, trame)
            bytes = trame(p:p+obj.sizePar);
            thePar = hex2dec(bytes(2:4));
            PAR = thePar/819;
        end
        
        function Pressure_t = decodep_t(obj, p, trame)
            bytes = trame(p:p+obj.sizeP_t);
            Pressure_t = hex2dec(bytes(1:3));
            
        end
        
        function Count = decodecount(obj, p, trame)
            bytes = trame(p:p+obj.sizeCount);
            Count = hex2dec(bytes(2:3));
            
        end
    end %end of private methods
    
end % end of class