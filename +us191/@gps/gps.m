classdef gps < us191.serial
  %UNTITLED Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    time
    lat_deg
    lon_deg
    latitude
    longitude
  end
  
  methods
    function obj = gps(port)
      obj@us191.serial(port);
    end
    
    function read(obj)
      while true
        if obj.available
          ident = textscan(obj.trame, '$%*2s%3s*[^\n]', 'delimiter', ',');
          ident = char(ident{1});
          switch ident
            case 'GGA'
              s = textscan(obj.trame, '$GPGGA %s %s %s %s %s', 'delimiter', ',');
              if( ~isempty(s{1}))
                obj.time = char(s{1});
                obj.lat_deg = char(s{2}); lat_s = char(s{3});
                obj.lon_deg = char(s{4}); lon_s = char(s{5});
                %obj.latitude = str2double(obj.DegMinToDec(obj.lat_deg, lat_s));
                %obj.longitude = str2double(obj.DegMinToDec(obj.lon_deg, lon_s));
                fprintf(1, 'Time: %s Lat: %s Long: %s\n', obj.time,obj.lat_deg, obj.lon_deg);
              end
              obj.available = false;
          end
        end
      end
    end
    
    function dec = DegMinToDec(obj,degmin,EWNS)
      % Latitude string format: ddmm.mmmm (dd = degrees)
      % Longitude string format: dddmm.mmmm (ddd = degrees)
      
      if nargin ~= 2
        dec = '-2';
      else
        % Determine  if data is latitude or longitude
        switch length(strtok(degmin,'.'))
          case 4
            % latitude data
            deg = str2double(degmin(1:2)); % extract degrees portion of latitude string and convert to number
            min_start = 3;              % position in string for start of minutes
          case 5
            % longitude data
            deg = str2double(degmin(1:3)); % extract degrees portion of longitude string and convert to number
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
    end % end of DegMinToDec
    
  end % end of public method
end % end of gps class

