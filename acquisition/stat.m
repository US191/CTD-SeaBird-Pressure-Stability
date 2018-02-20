
classdef stat < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dataFileName = 'test.cnv'
        statFileName = 'test.txt'
        data
        average 
        variance
        med
        standDev

    end
    
    properties (Access = private)
        statFid                
        dataFid
        sizeBuffer = 25;
       
        
    end
    
    methods
        %Open files
        function obj = stat()
            obj.statFid = fopen(obj.statFileName, 'wt'); 
            obj.dataFid = fopen(obj.dataFileName, 'r');
            
        end
        
        function read(obj)
            
                while ~feof(obj.dataFid)
                    obj.data = textscan(obj.dataFid,'%f%f','Delimiter',',');
                    obj.data = cell2mat(obj.data);   
                end
            
        end
        
         function statistique(obj)

                obj.average = mean(obj.data(1:obj.sizeBuffer));
                obj.med = median(obj.data(1:obj.sizeBuffer));
                obj.variance = var(obj.data(1:obj.sizeBuffer));
                obj.standDev = std(obj.data(1:obj.sizeBuffer));
                
                fprintf(obj.statFid,'%.4f, %.4f, %.8f, %.4f\n',...
                    obj.average, obj.med, obj.variance, obj.standDev);
       end
        
        function close(obj)
            
            fclose(obj.statFid);        
            fclose(obj.dataFid);

        end % end of close
        
        
    end
    
end

