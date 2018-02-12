classdef ctd < us191.serial
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        trame
        fileName = 'test.hex'
        tempo = 0.5
    end
    
    properties (Access = private)
        listenerHandle % Property for listener handle
        fid
    end
    
    methods
        
        % constructor
        function obj = ctd(varargin)
            obj@us191.serial(varargin{:});
            obj.listenerHandle = addlistener(obj,'sentenceAvailable',@obj.handleEvnt);
        end
        
        % init send initialization commands to deck-unit SBE11
        function open(obj)
            open@us191.serial(obj)
            fprintf(obj.sp, 'R\n');      % Reset buffer
            pause(obj.tempo);
            fprintf(obj.sp, 'U\n');      % Reset words
            pause(obj.tempo);
            fprintf(obj.sp, 'A01\n');    % Scans average deckunit
            pause(obj.tempo);
            fprintf(obj.sp, 'X0\n');
            pause(obj.tempo);
            fprintf(obj.sp, 'X1\n');
            pause(obj.tempo);
            fprintf(obj.sp, 'X3\n');
            pause(obj.tempo);
            fprintf(obj.sp, 'X4\n');
            pause(obj.tempo);
            fprintf(obj.sp, 'X5\n');
            pause(obj.tempo);
            fprintf(obj.sp, 'X6\n');     % Suppress A/D word
            pause(obj.tempo);
            fprintf(obj.sp, 'X7\n');
            pause(obj.tempo);
            fprintf(obj.sp, 'X8\n');     % Suppress A/D word
            pause(obj.tempo);
            fprintf(obj.sp, 'addSPAR=N\n'); % Suppress SPAR word
            pause(obj.tempo);
            %             fprintf(obj.sp, 'DS\n');
            %             pause(1);
            obj.fid = fopen(obj.fileName, 'wt');
            fprintf(obj.sp, 'GR\n');
            % pause(obj.tempo);
            
        end
        
        % call when data available on serial port
        function handleEvnt(obj,~,~)
            fprintf(1, '%s\n', obj.sentence);
            fprintf(obj.fid, '%s\n', obj.sentence);
        end % end of function handleEvnt
        
        function close(obj)
            fprintf(obj.sp, 'S\n');      % stop deck-unit acquisition
            pause(obj.tempo);
            fprintf(obj.sp, 'R\n');      % Reset buffer
            pause(obj.tempo);
            fclose(obj.fid);        %Close file
            delete(obj.listenerHandle);
            close@us191.serial(obj);
        end % end of close
        
    end  % end of public methods
    
end % end of ctd class

