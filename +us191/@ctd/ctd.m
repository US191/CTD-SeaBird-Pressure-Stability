classdef ctd < us191.serial & decode & compute
    %CTD collect and compute in real time pressure from deck-unit SBE11+
    % connected with a serial RS232 port
    %
    % usage:
    % s = us191.ctd('1263.xml','COM9','baudrate',19200,'terminator','CR/LF')
    % s.open
    % s.close
    % s =
    %   Port:       'COM9'
    %   BaudRate:   19200
    %   DataBits:   8
    %   StopBits:   1
    %   Parity:     'none'
    %   Terminator: 'CR/LF'
    %   Status:     'not connected'
    %   Echo:       'false'
    %
    %   Raw file:   'test.hex'
    %   Data file:  'test.cnv'
    %   Delay:       0.5
    %
    % change COM port:
    % s.setPort('COM10')
    %
    
    properties (Access = public)
        % TODOS, create filenames from dateTime
        rawFileName  = 'test.hex'  % by default
        dataFileName = 'test.cnv'
        delay = 0.5
        pressure
        modulo
        echo = false
    end
    
    properties (Access = private)
        listenerHandle % Property for listener handle
        rawFid                  % raw hex file descriptor
        dataFid                 % processed file descriptor
        initSbe11 = {...
            'U',...               % reset words
            'A01',...             % scans average deckunit
            'X0',...              % remove word Xn
            'X1','X3','X4','X5','X6','X7','X8',...
            'addSPAR=N'}          % remove SPAR
        startSbe11 = {...
            'R',...               % reset buffer
            'GR'};      % start acquisition
        stopSbe11 = { ...
            'S',...               % stop acquisition
            'R'}                  % reset buffer
    end
    
  events
    dataAvailable
  end
    
    methods
        
        % ctd constructor
        function obj = ctd(varargin)
            if( isa(varargin{1}, 'char'))
                % gives the XML pressure configuration file as the first argument
                fileXmlcon = varargin{1};
            else
                error('us191:ctd', '%s is an invalid xml file ', varargin{1});
            end
            obj@us191.serial(varargin{2:end});
            obj@decode(1,0);
            obj@compute(fileXmlcon);
            
            obj.listenerHandle = addlistener(obj,'sentenceAvailable',@obj.handleEvnt);
        end
        
        % init send initialization commands to deck-unit SBE11
        function open(obj)
            open@us191.serial(obj)
            obj.sendCommand(obj.initSbe11);
            obj.rawFid = fopen(obj.rawFileName, 'wt');  % open raw file
            obj.dataFid = fopen(obj.dataFileName, 'wt');
            obj.sendCommand(obj.startSbe11);
        end
        
        function close(obj)
            obj.sendCommand(obj.stopSbe11)
            fclose(obj.rawFid);        % close raw file
            fclose(obj.dataFid);
            delete(obj.listenerHandle);
            close@us191.serial(obj);
        end % end of close
        
        % setter and getter methods for public properties
        function set.rawFileName(obj, rawFileName)
            obj.rawFileName = rawFileName;
        end
        
        function rawFileName = get.rawFileName(obj)
            rawFileName = obj.rawFileName;
        end
        
        function set.dataFileName(obj, dataFileName)
            obj.dataFileName = dataFileName;
        end
        
        function dataFileName = get.dataFileName(obj)
            dataFileName = obj.dataFileName;
        end
        
        function set.delay(obj, delay)
            obj.delay = delay;
        end
        
        function delay = get.delay(obj)
            delay = obj.delay;
        end
        
        function set.echo(obj, echo)
            obj.echo = echo;
        end
        
        function echo = get.echo(obj)
            echo = obj.echo;
        end
        
        % display ctd object
        % ---------------------
        function disp(obj)
            
            disp@us191.serial(obj);
            
            % display properties
            % ------------------
            fprintf('  Raw file:   ''%s''\n', obj.rawFileName);
            fprintf('  Data file:  ''%s''\n', obj.dataFileName);
            fprintf('  Delay:       %3.1f\n', obj.delay);
            fprintf('  Echo:       ''%s''\n', obj.echo);
            
            % diplay methods list in hypertext link
            % -------------------------------------
            disp('list of <a href="matlab:methods(''us191.ctd'')">methods</a>');
            fprintf('\n');
        end
        
    end  % end of public methods
    
    methods (Access = private)
        
        % call when data available on serial port
        function handleEvnt(obj,~,~)
            
            raw = obj.decodeTrame(obj.sentence);
            temperature = obj.computeTemp(raw.pressureTemperature);
            obj.modulo = raw.modulo;
            % be careful with frequencies, one vale with this CTD
            % initialisation
            obj.pressure = obj.computePress(raw.frequencies, temperature);
            if obj.echo
                fprintf(1, '%s   ', obj.sentence);
                fprintf(1, 'Press= %8.3fdb, Temp= %5.2f°C Modulo: %3d\n', ...
                    obj.pressure, temperature, raw.modulo);
            end
            % save data to .hex and .cnv files
            % add header with station number, date, time and position
            fprintf(obj.rawFid, '%s\n', obj.sentence);
            fprintf(obj.dataFid, '%8.3f, %5.2f\n', obj.pressure, temperature);
            
            % define Event-Specific Data
            evtdata = ToggleEventData(obj.pressure,temperature,...
                raw.modulo,raw.frequencies);
            % send notification with evtdata object
            notify(obj, 'dataAvailable', evtdata);
            
        end % end of function handleEvnt
        
        function sendCommand(obj, cmds)
            %theCmd = [];
            for cmd = cmds
                theCmd = char(cmd);
                fprintf(1, '%s\n', theCmd);
                fprintf(obj.sp, '%s\n', theCmd);
                pause(obj.delay);
            end
        end
        
    end % en of private methods
    
end % end of ctd class

