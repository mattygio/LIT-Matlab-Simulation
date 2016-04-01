% PROGRAMMERS: Frederick Wachter, Harrison Katz
% DATE CREATED: 03-12-2016 | LAST MODIFIED: 03-12-2016

classdef controller < handle
    
    properties %(SetAccess = protected)
        
        location % Array location of controlled elements
        height % Heights of controlled elements
        setHeight
        setpoint
        color % LED colors of controlled elements
        simulation
        data
        
    end
    
    properties (Constant = true)
        
        TOTAL_BALLS = 4; % Total controlled elements
        SPLINE_A = 2;
     
    end
    
    %% CONSTRUCTOR METHOD
    
    methods
        
        function arduinoObject = controller
            
            arduinoObject.location  = zeros(arduinoObject.TOTAL_BALLS,2);
            arduinoObject.height    = zeros(arduinoObject.TOTAL_BALLS,1);
            arduinoObject.setHeight = zeros(arduinoObject.TOTAL_BALLS,1);
            arduinoObject.setpoint  = zeros(arduinoObject.TOTAL_BALLS,1);
            arduinoObject.color     = zeros(arduinoObject.TOTAL_BALLS,3);
            
            arduinoObject.simulation.a = arduinoObject.SPLINE_A;
            arduinoObject.simulation.handle = 0;
            arduinoObject.simulation.lineHandle = zeros(arduinoObject.TOTAL_BALLS,1);
            
            arduinoObject.data.stepSize = 0.01;
            arduinoObject.data.linHeights = zeros(0,0);
            arduinoObject.data.time = zeros(0,0);
            arduinoObject.data.notFirstRun = 0;
            
        end
    
    end
    
    %% OTHER METHODS
    
    methods
        
        function initializeObjects(arduinoObject)
        % EXAMPLE FUNCTION CALL: arduinoObject.setupLocations(balls,locations);
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-16-2016
        % LAST MODIFIED: 03-16-2016
        % PURPOSE: Initializes all balls into simulation
        % TYPE: Public Method
        % COMMENTS: Simulation Function
            
            arduinoObject.simulation.handle = scatter3(arduinoObject.location(:,1),arduinoObject.location(:,2),arduinoObject.setHeight,'LineWidth',4);
            for i = 1:arduinoObject.TOTAL_BALLS
                arduinoObject.simulation.lineHandle(i) = line([arduinoObject.location(i,1),arduinoObject.location(i,1)],[arduinoObject.location(i,2),arduinoObject.location(i,2)],[0,arduinoObject.setHeight(i)],'LineWidth',0.1);
            end
            
        end
        
        function setSetpoint(arduinoObject,f,totalTime)
        % EXAMPLE FUNCTION CALL: setSetpoint(f,totalTime);
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-16-2016
        % LAST MODIFIED: 03-16-2016
        % PURPOSE: Sets the position function for ball height at given time
        % TYPE: Public Method
        % COMMENTS: Simulation Function
            
            arduinoObject.setpoint = f(arduinoObject.location(:,1),arduinoObject.location(:,2));
            initial = arduinoObject.setHeight; endpoint = arduinoObject.setpoint; linearity = arduinoObject.SPLINE_A;
            arduinoObject.simulation.spline = @(time)(((endpoint-initial).*((time./totalTime).^linearity./((time./totalTime).^linearity+(1-(time./totalTime)).^linearity)))+initial);
            arduinoObject.getLinearData(totalTime);
            
        end
        
        function updatePositions(arduinoObject,time)
        % EXAMPLE FUNCTION CALL: updatePositions(time);
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-16-2016
        % LAST MODIFIED: 03-16-2016
        % PURPOSE: Updates positions of the balls for inputted time
        % TYPE: Public Method
        % COMMENTS: Simulation Function
            
            arduinoObject.height = arduinoObject.simulation.spline(time);
            set(arduinoObject.simulation.handle,'ZData',arduinoObject.height);
            for i = 1:arduinoObject.TOTAL_BALLS
                set(arduinoObject.simulation.lineHandle(i),'ZData',[0,arduinoObject.height(i)]);
            end
            
        end
        
        function getLinearData(arduinoObject,totalTime)
        % EXAMPLE FUNCTION CALL: getLinearData(totalTime);
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-16-2016
        % LAST MODIFIED: 03-16-2016
        % PURPOSE: Generates linear data for exporting
        % TYPE: Public Method
        % COMMENTS: Simulation Function
            
            steps = (totalTime/arduinoObject.data.stepSize)+1;
            time = linspace(0,totalTime,round(steps));
            
            tempData = arduinoObject.data.linHeights;
            arduinoObject.data.notFirstRun(size(tempData,2) ~= 0) = 1;
            newSize = size(tempData,2)+steps-arduinoObject.data.notFirstRun;
            arduinoObject.data.time = linspace(0,(newSize-1)*arduinoObject.data.stepSize,newSize);
            arduinoObject.data.linHeights = zeros(arduinoObject.TOTAL_BALLS,newSize);
            if (size(tempData,2) ~= 0)
                arduinoObject.data.linHeights(:,1:size(tempData,2)) = tempData;
            end
            for i = (1+arduinoObject.data.notFirstRun):steps
                arduinoObject.data.linHeights(:,size(tempData,2)+(i-arduinoObject.data.notFirstRun)) = arduinoObject.simulation.spline(time(i));
            end
            
            if (mod(steps,1) ~= 0)
                warning('Output data does not include upperbound, ensure inputted time does not exeed the hundreths place.');
            end
            
        end
        
        function setupLocations(arduinoObject,balls,locations)
        % EXAMPLE FUNCTION CALL: arduinoObject.setupLocations(balls,locations);
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-12-2016
        % LAST MODIFIED: 03-12-2016
        % PURPOSE: Setup array locations of balls controlled
        % TYPE: Public Method
        
            arduinoObject.location(balls,:) = locations;
        
        end
        
        function resetPosition(arduinoObject,balls)
        % EXAMPLE FUNCTION CALL: arduinoObject.resetPosition(balls);
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-12-2016
        % LAST MODIFIED: 03-12-2016
        % PURPOSE: Resets the locations of the specified balls
        % TYPE: Public Method
           
            %---------- SEND BALLS TO TOP IN REALITY ----------
            arduinoObject.height(balls) = 0;
            
        end
        
        function changeColors(arduinoObject,balls,colors)
        % EXAMPLE FUNCTION CALL: arduinoObject.changeColors(balls,colors);
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-12-2016
        % LAST MODIFIED: 03-12-2016
        % PURPOSE: Changes the colors of the specified balls
        % TYPE: Public Method
            
            arduinoObject.colors(balls,:) = colors;
            
        end
        
    end
    
end

