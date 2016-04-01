% PROGRAMMERS: Frederick Wachter, Harrison Katz
% DATE CREATED: 03-12-2016 | LAST MODIFIED: 03-12-2016

classdef simulation < handle
    
    properties %(SetAccess = protected)
        
        figure
        arduino
        simData
        
    end
    
    properties (Constant = true)
        
    end
    
    %% CONSTRUCTOR METHOD
    
    methods
        
        function simulationObject = simulation(rows,cols,orientation)
            
            simulationObject.figure.handle = figure('Name','Simulation','NumberTitle','off');
            simulationObject.figure.axes = axes;
            simulationObject.setFigureProperties(rows,cols);
            
            simulationObject.arduino.rows = rows;
            simulationObject.arduino.cols = cols;
            simulationObject.arduino.total = rows*cols;
            simulationObject.arduino.orientation = orientation;
            
            simulationObject.simData.handle = -1;
            simulationObject.simData.dataReady = 0;
            simulationObject.simData.position.min = 0;
            simulationObject.simData.position.max = 0;
            simulationObject.simData.position.handle = -1;
            simulationObject.simData.velocity.min = 0;
            simulationObject.simData.velocity.max = 0;
            simulationObject.simData.velocity.handle = -1;
            simulationObject.simData.acceleration.min = 0;
            simulationObject.simData.acceleration.max = 0;
            simulationObject.simData.acceleration.handle = -1;
            
            simulationObject.initializeArduinos(rows,cols,orientation);
            
        end
    
    end
    
    %% OTHER METHODS
    
    methods
        
        function setFigureProperties(simulationObject,rows,cols)
        % EXAMPLE FUNCTION CALL: simulationObject.setFigureProperties(rows,cols);
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-12-2016
        % LAST MODIFIED: 03-12-2016
        % PURPOSE: Set the figure
        % TYPE: Public Method
           
            hold on;
            view(3);
            rotate3d;
            axis equal;
            xlabel('X Axis');
            ylabel('Y Axis');
            zlabel('Z Axis');
            title('Simluation');
            xlim([-1,(rows*2)+2]);
            ylim([-1,(cols*2)+2]);
            zlim([-15,5]);
            
        end
        
        function initializeArduinos(simulationObject,rows,cols,orientation)
        % EXAMPLE FUNCTION CALL: initializeArduinos(rows,cols,orientation);
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-22-2016
        % LAST MODIFIED: 03-22-2016
        % PURPOSE: Setup Arduino objects
        % TYPE: Public Method
        
            if (orientation == 1)
                ballNumbers = 1:4;
                x = [1,2,1,2];
                y = [1,1,2,2];
            end
            
            for row = 1:rows
                for col = 1:cols
                    currentArduino = ((row-1)*4)+col;
                    simulationObject.arduino.handle(currentArduino) = controller;
                    arduinoLocations = [(x+(2*(row-1)))',(y+(2*(col-1)))'];
                    simulationObject.arduino.handle(currentArduino).setupLocations(ballNumbers,arduinoLocations);
                    simulationObject.arduino.handle(currentArduino).initializeObjects();
                end
            end
            
        end
        
        function moveArduinos(simulationObject,f,time)
        % EXAMPLE FUNCTION CALL: moveArduinos(f,time);
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-22-2016
        % LAST MODIFIED: 03-22-2016
        % PURPOSE: Move arduino according to input function for designated time input
        % TYPE: Public Method
            
            simulationObject.setArduinoFunction(f,time);
            
            tic;
            while (toc < time)
                for currentArduino = 1:simulationObject.arduino.total
                    simulationObject.arduino.handle(currentArduino).updatePositions(toc);
                end
                drawnow;
            end
            
            simulationObject.updateArduinoPosition(time);
            
        end
            
        function setArduinoFunction(simulationObject,f,time)
        % EXAMPLE FUNCTION CALL: setArduinoFunction(f,time);
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-22-2016
        % LAST MODIFIED: 03-22-2016
        % PURPOSE: Setup function for Arduinos to run
        % TYPE: Public Method
            
            if (simulationObject.simData.dataReady == 0)
                simulationObject.simData.dataReady = 1;
            end
            for currentArduino = 1:simulationObject.arduino.total
                simulationObject.arduino.handle(currentArduino).setSetpoint(f,time);
            end
            
        end
        
        function updateArduinoPosition(simulationObject,time)
        % EXAMPLE FUNCTION CALL: updateArduinoPosition(time);
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-22-2016
        % LAST MODIFIED: 03-22-2016
        % PURPOSE: Update the position of the arduino after running a function
        % TYPE: Public Method
            
            for currentArduino = 1:simulationObject.arduino.total
                simulationObject.arduino.handle(currentArduino).updatePositions(time);
                simulationObject.arduino.handle(currentArduino).setHeight = simulationObject.arduino.handle(currentArduino).height;
            end
            
        end
        
        function resetArduinoPositions(simulationObject,time)
        % EXAMPLE FUNCTION CALL: updateArduinoPosition(time);
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-22-2016
        % LAST MODIFIED: 03-22-2016
        % PURPOSE: Update the position of the arduino after running a function
        % TYPE: Public Method
            
            f = @(x,y)(0);
            simulationObject.setArduinoFunction(f,time);
            
            tic;
            while (toc < time)
                for currentArduino = 1:simulationObject.arduino.total
                    simulationObject.arduino.handle(currentArduino).updatePositions(toc);
                end
                drawnow;
            end
            
            simulationObject.updateArduinoPosition(time);
            
        end
        
        function displaySimProperties(simulationObject)
        % EXAMPLE FUNCTION CALL: displaySimProperties();
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-22-2016
        % LAST MODIFIED: 04-01-2016
        % UPDATES: 04-01-2016 | Plot was not being used properly
        % PURPOSE: Display properties from the simulation
        % TYPE: Public Method
            
            simulationObject.getSimProperties();
            if (~ishandle(simulationObject.simData.position.handle) || ~ishandle(simulationObject.simData.velocity.handle) || ~ishandle(simulationObject.simData.acceleration.handle))
                simulationObject.initializeSimPropertiesFigures();
            end
            
            time = simulationObject.arduino.handle(1).data.time;
            subplot(simulationObject.simData.position.handle); plot(time,simulationObject.simData.position.data);
            subplot(simulationObject.simData.velocity.handle); plot(time,simulationObject.simData.velocity.data); hold on;
            subplot(simulationObject.simData.acceleration.handle); plot(time,simulationObject.simData.acceleration.data); hold on;
            drawnow;
            
            fprintf('--------------- SimulationProperties ---------------\n      Max Height: %0.4f |      Min Height: %0.4f\n    Max Veloicty: %0.4f |     Min Velocity: %0.4f\nMax Aceeleration: %0.4f | Min Acceleration: %0.4f\n',simulationObject.simData.position.max,simulationObject.simData.position.min,simulationObject.simData.velocity.max,simulationObject.simData.velocity.min,simulationObject.simData.acceleration.max,simulationObject.simData.acceleration.min);
            
        end
        
        function initializeSimPropertiesFigures(simulationObject)
        % EXAMPLE FUNCTION CALL: initializeSimPropertiesFigures();
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-22-2016
        % LAST MODIFIED: 04-01-2016
        % UPDATES: 04-01-2016 | Changed from multiple figures to one figure with subplots
        % PURPOSE: Initialized the figures for displaying the simulation properties
        % TYPE: Public Method

            simulationObject.simData.handle = figure('Name','Simulation Plot Data','NumberTitle','off');
            simulationObject.simData.position.handle = subplot(212); hold on; title('Position Plot'); xlabel('Time (s)'); ylabel('Position');
            simulationObject.simData.velocity.handle = subplot(221); hold on; title('Velocity Plot'); xlabel('Time (s)'); ylabel('Position');
            simulationObject.simData.acceleration.handle = subplot(222); hold on; title('Acceleration Plot'); xlabel('Time (s)'); ylabel('Position');
            
        end
        
        function getSimProperties(simulationObject)
        % EXAMPLE FUNCTION CALL: getSimProperties();
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-22-2016
        % LAST MODIFIED: 04-01-2016
        % UPDATES: 04-01-2016 | Made mistake on storing data in for loop, updated to inlcude all of the balls instead of just the arduinos
        % PURPOSE: Gets the arduino ball positions, velocities, and accelerations
        % TYPE: Public Method

            simulationObject.simData.position.data = zeros(simulationObject.arduino.total,length(simulationObject.arduino.handle(1).data.linHeights(1,:)));
            simulationObject.simData.velocity.data = zeros(simulationObject.arduino.total,size(simulationObject.simData.position.data,2));
            simulationObject.simData.acceleration.data = zeros(simulationObject.arduino.total,size(simulationObject.simData.position.data,2));
        
            for currentArduino = 1:simulationObject.arduino.total
                for currentBall = 1:simulationObject.arduino.handle(1).TOTAL_BALLS
                    simulationObject.simData.position.data(((currentArduino-1)*4)+currentBall,:) = simulationObject.arduino.handle(currentArduino).data.linHeights(currentBall,:);
                    simulationObject.simData.velocity.data(((currentArduino-1)*4)+currentBall,:) = gradient(simulationObject.simData.position.data(((currentArduino-1)*4)+currentBall,:));
                    simulationObject.simData.acceleration.data(((currentArduino-1)*4)+currentBall,:) = gradient(simulationObject.simData.velocity.data(((currentArduino-1)*4)+currentBall,:));
                end
            end
            
            simulationObject.simData.position.max = max(max(simulationObject.simData.position.data));
            simulationObject.simData.position.min = min(min(simulationObject.simData.position.data));
            simulationObject.simData.velocity.max = max(max(simulationObject.simData.velocity.data));
            simulationObject.simData.velocity.min = min(min(simulationObject.simData.velocity.data));
            simulationObject.simData.acceleration.max = max(max(simulationObject.simData.acceleration.data));
            simulationObject.simData.acceleration.min = min(min(simulationObject.simData.acceleration.data));
            
            drawnow;
            
        end
        
        function exportHeightData(simulationObject,scaleFactor)
        % EXAMPLE FUNCTION CALL: exportHeightData(scaleFactor);
        % PROGRAMMER: Frederick Wachter
        % DATE CREATED: 03-22-2016
        % LAST MODIFIED: 03-22-2016
        % PURPOSE: Exports ball position data as a .csv into user desired folder
        % TYPE: Public Method
            
            if (simulationObject.simData.dataReady == 0)
                error('The simulation does not have any data to export.');
            end
            
            location = uigetdir;
            if (location ~= 0)
                cd(location);
            
                fprintf('Export in progress. Please wait... ');

                time = simulationObject.arduino.handle(1).data.time;

                adj = 0;
                if (simulationObject.arduino.orientation == 1)
                    for currentRow = 1:(simulationObject.arduino.rows*2)
                        for currentArduinoCol = 1:simulationObject.arduino.cols
                            if (mod(currentRow,2) == 0)
                                set = [2,4];
                            else
                                set = [1,3];
                            end
                            for k = 1:2
                                height = (simulationObject.arduino.handle(currentArduinoCol+adj).data.linHeights(set(k),:))*scaleFactor;

                                ball = (currentRow-1)*(simulationObject.arduino.cols*2) + ((currentArduinoCol-1)*2) + k;
                                fileName = ['Ball',num2str(ball),'.csv'];
                                csvwrite(fileName,[time',(-height)']);
                            end
                        end
                        if (mod(currentRow,2) == 0)
                            adj = adj + simulationObject.arduino.cols;
                        end
                    end
                end

                fprintf('Export finished.\n');
            end
            
        end
        
    end
    
end

