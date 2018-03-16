classdef compute < handle
  
  properties (Access = private)
  end
  
  properties
    coeff
  end
  
  methods
    
    % constructor
    function obj = compute(fileXmlcon)
      obj.coeff = readXmlcon(fileXmlcon);
    end % end of constructor
    
    
    % pressure temperature compensation
    % Td = (M * N) + B
    function Td = computeTemp(obj, N)
      % pressure temperature compensation Td = (M * N) + B
      Td = obj.coeff('AD590M') * N + obj.coeff('AD590B');
    end
    
    % compute pressure in db from raw CTD pressure frecency F and raw
    % pressure temperature compensationto N using calibration coefficients
    % from XML file.
    %
    % pressure (psia)
    % C = C1 + C2*T + C3*T^2
    % D = D1 + D2*T
    % To = T1 + T2*T + T3*T^2 + T4*T^3
    % T = pressure period (microsec)
    % P = C(1-(To^2/T^2)(1-D(1-To^2/T^2))
    % pressure in decibard
    % P = P / 1.450377;
    function P = computePress(obj, F, Td)
      
      % compute Pressure (psia)
      C = obj.coeff('C1') + obj.coeff('C2') * Td + obj.coeff('C3') * Td^2;
      D = obj.coeff('D1') + obj.coeff('D2') * Td;
      F = F * 10^-6;
      To = obj.coeff('T1') + obj.coeff('T2') *Td + obj.coeff('T3') * Td^2 + ...
        obj.coeff('T4') * Td^3 + obj.coeff('T5') * Td^4;
      P = C * (1 - To^2 * F^2) * (1 - D * (1 - To^2 * F^2));
      % convert from PSI to dbars, sen AN73:
      % http://www.seabird.com/document/an73-using-instruments-pressure-sensors-elevations-above-sea-level
      % Pressure (db) = [pressure (psia) – 14.7] * 0.689476
      P = (P - 14.7) * 0.689476;
      P = P * obj.coeff('Slope') + obj.coeff('Offset');
    end % end of compute
    
    function disp(obj)
      for k = keys(obj.coeff)
        v = obj.coeff(char(k));
        if isnumeric(v)
          fprintf(1, '%s: %g\n', char(k), v);
        else
          fprintf(1, '%s: %s\n', char(k), v);
        end
        
      end
    end % end of disp
    
  end % end of public methods
  
end % end of class
