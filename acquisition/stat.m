
classdef stat < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dataName = 'test.cnv'
        statFileName = 'test.txt'
        average                     %mean or average
        variance                
        med                         %median
        standDev                    %STandard deviation
           
    end
    
    properties (Access = private)
        statFid                
        dataFid
        data                %Data in cnv file
        sizeBuffer = 41;    %Cacul stat on 41 values of pressure
        sizeData            %Nb value in file cnv
        nbValue             %number pressure measure

    end
    
    methods
        %Open files
        function obj = stat()
            obj.statFid = fopen(obj.statFileName, 'wt'); 
            obj.dataFid = fopen(obj.dataName, 'r');
            
        end
        
        %Read file cnv 
        function read(obj)
            
                while ~feof(obj.dataFid)
                    obj.data = textscan(obj.dataFid,'%f%f','Delimiter',',');
                    obj.data = cell2mat(obj.data);   
                    obj.sizeData = size(obj.data);
                end
        end
        
         %Circular buffer homemade
         function statistique(obj)
         %Definition number of stat value and data in file cnv
         obj.nbValue = uint16(obj.sizeData(1)/obj.sizeBuffer)-2;    
         obj.average = ones(obj.nbValue, 1);
         obj.med = ones(obj.nbValue, 1);
         obj.variance = ones(obj.nbValue, 1);
         obj.standDev = ones(obj.nbValue, 1);
         
         
         %Calcul values Statiqtique 
         pointer = 1;           
         for i =1 : 1 : obj.nbValue

                obj.average(i) = mean(obj.data(pointer:pointer+obj.sizeBuffer-1));
                obj.med(i) = median(obj.data(pointer:pointer+obj.sizeBuffer-1));
                obj.variance(i) = var(obj.data(pointer:pointer+obj.sizeBuffer-1));
                obj.standDev(i) = std(obj.data(pointer:pointer+obj.sizeBuffer-1));
                 
                pointer =  obj.sizeBuffer +pointer;
                


         end
disp(obj.average);
%         disp(obj.med);
%         disp(obj.variance);
%         disp(obj.standDev);
                
        
                fprintf(obj.statFid,'%.4f, %.4f, %.8f, %.4f\n',...
                    obj.average, obj.med, obj.variance, obj.standDev);
       end
        
        function close(obj)
            
            fclose(obj.statFid);        
            fclose(obj.dataFid);

        end % end of close
        
        
    end
    
end

