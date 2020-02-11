%% ILB.m

% Hussain Khajanchi 
% DCNN Senior Project 
% 
% MATLAB Verification

% ILB Class Definition File 

% This class implements Integrated Line Buffer functionality for software emulation. This module contains an array of data that contains pixel data for reuse by the
% SoPU. 

% Class Members: 
%     - ILB_ARRAY     : the storage module for holding local pixel data
%     - ILB_WRITE_ROW : current overwrite row - also row "0" that gets transmitted to the Image Window
%     - ILB_COL_PTR   : current column pointer within the specified ILB line
%     - ILB_MAX_ROWS  : the max number of rows in the ILB, useful for indexing for read/write methods
%     - ILB_MAX_COLS  : the max number of cols in the ILB, useful for indexing for read/write methods

%% Class Definition MATLAB code

classdef ILB
    
    properties 
        ILB_ARRAY
        
        ILB_WRITE_ROW
        ILB_COL_PTR
        
        ILB_MAX_ROWS 
        ILB_MAX_COLS
    end 
    
    
    methods 
        
        % Constructor for ILB object - defines a NUM_BUFFERS x BUFFER_WIDTH array as the ILB_ARRAY member, and initializes all of the ILB pointers to zero (or 1 for MATLAB indexing) 
        
        function obj = ILB(NUM_BUF, BUF_WIDTH)
            
            obj.ILB_ARRAY     = zeros([NUM_BUF BUF_WIDTH]); 
            
            obj.ILB_WRITE_ROW = 1; 
            obj.ILB_COL_PTR   = 1;
            
            obj.ILB_MAX_ROWS = NUM_BUF; 
            obj.ILB_MAX_COLS = BUF_WIDTH; 
            
        end 
        
        
        % Write function for ILB -- writes to the location in obj.ILB_ARRAY specified by obj.ILB_WRITE_ROW and obj.ILB_COL_PTR with the byte specified by input byte
        
        function obj = writeByte(obj,inputByte)
            
            obj.ILB_ARRAY(obj.ILB_WRITE_ROW, obj.ILB_COL_PTR) = inputByte; 
            
            % Logic to increment the write row ptr and write col ptr and to modulate as necessary 
            
            % If the column pointer is at the end of the row, go to the next row
            %    -- if the row pointer is at the last row, start back at the first row circular-array style
            
            if (obj.ILB_COL_PTR == obj.ILB_MAX_COLS)
                
                obj.ILB_COL_PTR = 1; %reset col ptr to "1", or MATLAB's zero index
                
                if (obj.ILB_WRITE_ROW == obj.ILB_MAX_ROWS)
                    obj.ILB_WRITE_ROW = 1; % also the new "zero" row that the SoPU will read, and the new overwrite row
                else
                    obj.ILB_WRITE_ROW = obj.ILB_WRITE_ROW + 1;
                end 
                
            else
                obj.ILB_COL_PTR = obj.ILB_COL_PTR + 1; 
                
            end
            
        end 
        
        
        function returnPixels = readBytes(obj)
            
            % Get the corresponding set of pixels starting at the "zeroth" row, or whichever row the ILB is currently writing to 
            % returnPixels is a (NUM_BUFS, 1) size column vector that will get shifted into the SoPU's image window 
            
            returnPixels = zeros( [obj.ILB_MAX_ROWS 1] ); 
            
            
            % Use circular array shifting to get all the column values starting from the ILB's "Zero" row, or the current write row 
            rowPtr   = obj.ILB_WRITE_ROW;
            colPtr   = obj.ILB_COL_PTR;
            
            iterator = rowPtr;
            
            
            arrayLen = obj.ILB_MAX_ROWS;
        
            outputIndex = 1; 
            
            while iterator < rowPtr + arrayLen
                
                modIdx = mod(iterator, arrayLen); 
                
                if (modIdx == 0) 
                    modIdx = arrayLen; 
                else 
                    modIdx = modIdx; 
                end 
                
                returnPixels(outputIndex) = obj.ILB_ARRAY(modIdx, colPtr); 
                
                iterator      = iterator + 1; 
                outputIndex   = outputIndex + 1;
                
                
            end 
            
                       
        end 
        

    end 
     
end 