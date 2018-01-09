classdef gps < us191.serial
  %UNTITLED Summary of this class goes here
  %   Detailed explanation goes here
  
  properties (Access = private)
    time
    latitude
    longitude
  end
  
  properties (Access = private)
    listenerHandle % Property for listener handle
  end
  
  methods  % public
    function obj = gps(port)
      obj@us191.serial(port);
      obj.listenerHandle = addlistener(obj,'sentenceAvailable',@obj.handleEvnt);
    end
    
    function read(obj)
      if ~isempty(obj.sentence)
        fprintf(1, 'Time: %6.0f Lat: %8.5f Long: %9.5f\n', obj.time,obj.latitude, obj.longitude);
      end
    end
    
    
    function handleEvnt(obj,~,~)
      ident = textscan(obj.sentence, '$%*2s%3s*[^\n]', 'delimiter', ',');
      ident = char(ident{1});
      switch ident
        case 'GGA'
          s = textscan(obj.sentence, '$GPGGA %s %s %s %s %s', 'delimiter', ',');
          if( ~isempty(s{1}))
            obj.time = str2double(char(s{1}));
            obj.latitude = str2double(us191.gps.degMinToDec(char(s{2}), char(s{3})));
            obj.longitude = str2double(us191.gps.degMinToDec(char(s{4}), char(s{5})));
            
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

