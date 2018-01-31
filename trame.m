classdef trame < handle
    
    %     properties (Access = private)
    %
    %     end
    
    methods (Static)
        
        %decomposition of trame and recording frequency in file
        function data_trame
            
            %Open files
            fid1 = fopen('test-deckunit_2.txt','r');
            fid2 = fopen('frequency.text','w');
            fid3 = fopen('volt.text','w');
            
            nb_freq = 1;                %Selec number of frequency
            nb_analog_volt = 8;
            dim_volt = nb_analog_volt*3;
            dim_freq = nb_freq*6;       %Dimension trame with the nb of frequency
            
            while ~feof(fid1)
                trame = fgetl(fid1);
                bit = lower(trame);
                
                               
                for i = 1 : 6 : dim_freq
                    [freq] = save_freq(bit,i);  %Get all frequency with funct
                    fprintf(fid2,'%f\n',freq);  %Save datas in file : fid2
                    %disp(freq);
                end
                
                for j = dim_freq +1 : 3 : dim_freq + dim_volt
                    [volt] = save_volt(bit,j);  %Get all voltage with funct
                    fprintf(fid3,'%f\n',volt);  %Save datas in file : fid3
                end
                
            end
            
            %Close files
            fclose(fid1);
            fclose(fid2);
            fclose(fid3);
        end
    end
    
end

