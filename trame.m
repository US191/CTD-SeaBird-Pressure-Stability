classdef trame < handle
    
    %     properties
    %
    %     end
    
    methods (Static)
        
        %decomposition of trame and recording frequency in file
        function data_trame
            
            %Open files
            fid1 = fopen('test-deckunit_2.txt','r');   
            fid2 = fopen('frequency.text','w');
            
            nb_sensor = 3;      %Selec number of sensor
            dim = nb_sensor*6;  %Dimension trame with the nb of sensor      
            
            while ~feof(fid1)
                trame = fgetl(fid1);      
                bit = lower(trame);
                
                for i = 1 : 6 : dim     
                    [freq] = save_freq(bit,i);  %Get all frequency with funct
                    fprintf(fid2,'%f\n',freq);  %Save datas in file : fid2
                    %disp(freq);
                end
                
            end
            
            %Close files
            fclose(fid1);
            fclose(fid2);
        end
    end
end

