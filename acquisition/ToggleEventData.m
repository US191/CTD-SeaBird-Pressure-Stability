classdef (ConstructOnLoad) ToggleEventData < event.EventData
    % Define Event-Specific Data
    % Suppose that you want to pass the state of the toggle button as a result
    % of the event to the listener callback. You can add more data to the
    % default event data by subclassing the event.EventData class and adding
    % a property to contain this information. Then you can pass this object
    % to the handle.notify method.
    %
    % This class is use to pass parameters from ctd class to acquisition
    properties
        pressure
        temperature
        modulo
        frequency
    end
    
    methods
        function data = ToggleEventData(pressure,temperature,modulo, frequency)
            data.pressure = pressure;
            data.temperature = temperature;
            data.modulo = modulo;
            data.frequency = frequency;
        end
    end
end

