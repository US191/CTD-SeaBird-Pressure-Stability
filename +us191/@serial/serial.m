classdef serial < handle
  %Gps receive and print GPS data from serial RS232 line
  %   Detailed explanation goes here
  
  properties (Access = private)
    port
    baudRate = 4800
    dataBits = 8
    stopBits = 1
    parity = 'none'
    terminator = 'CR/LF'
    status = 'not connected'
    echo = false
  end
  
  properties (Access = protected)
    % sp is the matlab serial port, empty if not open
    sp = [];
    % sentence is the string return from serail port after reception of
    % terminator, usually CR/LF
    sentence = []
  end
  
  events
    sentenceAvailable
  end
  
  methods % public
    
    % class gps constructor
    function obj = serial(varargin)
      if( isa(varargin{1}, 'char'))
        % add test for a valid port with regexp,
        % eg COMx under windows, /dev/ttyS* for Linux
        obj.setPort(varargin{1});
      else
        error('us191:serial', '%s is an invalid serial port ', varargin{1});
      end
      if (nargin > 1 )
        property_argin = varargin(2:end);
        while length(property_argin) >= 2
          property = property_argin{1};
          value    = property_argin{2};
          property_argin = property_argin(3:end);
          switch lower(property)
            case 'echo'
              obj.setEcho(value);
            case 'baudrate'
              obj.setBaudRate(value);
            case 'databits'
              obj.setDataBits(value);
            case 'stopbits'
              obj.setStopBits(value);
            case 'parity'
              obj.setParity(value);
            case 'terminator'
              obj.setTerminator(value);
            otherwise
              error('us191:serial', 'Unknown property: %s', property);
          end
        end
      end
    end % end of serial constructor
    
    % open the serial port
    function open(obj)
      % if an instrument serial port stay in memory, clear it
      thePort = instrfind('Port', obj.port);
      if ~isempty(thePort)
        fclose(thePort);
        delete(thePort);
        clear thePort;
      end
      % create an serial port instance
      obj.sp = serial(obj.port, 'Baudrate', obj.baudRate);
      set(obj.sp, 'DataBits', obj.dataBits, 'StopBits', obj.stopBits,...
        'Parity', obj.parity);
      fopen(obj.sp);
      obj.sp.BytesAvailableFcnMode = 'terminator';
      obj.sp.Terminator = obj.terminator;
      % the callback
      obj.sp.BytesAvailableFcn = {@(src, event) obj.receive()};
    end
    
    % set the serial port name, eg COM9
    function setPort(obj, port)
      obj.port = port;
    end
    
    function port = getPort(obj)
      port = obj.port;
    end
    
    % set the speed, eg 4800 or 9600 bds
    function setBaudRate(obj, baudRate)
      switch baudRate
        case {300,600,1200,2400,4800,9600,19200,57600,112000}
          obj.baudRate = baudRate;
        otherwise
          error('MATLAB:gps:invalid baud rate value: %d', baudRate);
      end
    end
    
    function baudRate = getBaudRate(obj)
      baudRate = obj.baudRate;
    end
    
    % set the databits, eg 7 or 8
    function setDataBits(obj, dataBits)
      switch dataBits
        case {7,8}
          obj.dataBits = dataBits;
        otherwise
          error('MATLAB:gps:invalid data bit value: %d', dataBits);
      end
    end
    
    function dataBits = getDataBits(obj)
      dataBits = obj.dataBits;
    end
    
    % set the parity, eg none, odd or even
    function setParity(obj, parity)
      switch parity
        case {'none','odd','even'}
          obj.parity = parity;
        otherwise
          if isnumeric(parity)
            parity = num2str(parity);
          end
          error('MATLAB:gps:invalid parity: %s', parity);
      end
    end
    
    function parity = getParity(obj)
      parity = obj.parity;
    end
    
    % set the stop bit, eg 1 or 2
    function setStopBits(obj, stopBits)
      switch stopBits
        case {1,2}
          obj.stopBits = stopBits;
        otherwise
          error('MATLAB:gps:invalid stop bit value: %d', stopBits);
      end
    end
    
    function stopBits = getStopBits(obj)
      stopBits = obj.stopBits;
    end
    
    % set the terminator end line
    function setTerminator(obj, terminator)
      switch terminator
        case {'CR/LF','CR','LF'}
          obj.terminator = terminator;
        otherwise
          error('MATLAB:gps:invalid terminator character, value : %s', terminator);
      end
    end
    
    function terminator = getTerminator(obj)
      terminator = obj.terminator;
    end
    
    % set the serial port name, eg COM9
    function setEcho(obj, echo)
      if islogical(echo)
        obj.echo = echo;
      else
        error('MATLAB:gps:invalid echo mode, value : %s', echo);
      end
    end
    
    function echo = getEcho(obj)
      echo = obj.echo;
    end
    
    % return the status of the instrument
    function status = getStatus(obj)
      if isa(obj.sp, 'instrument') && isvalid(obj.sp)
        status = get(obj.sp, 'Status');
      else
        status = 'not connected';
      end
      obj.status = status;
    end
    
    % close the serial port sp and delete from memory
    function close(obj)
      if ~isempty(obj.sp)
        fclose(obj.sp);
        delete(obj.sp);
        clear obj.sp;
      end
      obj.sentence = [];
      obj.sp = [];
    end
    
    % display serial object
    % ---------------------
    function disp(obj)
      
      % use local variables for displaying boolean
      % ------------------------------------------
      if obj.echo
        theEcho = 'true';
      else
        theEcho = 'false';
      end
      
      % display properties
      % ------------------
      fprintf('  Port:       ''%s''\n', obj.getPort);
      fprintf('  BaudRate:   %d\n', obj.getBaudRate);
      fprintf('  DataBits:   %d\n', obj.getDataBits);
      fprintf('  StopBits:   %d\n', obj.getStopBits);
      fprintf('  Parity:     ''%s''\n', obj.getParity);
      fprintf('  Terminator: ''%s''\n', obj.getTerminator);
      fprintf('  Status:     ''%s''\n', obj.getStatus);
      fprintf('  Echo:       ''%s''\n', theEcho);
      fprintf('\n');
      
      % diplay methods list in hypertext link
      % -------------------------------------
      disp('list of <a href="matlab:methods(''us191.serial'')">methods</a>');
    end
    
  end % end of public methods
  
  % receive read data from serial port and display it
  methods (Access = private)
    
    function receive(obj, ~)
      obj.sentence = fgetl(obj.sp);
      notify(obj, 'sentenceAvailable');
      if obj.echo
        fprintf(1, 'Recu: ');
        fprintf(1, '%s\n', obj.sentence);
      end
    end
    
  end % end of private methods
  
  methods (Static)
    
    % prototype of function that was in private directory
    % ------------------------------------------------
    list = getAvailableComPort();
    
    % Discover returns a list of all serial ports on a system.
    function list = Discover()
      % seraillist was nntroduced in R2017a, version 9.2.x
      if verLessThan('matlab','9.2')
        list = us191.serial.getAvailableComPort();
      else
        % seriallist return string type not available before R2017a
        list = cellstr(seriallist)';
      end
    end
    
  end % end of static methods
  
end % end of class

