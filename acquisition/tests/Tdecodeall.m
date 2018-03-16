classdef Tdecodeall < matlab.unittest.TestCase
    %UNTITLED Summary of this class goes here
    %   methods test decode
    properties
        filetrame
        filedata
        vtrame 
        vdata
    end
    
    methods (Static)
        function readfiletrame(obj)
            obj.filetrame = fopen('fr27001test.hex','r');
            obj.vtrame=[];
            
            while ~feof(obj.filetrame)
                trame = fgetl(obj.filetrame);
                obj.vtrame =  trame;
            end
%             disp(obj.vtrame);
            d = decode;
            d.save(trame);
            c = Cal;
            c.Calcul;
            fclose(obj.filetrame);
        end
        
        
        function readfiledata(obj)
            obj.filedata = fopen('fr27001test.cnv','r');
            obj.vdata=[];
            while ~feof(obj.filedata)
                str = fgetl(obj.filedata);
                obj.vdata =  str;
                obj.vdata = sscanf(str,'%d%f%f%f%f%f%f%f%f%f%f%f%f%f%f',16);
            end
            disp(obj.vdata(3));
            fclose(obj.filedata);
        end
        
    end
    
%     methods(Test)
%         function test(obj)
%              
%              obj.verifyEqual(obj.vtrame, obj.vdata);
%         end        
%         
%     end
    
end
