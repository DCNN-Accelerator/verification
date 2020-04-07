%% createUARTStream.m Header

% Hussain Khajanchi 
% DCNN Senior Project 
% 
% MATLAB Verification

% Description: Creates a UART stream with kernel and pixel data




%% MATLAB Code

function[uartStream] =  createUARTStream(image_array, kernel_array)

% Create a 1D array to hold all the elements of the image and kernel arrays
% The numel() function gets the total number of elements in an array data type in MATLAB, which is nice for creating a 1D row vector to hold those said elements

uartStreamSize = (numel(image_array) + numel(kernel_array)); 
uartStream     = zeros(uartStreamSize,1); 


uartStream( 1:numel(kernel_array),: )                = reshape(kernel_array',numel(kernel_array),1); 

uartStream( numel(kernel_array)+1:uartStreamSize,: ) = reshape(image_array' ,numel(image_array),1); 



end 