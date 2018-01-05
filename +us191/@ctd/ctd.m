classdef ctd < us191.serial
  %UNTITLED Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
  end
  
  methods
     function obj = ctd(port)
      obj@us191.serial(port);
    end
  end
  
end

