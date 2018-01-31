function [ count ] = save_count(bit,m)
            
            data_count = bit(m:m+2);    %Get length of word for each frequency
            
            %Dimension of each byte
            byte = [data_count(1),data_count(2),data_count(3)];
            
            count = hex2dec(byte);      
%             disp(count)
             
            
end