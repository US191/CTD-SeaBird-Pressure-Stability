classdef trame < handle
    
    %     properties
    %
    %     end
    
    methods (Static)
        
        function read_trame
            
            %Open file
            fid = fopen('test-deckunit_2.txt','r');
            
            %Read at the end of file
            while ~feof(fid)
                line = fgetl(fid);      %get trame since file
                byte = num2cell(line);  %Byte in each cell
                data = hex2dec(byte) ;  %Convert hexa number to dec number
                %disp(byte(6))
                %disp(data(6))
                
%Calcul frequency

                f_prim_temp = (data(1)*256)+data(2)+(data(3)/256);
                f_prim_cond = (data(4)*256)+data(5)+(data(6)/256);
                f_pressure = (data(7)*256)+data(8)+(data(9)/256);
                
                %Read all frequency
                %frequency = [f_prim_temp, f_prim_cond, f_pressure];
                %disp(frequency)
                
                
%Calcul Pressure temperature compensation
                bin_byte30 = dec2bin(data(64),8);   %Convert hexa number to bin number
                bin_byte31 = dec2bin(data(65),8);
                
                bit30 = num2cell(bin_byte30);       %Bit in each cell
                bit31 = num2cell(bin_byte31);
                
                %Calcul N  : byte of 12 bits
                N = [bit30, bit31(1), bit31(2), bit31(3), bit31(4)];
                N_bin = strjoin(N);     %Recover 12 bits
                N_dec = bin2dec(N_bin); %Convert bin number to dec number
                %disp(N_dec)
                
                %Coeff Pressure temperature compensation
                M = 0.01258;
                B = -9.844;
                Td = (M*N_dec)-B;
                %disp(Td)
                
                
                
% Calcul Pressure with coeff 
                
                %Calibration coeff
                C1 = -46143.45;
                C2 = 1.63839^-1;
                C3 = 1.31621^-2;
                D1 = 0.035448;
                D2 = 0;
                T1 = 0.035448;
                T2 = -2.14803^-4;
                T3 = 3.63788^-6;
                T4 = 2.62774^-9;
                T5 = 0;
                
                %Calcul Pressure (psia)
                C = C1 + C2*Td + C3*Td^2;
                D = D1 + D2*Td;
                T = 1/f_pressure;
                To = T1 + T2*Td + T3*Td^2 + T4*Td^3 + T5*Td^4;
                P = C*(1-(To^2/T^2))*(1-D*(1-(To^2/T^2)));
                disp(P)     
            end
            
            %Close file
            fclose(fid);
            
        end
        
    end
    
end
