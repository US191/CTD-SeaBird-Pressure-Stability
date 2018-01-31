function [ p ] = save_par(bit,k)
            
            data_p = bit(k:k+2);    %Get length of word for each frequency
            
            %Dimension of each byte
            byte = [data_p(1),data_p(2),data_p(3)];
%             disp(byte)
            byte_dec = hex2dec(byte);                          
            p = byte_dec/819;   
            
end