classdef processing < us191.ctd & stat
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        
        %Value Timer
        timer
        
        %Parameters values
        port
        baudRate
        dataBits
        stopBits
        terminator 
        
        %Values in each UIcontrol
        valPort = 1
        valBaudrate = 1
        valDatabits = 1
        valStopbits = 1
        valTerminator = 1
        
    end
    
    properties (Access = private)
        
        configFile = [prefdir, filesep, mfilename, '.mat'];
    end
    
    
    properties (Access = private, SetObservable)
        %Panels
        hdlFig
        hdlMainPanel
        hdlPanelSerial
        hdlPanelMeasure
        hdlPanelTreat
        
        %Panel serial
        hdlTextTimer
        hdlWriteTimer
        hdlTextPort
        hdlSelectPort
        hdlTextDatabits
        hdlSelectDatabits
        hdlTextBaudrate
        hdlSelectBaudrate
        hdlTextStopbits
        hdlSelectStopbits
        hdlTextTerminator
        hdlSelectTerminator
        hdlFrameBox
        hdlTextBox
        hdlCheckboxBefore
        hdlCheckboxAfter
        hdlButtonValid
        
        %Panel measure
        hdlTextLauch
        hdlButtonStart
        hdlButtonStop
        hdlTextPressure
        hdlReadPressure
        hdlUnitPressure
        hdlTextModulo
        hdlReadModulo
        
        %Panel Treatment
        hdlTextMeas
        hdlTextMedian
        hdlReadMedian
        hdlTextVar
        hdlReadVar
        hdlTextMean
        hdlReadMean
        hdlTextStandDev
        hdlReadStandDev 
    end
    
    methods %Public
        
        %Constructor
        function obj = processing(varargin)
            
            obj.hdlFig = figure( ...
                'Name','Processing ',...
                'NumberTitle', 'off', ...
                'MenuBar', 'None',...
                'Toolbar', 'None', ...
                'WindowStyle', 'normal', ...
                'numbertitle', 'off',...
                'HandleVisibility','on',...
                'Position',[100 400 700 620]);
            
            obj.hdlMainPanel = uipanel(obj.hdlFig, ...
                'title', 'Configuration ', ...
                'FontSize',12,...
                'BackgroundColor','white',...
                'position', [0. 0 1 1],...
                'FontWeight', 'bold');
            
            obj.hdlPanelSerial = uipanel('Parent',obj.hdlFig,...
                'Title','Initialisation Serial Port',...
                'FontSize',12,...
                'Position',[0. .6 1 .359],...
                'FontWeight', 'bold');
            
            obj.hdlPanelMeasure =  uipanel('Parent',obj.hdlFig,...
                'Title','Measure',...
                'FontSize',12,...
                'Position',[0. .3 1 .29],...
                'FontWeight', 'bold');
            
            obj.hdlPanelTreat =  uipanel('Parent',obj.hdlFig,...
                'Title','Treatment',...
                'FontSize',12,...
                'Position',[0. .02 1 .25],...
                'FontWeight', 'bold');
            
            loadConfig(obj);
            obj.setUicontrols;
            
            
        end
        
        
        %Destructor
        function closeFig(obj)
            % method save_config
            saveConfig(obj);
            % close figure and listeners
            delete(gcf)
        end
        
        %Fonction set UIcontrol
        %-----------------------------------------------------
        
        function setUicontrols(obj)
            %Uicontrol Panel Serial
            %---------------------------------------------------
            obj.hdlTextTimer = uicontrol( obj.hdlPanelSerial ,...
                'style' , 'Text' ,...
                'Position' , [ 20 120 100 30 ] ,...
                'String' ,' Timer ' ,...
                'FontWeight', 'bold',...
                'FontSize',9 ,...
                'callback', {@(src,evt) Fstat(obj,src)});
            
            obj.hdlWriteTimer = uicontrol ( obj.hdlPanelSerial ,...
                'style' , ' edit' ,...
                'BackGroundcolor','w',...
                'position', [20,100,100,25]);
            
            
            obj.hdlTextPort = uicontrol ( obj.hdlPanelSerial ,...
                'Style' , 'Text' ,...
                'String' ,'Port' ,...
                'Position' ,[190 105 60 80],...
                'FontWeight', 'bold',...
                'FontSize',9);
            
            obj.hdlSelectPort = uicontrol ( obj.hdlPanelSerial ,...
                'Style' , 'popup' ,...
                'String' ,us191.serial.Discover ,...
                'Position' ,[260 160 100 30],...
                'callback', {@(src,evt) selectValPort(obj,src)});
            
            
            obj.hdlTextDatabits = uicontrol ( obj.hdlPanelSerial ,...
                'Style' , 'Text' ,...
                'String' ,'Databits' ,...
                'Position' ,[190 95 60 30],...
                'FontWeight', 'bold',...
                'FontSize',9 );
            
            obj.hdlSelectDatabits = uicontrol ( obj.hdlPanelSerial ,...
                'Style' , 'popup' ,...
                'String' ,'7|8' ,...
                'Value',obj.valDatabits,...
                'Position' ,[260 100 100 30],...
                'callback', {@(src,evt) selectValDatabits(obj,src)}) ;
            
            obj.hdlTextBaudrate = uicontrol ( obj.hdlPanelSerial ,...
                'Style' , 'Text' ,...
                'String' ,'Baudrate' ,...
                'Position' ,[190 125 60 30],...
                'FontWeight', 'bold',...
                'FontSize',9 );
            
            obj.hdlSelectBaudrate = uicontrol ( obj.hdlPanelSerial ,...
                'Style' , 'popup' ,...
                'String' ,'300|600|1200|2400|4800|9600|19200|57600|112000',...
                'Position' ,[260 130 100 30],...
                'Value',obj.valBaudrate,...
                'callback', {@(src,evt) selectValBaudrate(obj,src)});
            
            obj.hdlTextStopbits = uicontrol ( obj.hdlPanelSerial ,...
                'Style' , 'Text' ,...
                'String' ,'Stopbits' , ...
                'Position', [190 20 60 80],...
                'FontWeight', 'bold',...
                'FontSize',9 );
            
            obj.hdlSelectStopbits = uicontrol ( obj.hdlPanelSerial ,...
                'Style' , 'popup' ,...
                'String' ,'1|2' ,...
                'Value',obj.valStopbits,...
                'Position' ,[260 70 100 30],...
                'callback', {@(src,evt) selectValStopbits(obj,src)});
            
            obj.hdlTextTerminator = uicontrol ( obj.hdlPanelSerial ,...
                'Style' , 'Text' ,...
                'String' ,'Terminator' ,...
                'Position' ,[185 0 65 70],...
                'FontWeight', 'bold',...
                'FontSize',9 );
            
            obj.hdlSelectTerminator = uicontrol ( obj.hdlPanelSerial ,...
                'Style' , 'popup' ,...
                'String' ,'CR|LF|CR/LF' ,...
                'Value',obj.valTerminator,...
                'Position' ,[260 40 100 30],...
                'callback', {@(src,evt) selectValTerminator(obj,src)} );
            
            %ButtonValid
            obj.hdlButtonValid = uicontrol (obj.hdlPanelSerial ,...
                'style' , 'push' ,...
                'position' , [400 90 60 50 ] ,...
                'FontWeight', 'bold',...
                'string' , 'VALID',...
                'callback', @ValidParSerial);
            
            %CheckBox
            obj.hdlFrameBox = uicontrol ( obj.hdlPanelSerial ,...
                'style' , 'frame' ,...
                'position' , [500,80,140,90]);
            
            obj.hdlTextBox = uicontrol( obj.hdlPanelSerial ,...
                'style' , 'Text' ,...
                'Position' , [510 135 110 25 ] ,...
                'String' ,' Check Box ' ,...
                'FontWeight', 'bold',...
                'FontSize',11);
            
            obj.hdlCheckboxBefore = uicontrol( obj.hdlPanelSerial ,...
                'style' , 'checkbox' ,...
                'Position', [ 510 110 110 25 ] ,...
                'String' , ' Before ',...
                'FontSize',10);
            
            obj.hdlCheckboxAfter = uicontrol( obj.hdlPanelSerial , ...
                'style' , 'checkbox' ,...
                'Position' ,[ 510 85 110 25 ] ,...
                'String' , ' After ',...
                'FontSize',10);
            
            %Uicontrol Panel Measure
            %-------------------------------------------------
            
            %Start/Stop
            obj.hdlTextLauch = uicontrol(obj.hdlPanelMeasure ,...
                'style' , 'Text' , ...
                'Position' , [ 150 100 100 30 ] ,...
                'String' ,' Launch / Stop ' ,...
                'FontWeight', 'bold',...
                'FontSize',10  );
            
            obj.hdlButtonStart = uicontrol (obj.hdlPanelMeasure ,...
                'style' , 'push' ,...
                'position' , [115 30 60 50 ] ,...
                'string' , 'START',...
                'FontWeight', 'bold',...
                'callback', @open);

            obj.hdlButtonStop = uicontrol (obj.hdlPanelMeasure ,...
                'style' , 'push' ,...
                'position' , [210 30 60 50 ] ,...
                'string' , 'STOP',...
                'FontWeight', 'bold',...
                'callback', @close);

            
            obj.hdlTextMeas = uicontrol(obj.hdlPanelMeasure ,...
                'style' , 'Text' ,...
                'Position' , [ 350 120 200 30 ] ,...
                'String' ,' Measures in real time ' ,...
                'FontWeight', 'bold',...
                'FontSize',10);
            
            obj.hdlTextPressure = uicontrol( obj.hdlPanelMeasure ,...
                'style' , 'Text' ,...
                'Position' , [400 90 100 30 ] ,...
                'String' ,' Pressure ' ,...
                'FontWeight', 'bold',...
                'FontSize',10);
            
            obj.hdlReadPressure = uicontrol ( obj.hdlPanelMeasure ,...
                'style' , ' text' ,...
                'String', obj.pressure,...
                'position', [400,75,100,25] ...
                ,'BackGroundcolor','w' );
            
            
            obj.hdlUnitPressure = uicontrol( obj.hdlPanelMeasure ,...
                'style' , 'Text' ,...
                'Position' , [ 500 80 50 15 ] ,...
                'String' ,' db ' ,...
                'FontWeight', 'bold',...
                'FontSize',10);
            
            
            obj.hdlTextModulo = uicontrol( obj.hdlPanelMeasure  ,...
                'style' , 'Text' ,...
                'Position' , [ 400 40 100 30 ] ,...
                'String' ,' Modulo ' ,...
                'FontWeight', 'bold',...
                'FontSize',10);
            
            obj.hdlReadModulo = uicontrol ( obj.hdlPanelMeasure  ,...
                'style' , ' text' ,...
                'String',obj.modulo,...
                'position', [400,25,100,25] ,...
                'BackGroundcolor','w' );
            
            %Uicontrol Panel Treat
            %-------------------------------------------------
            obj.hdlTextMeas = uicontrol( obj.hdlPanelTreat ,...
                'style' , 'Text' ,...
                'Position' , [ 350 130 200 30 ] ,...
                'String' ,' Measures in real time ' ,...
                'FontWeight', 'bold', 'FontSize',10  );
            
            obj.hdlTextMean = uicontrol( obj.hdlPanelTreat  ,...
                'style' , 'Text' ,...
                'position',[ 15 80 100 30 ] ,...
                'String' ,' Mean ' ,...
                'FontWeight', 'bold',...
                'FontSize',10);
            
            obj.hdlReadMean = uicontrol ( obj.hdlPanelTreat ,...
                'style' , 'Text' ,...
                'String',obj.average,...
                'BackGroundcolor','w',...
                'position' , [20 60 90 25 ] );
            
            obj.hdlTextVar = uicontrol( obj.hdlPanelTreat  ,...
                'style' , 'Text' , ...
                'Position' ,[ 180 80 100 30 ] ,...
                'String' ,' Variance ' ,...
                'FontWeight', 'bold',...
                'FontSize',10 );
            
            obj.hdlReadVar = uicontrol ( obj.hdlPanelTreat ,...
                'style' , 'Text' ,...
                'BackGroundcolor','w',...
                'String',obj.variance,...
                'position' , [180 60 90 25 ]  );
            
            obj.hdlTextMedian = uicontrol( obj.hdlPanelTreat  ,...
                'style' , 'Text' ,...
                'Position', [ 340 80 100 30 ] ,...
                'String' ,' Median ' ,...
                'FontWeight', 'bold',...
                'FontSize',10 );
            
            obj.hdlReadMedian = uicontrol ( obj.hdlPanelTreat ,...
                'style' , 'Text' ,...
                'String',obj.med,...
                'BackGroundcolor','w',...
                'position' , [345 60 90 25 ]);
            
            obj.hdlTextStandDev = uicontrol( obj.hdlPanelTreat  ,...
                'style' , 'Text' ,...
                'Position' ,[ 500 80 130 30 ] ,...
                'String' ,' Standard deviation ' ,...
                'FontWeight', 'bold',...
                'FontSize',10 );
            
            obj.hdlReadStandDev = uicontrol ( obj.hdlPanelTreat ,...
                'style' , 'Text' ,...
                'BackGroundcolor','w',...
                'position' , [520 60 90 25 ]);          
            
        end % end of setUicontrols
        
        %Callback Parameters Serial
        %-----------------------------
        
             
        function selectValPort(obj, src)
            p = us191.serial.Discover;
            obj.valPort =  get(src, 'Value');
            obj.port =  p(obj.valPort);
        end
        
        function selectValDatabits(obj, src)
            obj.valDatabits =  get(src, 'value');
            switch obj.valDatabits
                case 1
                    obj.dataBits = {'7'};
                case 2
                    obj.dataBits = {'8'};
                otherwise
                    error('process:defDatabits',...
                        'Invalid dataBits value : %d.', ...
                        obj.dataBits);
            end
        end
        
        function selectValBaudrate(obj, src)
            obj.valBaudrate =  get(src, 'value');
            switch obj.valBaudrate
                case 1
                    obj.baudRate = {'300'};
                case 2
                    obj.baudRate = {'600'};
                case 3
                    obj.baudRate = {'1200'};
                case 4
                    obj.baudRate = {'2400'};
                case 5
                    obj.baudRate = {'4800'};
                case 6
                    obj.baudRate = {'9600'};
                case 7
                    obj.baudRate = {'19200'};
                case 8
                    obj.baudRate = {'57600'};
                case 9
                    obj.baudRate = {'112000'};
                    
                otherwise
                    error('process:defBaudRate',...
                        'Invalid baudRate value : %d.', ...
                        obj.baudRate);
            end
            
        end
        
        function selectValStopbits(obj, src)
            obj.valStopbits =  get(src, 'value');
            switch obj.valStopbits
                case 1
                    obj.stopBits = {'1'};
                case 2
                    obj.stopBits = {'2'};
                    
                otherwise
                    error('process:defStopbits',...
                        'Invalid baudRate value : %d.', ...
                        obj.stopBits);
            end
        end
        
        function selectValTerminator(obj, src)
            obj.valTerminator =  get(src, 'value');
            switch obj.valTerminator
                case 1
                    obj.terminator = {'CR'};
                case 2
                    obj.terminator = {'LF'};
                case 3
                    obj.terminator = {'CR/LF'};
                    
                otherwise
                    error('process:defTerminator',...
                        'Invalid dataBits value : %s.', ...
                        obj.terminator);
            end
            
        end
        
        %Callback Measures
        %-----------------------------
        
        function validParSerial(obj)
            
           validParSerial@us191.ctd('1263.xml', obj.port,...
               'BaudRate',obj.baudRate,...
               'DataBits',obj.dataBits,...
               'StopBits',obj.stopBits,...
               'Terminator',obj.terminator);
        end 
   
        function open(obj)
           %Get date in all file name
           FileName = datestr(now);
           obj.rawFileName = fprintf('%s.hex',FileName) ;
           obj.dataFileName = fprintf('%s.cnv',FileName) ;
           obj.dataName = fprintf('%s.cnv',FileName);
           obj.statFileName = fprintf('%s.mat',FileName);
           
           %Start acquisition
           open@us191.ctd(obj)
           
           %Start Timer
           obj.timer =  str2double(get(obj.hdlWriteTimer, 'String'));
            for i = obj.timer : -1 : 0
                obj.timer = obj.timer -1;
                pause(1)
                set(obj.hdlWriteTimer,'String',obj.timer);
            end
                
        end 
        
        function close(obj)
           close@us191.ctd(obj)
        end       
        
        function s = saveConfig(obj)
            
            % save property values in struct
            s.port = obj.port;
            s.baudRate = obj.baudRate;
            s.dataBits = obj.dataBits;
            s.stopBits = obj.stopBits;
            s.terminator = obj.terminator;
            
            s.valPort = obj.valPort;
            s.valBaudrate = obj.valBaudrate;
            s.valDatabits = obj.valDatabits;
            s.valStopbits = obj.valStopbits;
            s.valTerminator = obj.valTerminator;
            
            save( obj.configFile, 's', '-v7.3')
            
        end % end of saveConfig
        
        function loadConfig(obj)
            
            % create a struct from public properties of the class
            theConfig = saveToStruct(obj);
            
            % test if configFile exist
            if exist(obj.configFile, 'file') == 2
                % load properties values from struct
                load(obj.configFile, 's');
                props = fieldnames(theConfig);
                for p = 1:numel(props)
                    if  isfield(s, props{p})
                        obj.(props{p}) = s.(props{p});
                    end
                end
            end
            
        end % end of loadConfig
    end
    
    methods (Access = private)
        
        % use this function instead of struct(obj)
        % ----------------------------------------
        function s = saveToStruct(obj)
            props = properties(obj);
            for p = 1:numel(props)
                s.(props{p}) = obj.(props{p});
            end
        end % end of saveToStruct
        
       
    end % end of  private methods
    
    
end

