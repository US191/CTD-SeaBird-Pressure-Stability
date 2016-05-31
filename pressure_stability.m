function pressure_stability
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Study the SeaBird pressure sensor stability                             %
%                                                                         %
%   Input:                                                                %
%       -SeaBird report file                                              %
%       -.cnv file with pressure temperature in column 1                  %
%       -.hdr file with pressure frequency take on the deck               %
%              before and after profile                                   %
%                                                                         %
% ->Recovery of the pressure sensor calibration coefficient               %
% ->Recovery of the temperature of the pressure sensor at the beginning   %
%   and the end of the profile                                            %
% ->Recovery of the pressure frequency before and after the profile       %
% ->Calculate and compare start/end profile pressure value                %
%   (if NaN, no frequency value)                                          %             
%                                                                         %
% Autor: Pierre Rousselot / Date: 05-2016                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Variable
rep_report = '/media/lefut/TOSHIBA_EXT/IRD/PIRATA-FR26/0-raw/report/';
rep_data = '/media/lefut/TOSHIBA_EXT/IRD/PIRATA-FR26/0-raw/cnvtemp/';
rep_hdr = '/media/lefut/TOSHIBA_EXT/IRD/PIRATA-FR26/0-raw/asc/';
id_campagne = 'fr26';
stations = 1:50;
%%

%% Initialization
pressure = ones(2,length(stations)) * NaN;

%% Loop on stations
for i_sta = stations
    fic_report = sprintf('%s%sst%3.3d.txt',rep_report,id_campagne,i_sta);
    fic_data = sprintf('%s%s%3.3d.cnv',rep_data,id_campagne,i_sta);
    fic_hdr = sprintf('%s%s%3.3d.hdr',rep_hdr,id_campagne,i_sta);
    
    %Data recovery
    [coef] = read_coef(fic_report);
    [temp_pressure] = read_Tpres(fic_data);
    [frequency] = read_frequency(fic_hdr);
    
    %Calculate coefficient and pressure
    [coef] = calc_coef(coef, temp_pressure);
    pressure(:, i_sta) = [coef.C.*...
        (1-((coef.To.^2).*(frequency(:, i_sta).^2))).*...
        (1-coef.D.*(1-((coef.To.^2).*(frequency(:, i_sta).^2))))].*...
        0.06894757293.*10-1; %(convert to dbar)
    
    diff_pressure_deb_fin(i_sta) = pressure(2,i_sta) - pressure(1,i_sta);
    fprintf(1, 'Profile %3.3d - Start/End pressure difference (on deck) : %f db\n', ...
        i_sta, diff_pressure_deb_fin(i_sta));
    
end

%% Result
mean_diff_pressure = nanmean(abs(diff_pressure_deb_fin));
fprintf(1, 'Mean : %f db\n', mean_diff_pressure);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read calibration coefficient
    function [coef] = read_coef(fic_report)   
        fid = fopen(fic_report,'r');
        line = fgets(fid);
        coef = struct('C1', 2, 'C2', [], 'C3', [], 'D1', [], 'D2', [],...
            'T1', [], 'T2', [], 'T3', [], 'T4', [], 'T5', [], 'C', [],...
            'D', [], 'To', []);
        field = ['C1';'C2';'C3';'D1';'D2';'T1';'T2';'T3';'T4';'T5'];
        fin = 0;
        while (fin~=1)
            if ~isempty(strfind(line,'Pressure'))
                for i=1:4
                    line=fgets(fid);
                end
                for i=1:10
                    res=textscan(line,'%s %f', 'delimiter',':');
                    coef.(field(i,:))=res{2};
                    line=fgets(fid);
                end
                fin = 1;
            else
                line = fgets(fid);
            end
        end
        fclose(fid);
    end

%Read pressure temperature
    function [temp_pressure] = read_Tpres(fic_data)     
        fid = fopen(fic_data,'r');
        line = fgets(fid);
        nparam = 2;
        while isempty(strfind(line,'*END'))
            line = fgets(fid);
        end
        data = '';
        for i_param=1:nparam
            data = [data ' %f'];
        end
        res = fscanf(fid, data, [nparam Inf]);
        temp_pressure(1, i_sta) = res(1,1);
        temp_pressure(2, i_sta) = res(1,end);
        fclose(fid);
    end

%Calculate calibration coefficient
    function [coef] = calc_coef(coef, temp_pressure)    
        coef.C = coef.C1 +...
            coef.C2.*temp_pressure(:, i_sta) +...
            coef.C3.*temp_pressure(:, i_sta).^2;
        coef.D = coef.D1 +...
            coef.D2.*temp_pressure(:, i_sta);
        coef.To = coef.T1 +...
            coef.T2*temp_pressure(:, i_sta) +...
            coef.T3.*temp_pressure(:, i_sta).^2 +...
            coef.T4.*temp_pressure(:, i_sta).^3 +...
            coef.T5.*temp_pressure(:, i_sta).^4;
    end

%Read profile start/end pressure frequency
    function [frequency] = read_frequency(fic_hdr)      
        fid = fopen(fic_hdr,'r');
        line = fgets(fid);
        while isempty(strfind(line,'** Bottom Depth'))
            line = fgets(fid);
        end
        for i=1:2
            line = fgets(fid);
            if (~isempty(strfind(line,'before')))
                res = textscan(line,'%s %9.3f','delimiter',':');
                frequency(1, i_sta) = res{2};
            elseif (~isempty(strfind(line,'after')))
                res = textscan(line,'%s %9.3f','delimiter',':');
                frequency(2, i_sta) = res{2};
            elseif (isempty(strfind(line,'before'))) &&...
                    (isempty(strfind(line,'after')))
                frequency(1, i_sta) = NaN;
                frequency(2, i_sta) = NaN;
            end
        end
        frequency(:, i_sta) = frequency(:, i_sta).*10^-6;
        fclose(fid);
    end
end
