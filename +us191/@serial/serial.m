classdef serial < handle
  %Gps receive and print GPS data from serial RS232 line
  %   Detailed explanation goes here
  
  properties (SetAccess = public, GetAccess = public)
    Port
    BaudRate = 4800
    DataBits = 8
    StopBits = 1
    Parity = 'none'
    Terminator = 'CR/LF'
    Status = 'not connected'
  end
  
  properties (Access = public)
    sp = [];
    sentence = []
    available = false
  end
  
  events
    SentenceAvailable
  end
  
  methods % public
    
    % class gps constructor
    function obj = serial(port)
      obj.Port = port;
    end
    
    % open the serial port
    function open(obj)
      % if an instrument serial port stay in memory, clear it
      thePort = instrfind('Port', obj.Port);
      if ~isempty(thePort)
        fclose(thePort);
        delete(thePort);
        clear thePort;
      end
      % create an serial port instance
      obj.sp = serial(obj.Port, 'Baudrate', obj.BaudRate);
      set(obj.sp, 'DataBits', obj.DataBits, 'StopBits', obj.StopBits,...
        'Parity', obj.Parity);
      fopen(obj.sp);
      obj.sp.BytesAvailableFcnMode = 'terminator';
      obj.sp.Terminator = obj.Terminator;
      % the callback
      obj.sp.BytesAvailableFcn = {@(src, event) obj.receive()};
    end
    
    % get the serial port name, eg COM9
    function set.Port(obj, port)
      obj.Port = port;
    end
    
    % get the speed, eg 4800 or 9600 bds
    function set.BaudRate(obj, baudRate)
      switch baudRate
        case {300,600,1200,2400,4800,9600,19200,57600,112000}
          obj.BaudRate = baudRate;
        otherwise
          error('MATLAB:gps:invalid baud rate value: %d', baudRate);
      end
    end
    
    % get the databits, eg 7 or 8
    function set.DataBits(obj, dataBits)
      switch dataBits
        case {7,8}
          obj.DataBits = dataBits;
        otherwise
          error('MATLAB:gps:invalid data bit value: %d', dataBits);
      end
    end
    
    % get the parity, eg none, odd or even
    function set.Parity(obj, parity)
      switch parity
        case {'none','odd','even'}
          obj.Parity = parity;
        otherwise
          if isnumeric(parity)
            parity = num2str(parity);
          end
          error('MATLAB:gps:invalid parity: %s', parity);
      end
    end
    
    % get the stop bit, eg 1 or 2
    function set.StopBits(obj, stopBits)
      switch stopBits
        case {1,2}
          obj.StopBits = stopBits;
        otherwise
          error('MATLAB:gps:invalid stop bit value: %d', stopBits);
      end
    end
    
    % return the status of the instrument
    function status = get.Status(obj)
      if isa(obj.sp, 'instrument') && isvalid(obj.sp)
        status = get(obj.sp, 'Status');
      else
        status = 'not connected';
      end
      obj.Status = status;
    end
    
    % close the serial port sp and delete from memory
    function close(obj)
      if ~isempty(obj.sp)
        obj.available = false;
        fclose(obj.sp);
        delete(obj.sp);
        clear obj.sp;
      end
      obj.sentence = [];
      obj.sp = [];
    end
    
  end % end of public methods
  
  % receive read data from serial port and display it
  methods (Access = private)
    function receive(obj, ~)
      obj.sentence = fgetl(obj.sp);
      notify(obj, 'SentenceAvailable');
      %obj.available = true;
      %fprintf(1, 'Recu: ');
      %fprintf(1, '%s\n',sentence);
    end
  end % end of private methods
  
end % end of class

