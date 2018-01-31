function [ c ] = save_comp(bit,k)
            
            data_c = bit(k:k+2);    %Get length of word for each frequency
            
            %Dimension of each byte
            byte = [data_c(1),data_c(2),data_c(3)];
            
            byte_dec = hex2dec(byte);      
%             disp(byte_dec)
            c = byte_dec/819;   
            
end