classdef gps < us191.serial
  %US191.GPS receive, decode and display GGA sentence from NMEA-183 serial RS232 line
  %
  % example:
  %
  %  >> us191.gps.Discover
  %  >> s = us191.gps.Discover
  %
  % >> s =
  %
  %   4×1 cell array
  %
  %     'COM3'
  %     'COM9'
  %     'COM11'
  %     'COM12'
  %
  % >> s = us191.gps('COM9')
  %
  % >> s =
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
  % >> s.read
  % Time: 131138 Latitude: 48.35980 Longitude:  -4.55980
  % >> s.read
  % Time: 131249 Latitude: 48.35981 Longitude:  -4.55975
  %
  % >> s.close
  
  properties (Access = private)
    time
    latitude
    longitude
    quality = false
  end
  
  properties (Access = private)
    listenerHandle % Property for listener handle
  end
  
  methods  % public
    function obj = gps(varargin)
      obj@us191.serial(varargin{:});
      obj.listenerHandle = addlistener(obj,'sentenceAvailable',@obj.handleEvnt);
    end
    
    function read(obj)
      if isempty(obj.sp)
        obj.open()
        pause(1)  % wait for one second
      end
      if ~isempty(obj.sentence)
        fprintf(1, 'Time: %6.0f Latitude: %8.5f Longitude: %9.5f\n', obj.time,obj.latitude, obj.longitude);
      end
    end
    
    function handleEvnt(obj,~,~)
      ident = textscan(obj.sentence, '$%*2s%3s*[^\n]', 'delimiter', ',');
      ident = char(ident{1});
      switch ident
        case 'GGA'
          s = textscan(obj.sentence, '$GPGGA %s %s %s %s %s %s', 'delimiter', ',');
          obj.quality = str2double(char(s{6}));
          switch obj.quality
            case 0
              obj.time = str2double(char(s{1}));
              obj.latitude = NaN;
              obj.longitude = NaN;
            case {1,2}
              obj.time = str2double(char(s{1}));
              obj.latitude = str2double(us191.gps.degMinToDec(char(s{2}), char(s{3})));
              obj.longitude = str2double(us191.gps.degMinToDec(char(s{4}), char(s{5})));
              
            otherwise
              warning('MATLAB:gps:invalid GGA sentence, quality indicator is %d', obj.quality);
          end
      end
    end % end of function handleEvnt
    
    function close(obj)
      delete(obj.listenerHandle)
      % call Superclass serial from package us191
      close@us191.serial(obj);
    end
    
  end % end of public methods
  
  methods(Access = private, Static)
    
    function dec = degMinToDec(degmin,EWNS)
      % Latitude string format: ddmm.mmmm (dd = degrees)
      % Longitude string format: dddmm.mmmm (ddd = degrees)
      
      if nargin ~= 2
        dec = '-2';
      else
        % Determine  if data is Latitude or Longitude
        switch length(strtok(degmin,'.'))
          case 4
            % Latitude data
            deg = str2double(degmin(1:2)); % extract degrees portion of Latitude string and convert to number
            min_start = 3;              % position in string for start of minutes
          case 5
            % Longitude data
            deg = str2double(degmin(1:3)); % extract degrees portion of Longitude string and convert to number
            min_start = 4;              % position in string for start of minutes
          otherwise
            % data not in correct format
            dec = '-1';
            return;
        end
        
        minutes = (str2double(degmin(min_start:length(degmin))))/60; % convert minutes to decimal degrees
        
        dec = num2str(deg + minutes,'%11.10g'); % degrees as decimal number
        
        % add negative sign to decimal degrees if south of equator or west
        switch EWNS
          case 'S'
            % south of equator is negative, add -ve sign
            dec = strcat('-',dec);
          case 'W'
            % west of Greenwich meridian is negative, add -ve sign
            dec = strcat('-',dec);
          otherwise
            % do nothing
        end
      end
    end % end of private function DegMinToDec
    
  end % end of private methods
  
end % end of gps class

