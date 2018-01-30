%Function for calculating all frequency 

function [ f ] = save_freq(bit,i)

        data_f = bit(i:i+5);    %Get length of word for each frequency
        
        %Dimension of each byte
        byte = [data_f(1),data_f(2);data_f(3),data_f(4);data_f(5),data_f(6)];
        
        byte_dec = hex2dec(byte);                           %Convert data hex to dec
        f = byte_dec(1)*256+byte_dec(2)+byte_dec(3)/256;    %Calcul all frequency

end
