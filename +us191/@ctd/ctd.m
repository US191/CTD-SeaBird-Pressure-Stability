classdef ctd < us191.serial
  %CTD collect and compute pressure from deck-unit SBE11+ with serial port
  % s = us191.ctd('COM9','baudrate',19200,'terminator','CR/LF')
  % s.open
  % s.close
  %
  
  properties (Access = private)
    fileName = 'test.hex'
    delay = 0.5
  end
  
  properties (Access = private)
    listenerHandle % Property for listener handle
    fid
    initSbe11 = {...
      'R',...               % reset buffer
      'U',...               % reset words
      'A01',...             % scans average deckunit
      'X0',...              % remove word Xn
      'X1','X3','X4','X5','X6','X7','X8',...
      'addSPAR=N'}          % remove SPAR
    startSbe11 = 'GR';      % start acquisition
    stopSbe11 = { ...
      'S',...               % stop acquisition
      'R'}                  % reset buffer
  end
  
  methods
    
    % ctd constructor
    function obj = ctd(varargin)
      obj@us191.serial(varargin{:});
      obj.listenerHandle = addlistener(obj,'sentenceAvailable',@obj.handleEvnt);
    end
    
    % init send initialization commands to deck-unit SBE11
    function open(obj)
      open@us191.serial(obj)
      sendCommand(obj.initSbe11);
      obj.fid = fopen(obj.fileName, 'wt');
      sendCommand(obj.startSbe11);
    end
    
    function close(obj)
      sendCommand(obj.stopSbe11)
      fclose(obj.fid);        %Close file
      delete(obj.listenerHandle);
      close@us191.serial(obj);
    end % end of close
    
    function set.fileName(obj, fileName)
      obj.fileName = fileName;
    end
    
    function fileName = get.fileName(obj)
      fileName = obj.fileName;
    end
    
    function set.delay(obj, delay)
      obj.delay = delay;
    end
    
    function delay = get.delay(obj)
      delay = obj.delay;
    end
    
    % display ctd object
    % ---------------------
    function disp(obj)
      
      disp@us191.serial(obj);
      
      % display properties
      % ------------------
      fprintf('  FileName:   ''%s''\n', obj.fileName);
      fprintf('  Delay:      ''%3.1f''\n', obj.delay);
      
      % diplay methods list in hypertext link
      % -------------------------------------
      disp('list of <a href="matlab:methods(''us191.ctd'')">methods</a>');
      fprintf('\n');
    end
    
  end  % end of public methods
  
  methods (Access = private)
    
    % call when data available on serial port
    function handleEvnt(obj,~,~)
      fprintf(1, '%s\n', obj.sentence);
      fprintf(obj.fid, '%s\n', obj.sentence);
    end % end of function handleEvnt
    
    function sendCommand(obj, cmds)
      for cmd = cmds
        fprintf(obj.sp, '%s\n', char(cmd));
        pause(obj.delayo);
      end
    end
    
  end % en of private methods
  
end % end of ctd class

