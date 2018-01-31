classdef trame < handle
    
    
    methods (Static)
        
            %decomposition of trame and recording frequency in file
        function data_trame
            
            %Open files
            fid1 = fopen('test-deckunit_2.txt','r');
            fid2 = fopen('frequency.text','w');
            fid3 = fopen('volt.text','w');
            fid4 = fopen('par.text','w');
            fid5 = fopen('comp.text','w');
            fid6 = fopen('count.text','w');
            fid7 = fopen('alldata.txt','w');
            
            nb_freq = 5;                %Selec number of frequency
            nb_analog_volt = 8;                      
            
            dim_volt = nb_analog_volt*3;
            dim_freq = nb_freq*6;       %Dimension trame with the nb of frequency
            dim_comp = 3; 
            dim_par = 4;
            
            while ~feof(fid1)
                trame = fgetl(fid1);
                bit = lower(trame);
                
                
                for i = 1 : 6 : dim_freq
                    [freq] = save_freq(bit,i);  
                    fprintf(fid2,'%f\n',freq);  
                    %disp(freq);
                end
                
                for j = dim_freq +1 : 3 : dim_freq + dim_volt
                    [volt] = save_volt(bit,j);  
                    fprintf(fid3,'%f\n',volt);  
                end
                
                for l = dim_freq + dim_volt + 4  
                    [par] = save_par(bit,l);  
                    fprintf(fid4,'%f\n',par);  
                end
                
                for k = dim_freq + dim_volt + dim_par +3  
                    [comp] = save_comp(bit,k);  
                    fprintf(fid5,'%f\n',comp);  
                end
                
                for m = dim_freq + dim_volt + dim_par + dim_comp + 3
                    [count] = save_count(bit,m);  
                    fprintf(fid6,'%f\n',count); 
                end
                fprintf(fid7,'%f\t%f\t%f\t%f\t%f\t\n',freq , volt, par, comp, count);  
                
            end
            
            %Close files
            fclose(fid1);
            fclose(fid2);
            fclose(fid3);
            fclose(fid4);
            fclose(fid5);
            fclose(fid6);
            fclose(fid7);
        end
    end
    
end

