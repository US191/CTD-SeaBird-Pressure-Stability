classdef gps < handle
  %Gps receive and print GPS data from serial RS232 line
  %   Detailed explanation goes here
  
  properties
    sp;
  end
  
  methods
    function obj = gps()
      obj.sp = serial('COM7');
      set(obj.sp,'BaudRate',4800);
      fopen(obj.sp);
      obj.sp.BytesAvailableFcnMode = 'terminator';
      obj.sp.Terminator = 'CR/LF';
      obj.sp.BytesAvailableFcn = {@(src, event) receive(obj, src, event)};
    end
    
    function receive(obj, src, ~)
      trame = fgetl(src);
      fprintf(1, '%s\n',trame);
    end
    
    function delete(obj)
      fclose(obj.sp);
    end
  end
  
end


