classdef decode < handle
%     Classe for decode a data line and save the datas in file datas.txt
%     Example : 
%     Creat a object : s = decode
%     decode a line and save data : s.save('106B570ACF6883646910BA460A87706DEFFF882FFFFFFFFFFFFFFF000000719241')
%     File data.txt : 
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
        nFreq       % default, 5 frequency
        nVolt       % default, 8 Voltage channel
        filename
        
    end
    
    %Size all parameters
    properties (Access = private)
        sizeFreq = 6   % default, 6 bytes per hex freq
        sizeVolt = 3   % default, 3 bytes per hex volt
        sizePar = 3    % default, 3 bytes
        sizeP_t = 3    % default, 3 bytes
        sizeCount = 2  % default, 2 bytes
        fID
    end
    
    methods % public
        
        % constructor
        function obj = decode(varargin)
            %Init number of voltages and frequencies
            obj.nFreq = 5;
            obj.nVolt = 8;
            obj.filename = 'data.txt';
            %Open file
            obj.fID = fopen(obj.filename,'w');
            
        end
        
        %function save data in file
        function save(obj, trame)
            
            %Structure call all extract function
            datas = {'frequencies','voltages','par','p_t','count'};

            funct = {obj.extractFreq(trame),obj.extractVolt(trame) ,...
                obj.extractPar(trame),obj.extractP_temp(trame),...
                obj.extractCount(trame)};
            
            structure = struct('datas', datas, 'f_decode', funct);
            
            %writting datas in file
            for i = 1 : 5
                structure(i).datas = structure(i).f_decode;
                
            end
            fprintf(obj.fID,'%f\n%f\n%f\n%f\n%f\n%f',...
                structure(1).datas,structure(2).datas, structure(3).datas,...
                structure(4).datas,structure(5).datas);
            
            %Close file
            fclose(obj.fID);
            %disp(structure(1).datas );
            
            
        end
        
        %Function extraction datas from trame
        function frequencies = extractFreq(obj, trame)
            frequencies = ones(obj.nFreq, 1); 
            p = 1;
            for i = 1:1:obj.nFreq
                frequencies(i) = obj.decodeFreq(p, trame);
                p = p + obj.sizeFreq;
                
            end
            disp(frequencies(3));
            
        end
        
        function voltages = extractVolt(obj, trame)
            voltages = ones(obj.nVolt, 1);
            p = 1 + obj.sizeFreq * obj.nFreq ;
            for i = 1:1:obj.nVolt
                voltages(i) = obj.decodeVolt(p, trame);
                p = p + obj.sizeVolt;
            end
        end
        
        function surface_PAR = extractPar(obj, trame)
            p = 3 + obj.sizeFreq * obj.nFreq + obj.sizeVolt * obj.nVolt;
            surface_PAR = obj.decodePar(p, trame);
        end
        
        function Pressure_temp = extractP_temp(obj, trame)
            p = 8 + obj.sizeFreq * obj.nFreq + obj.sizeVolt * obj.nVolt + ...
                obj.sizePar;
            Pressure_temp = obj.decodeP_temp(p, trame);
        end
        
        function count = extractCount(obj, trame)
            p = 4 + obj.sizeFreq * obj.nFreq + obj.sizeVolt * obj.nVolt + ...
                obj.sizePar + obj.sizeP_t;
            count = obj.decodeCount(p, trame);
        end
        
        % end of extract
        
        
    end  % end of public methods
    
    %Function Calcul data : frequencies, voltage, PAR, Compensation temp, Count
    methods(Access = private)
        
        function frequencie = decodeFreq(obj, p, trame)
            bytes = trame(p:p+obj.sizeFreq);
            frequencie = hex2dec([bytes(1:2);bytes(3:4);bytes(5:6)]);
            frequencie = frequencie(1)*256 + frequencie(2) + frequencie(3)/256;
%             disp(frequencie);

        end
        
        function voltage = decodeVolt(obj, p, trame)
            bytes = trame(p:p+obj.sizeVolt);
            voltage = hex2dec(bytes(1:3));
            voltage = 5*(1-(voltage/4095));
        end
        
        function PAR = decodePar(obj, p, trame)
            bytes = trame(p:p+obj.sizePar);
            PAR = hex2dec(bytes(2:4));
            PAR = PAR/819;
        end
        
        function Pressure_t = decodeP_temp(obj, p, trame)
            bytes = trame(p:p+obj.sizeP_t);
            Pressure_t = hex2dec(bytes(1:3));
%             disp(bytes(1:3));
        end
        
        function Count = decodeCount(obj, p, trame)
            bytes = trame(p:p+obj.sizeCount);
            Count = hex2dec(bytes(2:3));
            
        end
    end %end of private methods
    
end % end of class