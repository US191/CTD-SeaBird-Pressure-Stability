classdef ctd < us191.serial
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        trame
        file_t_name
    end
    
    properties (Access = private)
        listenerHandle % Property for listener handle
    end
    
    methods
        
        function obj = ctd(varargin)
            obj@us191.serial(varargin{:});
            obj.listenerHandle = addlistener(obj,'sentenceAvailable',@obj.handleEvnt);
        end
        
        function commands(obj)
            obj.open()
            fprintf(obj,'CRL%s', 'R');      % Reset buffer
            fprintf(obj,'CRL%s', 'A01');    % Scans average deckunit
            fprintf(obj,'CRL%s', 'X0');     % Suppress data word null
            fprintf(obj,'CRL%s', 'NY');     % Add Lat/Long
            fprintf(obj,'CRL%s', 'GR');     % Put data into RS232
            pause(1)                        % Wait one second
            
        end

        function save(obj)
            obj.trame = textscan(obj.sentence, '%s');   %Get trame of serial port
            fopen(obj.file_t_name,'w');                 %Open file for writing
            fwrite(obj.file_t_name,obj.trame);          %Save trame in file
        end

        function close(obj)
            
            fprintf(obj,'CRL%s', 'S');      %deckunit stop putting datas
            fclose(obj.file_t_name);        %Close file
            delete(obj.listenerHandle);     
            close@us191.serial(obj);
            
        end
        
    end
    
end

