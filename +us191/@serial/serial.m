classdef serial < handle
  %US191.SERIAL receive data from serial RS232 line
  %
  %  example:
  %
  % >> us191.serial.Discover
  %
  % ans =
  %
  %   4×1 cell array
  %
  %     {'COM3' }
  %     {'COM9' }
  %     {'COM11'}
  %     {'COM12'}
  %
  % s = us191.serial('COM9','baudrate',4800,'terminator','CR/LF')
  % s =
  %
  %   Port:       'COM9'
  %   BaudRate:   4800
  %   DataBits:   8
  %   StopBits:   1
  %   Parity:     'none'
  %   Terminator: 'CR/LF'
  %   Status:     'not connected'
  %   Echo:       'false'
  %
  % >> s.open
  % s =
  %
  %   Port:       'COM9'
  %   BaudRate:   4800
  %   DataBits:   8
  %   StopBits:   1
  %   Parity:     'none'
  %   Terminator: 'CR/LF'
  %   Status:     'open'
  %   Echo:       'false'
  %
  % list of methods
  %
  % Methods for class us191.serial:
  %
  % close                getParity            open                 setParity
  % disp                 getPort              serial               setPort
  % getBaudRate          getStatus            setBaudRate          setStopBits
  % getDataBits          getStopBits          setDataBits          setTerminator
  % getEcho              getTerminator        setEcho
  %
  % Static methods:
  %
  % Discover             getAvailableComPort
  %
  % Methods of us191.serial inherited from handle.
  % 
  % Open the serial port, status must be 'open'. The serial port class trigger an event 'sentenceAvailable' to notify when a valid sentence terminated with 'Terminator' character(s) was received, eg 'CR/LF' for a GPS NMEA183.
  % To see the valid sentences, you can set private property 'echo' to 'true' in constructor function or use set.Echo(true) function:
  % 
  % >> s = us191.serial('COM9','baudrate',4800,'terminator','CR/LF','echo',true)
  % >> s.open
  % Receive: $GPGGA,091512.553,4821.5783,N,00433.5824,W,1,06,2.8,70.1,M,52.2,M,,0000*75
  % Receive: $GPGSA,A,3,03,07,22,23,09,17,,,,,,,3.7,2.8,2.5*31
  % Receive: $GPRMC,091512.553,A,4821.5783,N,00433.5824,W,0.88,321.52,120118,,,A*74
  % Receive: $GPGGA,091513.553,4821.5744,N,00433.5764,W,1,06,2.8,79.0,M,52.2,M,,0000*7C
  % Receive: $GPGSA,A,3,03,07,22,23,09,17,,,,,,,3.7,2.8,2.5*31
  % Receive: $GPRMC,091513.553,A,4821.5744,N,00433.5764,W,0.66,327.63,120118,,,A*71
  % Receive: $GPGGA,091514.553,4821.5729,N,00433.5744,W,1,06,2.8,81.1,M,52.2,M,,0000*74
  % Receive: $GPGSA,A,3,03,07,22,23,09,17,,,,,,,3.7,2.8,2.5*31
  % Receive: $GPRMC,091514.553,A,4821.5729,N,00433.5744,W,0.54,329.36,120118,,,A*70
  % Receive: $GPGGA,091515.553,4821.5725,N,00433.5744,W,1,06,2.8,81.0,M,52.2,M,,0000*78
  % >> s.close
  %
  % ### Inherited class gps
  %
  % This class defined a listener as:
  % 
  %  obj.listenerHandle = addlistener(obj,'sentenceAvailable',@obj.handleEvnt)
  % ```
  % This listener wait for the notification ''sentenceAvailable' which notify that a valid sentence was received and the handleEvnt() function decode NMEA sentence and save data (time, latitude, longitude and GPS quality indicator) in private properties.
  % The read function display the last available data and call open function if the serail port was 'closed'.
  % See Matlab documentation Events and Listeners Syntax:
  % https://fr.mathworks.com/help/matlab/matlab_oop/events-and-listeners-syntax-and-techniques.html#brb6i6i
  %
  % 
  % >> s=us191.gps('COM9')
  %
  % s =
  %
  %   Port:       'COM9'
  %   BaudRate:   4800
  %   DataBits:   8
  %   StopBits:   1
  %   Parity:     'none'
  %   Terminator: 'CR/LF'
  %   Status:     'not connected'
  %   Echo:       'true'
  %
  % >> s.read
  % Time:  92422 Lat: 48.35984 Long:  -4.55978
  % >> s.close
  %
  % ## Serial class on Linux
  %
  % Under Linux, you must specify Java Startup Options to see serial port with Matlab.
  %
  % Create the file java.opts under /usr/local/MATLAB/R2017b/bin/glnxa64
  %
  % with the following line :
  % 
  %   -Dgnu.io.rxtx.SerialPorts=/dev/ttyS4:/dev/ttyUSB0
  %
  % Use the 'ls /dev/tty*' command to discover the new serail port.
  %
  % Add the user to dialer group and change /dev/ttyUSB0 permission to 777
  %
  % >> us191.serial.Discover
  %
  % ans =
  %
  %   2×1 cell array
  %
  %     {'/dev/ttyS4'  }
  %     {'/dev/ttyUSB0'}
  %
  % >> s=us191.gps('/dev/ttyUSB0','baudrate',4800,'terminator','CR/LF')
  % ...
  
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
        % set serial port with first argument, eg COMx
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
      % Todos: add more tests
      % add test for a valid port with regexp,
      % eg COMx under windows, /dev/ttyS* for Linux
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
        fprintf(1, 'Receive: ');
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

