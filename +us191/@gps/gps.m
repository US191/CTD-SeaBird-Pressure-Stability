classdef gps < us191.serial
  %UNTITLED Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    Time
    Lat_deg
    Lon_deg
    Latitude
    Longitude
  end
  
  properties
    ListenerHandle % Property for listener handle
  end
  
  methods  % public
    function obj = gps(port)
      obj@us191.serial(port);
      obj.ListenerHandle = addlistener(obj,'SentenceAvailable',@obj.handleEvnt);
    end
    
    function read(obj)
      if ~isempty(obj.sentence)
        fprintf(1, 'Time: %s Lat: %s Long: %s\n', obj.Time,obj.Lat_deg, obj.Lon_deg);
      end
    end
    
    
    function handleEvnt(obj,~,~)
      ident = textscan(obj.sentence, '$%*2s%3s*[^\n]', 'delimiter', ',');
      ident = char(ident{1});
      switch ident
        case 'GGA'
          s = textscan(obj.sentence, '$GPGGA %s %s %s %s %s', 'delimiter', ',');
          if( ~isempty(s{1}))
            obj.Time = char(s{1});
            obj.Lat_deg = char(s{2}); lat_s = char(s{3});
            obj.Lon_deg = char(s{4}); lon_s = char(s{5});
            %obj.Latitude = str2double(obj.DegMinToDec(obj.Lat_deg, lat_s));
            %obj.Longitude = str2double(obj.DegMinToDec(obj.Lon_deg, lon_s));
            
          end
      end
    end % end of function handleEvnt
    
    function close(obj)
      delete(obj.ListenerHandle)
      % call Superclass serial from package us191
      close@us191.serial(obj);
    end
    
  end % end of public methods
  
  methods(Access = private)
    
    function dec = DegMinToDec(obj,degmin,EWNS)
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
        
        minutes = (strdouble(degmin(min_start:length(degmin))))/60; % convert minutes to decimal degrees
        
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

