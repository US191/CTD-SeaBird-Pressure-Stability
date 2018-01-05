classdef gps < us191.serial
  %UNTITLED Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
  end
  
  methods
    function obj = gps(port)
      obj@us191.serial(port);
    end
  end
  
end

