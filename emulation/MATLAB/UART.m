%% UART.m

% Hussain Khajanchi
% DCNN Senior Project 

% UART Emulator class file 

%% MATLAB Class Implementation

classdef UART 
    
    properties 
        
        uart_stream
        
        UART_MAX
        
        readPtr
        writePtr
        
    end 
    
    methods
        
        % Default Constructor - takes in two arrays for image and kernel values 
        % and calls the createUARTStream function to build a 1D UART array
        
        % Since MATLAB doesn't allow multiple constructors, if you want to create an empty UART stream 
        % (say for an output UART stream), send two arrays with the output specs you want with zeros as the
        % elements
        
        % i.e IMG = zeros(DIM1, DIM2) | KERNEL = zeros(DIM1,DIM2), etc. 
        
        function obj = UART(IMG, KERNEL)
            
            
            obj.uart_stream = createUARTStream(IMG, KERNEL); 
            
            obj.UART_MAX    = size(obj.uart_stream,1); 
            
            obj.readPtr     = 1; 
            obj.writePtr    = 1; 
            
            
        end 
        
        % Returns the byte at the current readPtr location, doesn't check for valid indices
        function returnByte = readByte(obj)
                        
            returnByte = obj.uart_stream(obj.readPtr); 
            
        end 
        
        % Increments the UART read pointer, checks for valid indices (split from returnByte function)
        function obj = incrementReadPtr(obj)
            
            assert( ~ (obj.readPtr > obj.UART_MAX),'Invalid UART index!');
            
            obj.readPtr = obj.readPtr + 1; 
            
        end 
        
        % Writes a byte into the uart stream array, with the index specified by uart.writePtr
        % Does index checking to avoid invalid writes 
        function obj = writeByte(obj, inputByte)
            
            assert( ~ (obj.writePtr > obj.UART_MAX), 'Invalid UART Index!'); 
            
            obj.uart_stream(obj.writePtr) = inputByte; 
            
            obj.writePtr = obj.writePtr + 1; 
            
            
        end 
        
        
        
        
        
        
    end 
    
    
    
end 