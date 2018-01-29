classdef trame < us191.CTD
    
    %     properties
    %
    %     end
    
    methods (Static)
        
        function data_trame
            
            %Open file
            fid = fopen('test-deckunit_2.txt','r');
            
            %Read at the end of file
            while ~feof(fid)
                line = fgetl(fid);      %get trame since file
                dimension = size(line,1);
                byte = num2cell(line);  %Byte in each cell
                data = hex2dec(byte) ;  %Convert hexa number to dec number
                %disp(byte(6))
                %disp(data(6))
                
                if dimension == 66
                    
                for i = 1:30
                    switch i
                        case 1
                            
                            w0_b0 = [dec2bin(data(i),4),dec2bin(data(i+1),4)];
                            w0_b1 = [dec2bin(data(i+2),4),dec2bin(data(i+3),4)];
                            w0_b2 = [dec2bin(data(i+4),4),dec2bin(data(i+5),4)];
                            
                            w0_b0_dec = bin2dec(strjoin({w0_b0}));
                            w0_b1_dec = bin2dec(strjoin({w0_b1}));
                            w0_b2_dec = bin2dec(strjoin({w0_b2}));
                            
                        case 7
                            w1_b0 = [dec2bin(data(i),4),dec2bin(data(i+1),4)];
                            w1_b1 = [dec2bin(data(i+2),4),dec2bin(data(i+3),4)];
                            w1_b2 = [dec2bin(data(i+4),4),dec2bin(data(i+5),4)];
                            
                            w1_b0_dec = bin2dec(strjoin({w1_b0}));
                            w1_b1_dec = bin2dec(strjoin({w1_b1}));
                            w1_b2_dec = bin2dec(strjoin({w1_b2}));
                            %disp(w1_b2_dec);
                            
                        case 13
                            w2_b0 = [dec2bin(data(i),4),dec2bin(data(i+1),4)];
                            w2_b1 = [dec2bin(data(i+2),4),dec2bin(data(i+3),4)];
                            w2_b2 = [dec2bin(data(i+4),4),dec2bin(data(i+5),4)];
                            
                            w2_b0_dec = bin2dec(strjoin({w2_b0}));
                            w2_b1_dec = bin2dec(strjoin({w2_b1}));
                            w2_b2_dec = bin2dec(strjoin({w2_b2}));
                            
                        case 19
                            w3_b0 = [dec2bin(data(i),4),dec2bin(data(i+1),4)];
                            w3_b1 = [dec2bin(data(i+2),4),dec2bin(data(i+3),4)];
                            w3_b2 = [dec2bin(data(i+4),4),dec2bin(data(i+5),4)];
                            
                            w3_b0_dec = bin2dec(strjoin({w3_b0}));
                            w3_b1_dec = bin2dec(strjoin({w3_b1}));
                            w3_b2_dec = bin2dec(strjoin({w3_b2}));
                            
                        case 25
                            w4_b0 = [dec2bin(data(i),4),dec2bin(data(i+1),4)];
                            w4_b1 = [dec2bin(data(i+2),4),dec2bin(data(i+3),4)];
                            w4_b2 = [dec2bin(data(i+4),4),dec2bin(data(i+5),4)];
                            
                            w4_b0_dec = bin2dec(strjoin({w4_b0}));
                            w4_b1_dec = bin2dec(strjoin({w4_b1}));
                            w4_b2_dec = bin2dec(strjoin({w4_b2}));
                            
                            f_prim_temp = (w0_b0_dec*256)+w0_b1_dec+(w0_b2_dec/256);
                            f_prim_cond = (w1_b0_dec*256)+w1_b1_dec+(w1_b2_dec/256);
                            f_pressure = (w2_b0_dec*256)+w2_b1_dec+(w2_b2_dec/256);
                            f_second_temp = (w3_b0_dec*256)+w3_b1_dec+(w3_b2_dec/256);
                            f_second_cond = (w4_b0_dec*256)+w4_b1_dec+(w4_b2_dec/256);
%                             disp(f_pressure)
                    end
                    
                    
                end
                
                %Read all frequency
                frequency = [f_prim_temp, f_prim_cond, f_pressure, f_second_temp, f_second_cond];
                disp(frequency);
                
                else
                    break;
                end

            end
            
            %Close file
            fclose(fid);
            
        end
        
    end
    
end
