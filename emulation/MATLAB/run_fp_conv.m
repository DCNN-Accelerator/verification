% Hussain Khajanchi
% Simple MATLAB script for fixed point SOPU analysis 

%%% 

     % Parameters 
     % img_size    : integer to create a square image array of dims (img_size x img_size) 
     % kernel_size : integer to create a square kernel of size kernel_size x kernel_size
     
     % fp_int_len  : integer specifying the integer length of the fixed point datatype
     % fp_dec_len  : integer specifying the fractional length of the fixed-point datatype (must be less than fp_int_len) 

%%% 


function [fm_actual, fm_fp] = run_fp_conv(img_size, kernel_size, fp_int_len, fp_dec_len); 

    img_orig          = randi(255, img_size, img_size); % Generate a 512x512 array of random integers between 0-255
    kernel_orig       = rand(kernel_size, kernel_size);
    
    
    
    % Compute the ground truth feature map by computing conv2 and casting to integers 
    % in this case, we want to cast it to the nearest integer, so we use the round() function instead of floor() or ceil()
 
    fm_actual = round ( conv2 (img_orig, kernel_orig, 'same') ); 
    
        
    % unsigned binary value specified by the input parameter of 'fp_int_len', going to use 8 for most cases
    img_fp    = fi(img_orig, 0, fp_int_len, 0);  
    
    % casts the kernel to a signed fixed point type of type Q(fp_int_len+fp_dec_len).fp_dec_len
    kernel_fp = fi(kernel_orig, 1, fp_int_len+fp_dec_len, fp_dec_len); 
    
    
    % Calls the FPGA Convolution algorithm to compute the fixed point convolution
    disp ("Calling FPGA convolution...");
    fm_fp = FPGA_Runner (img_fp, kernel_fp, kernel_size, img_size); 
    
    % Convert the 1D stream from FPGA_Runner into a feature map matrix
    
    
%     fm_fp = transpose ( reshape (fm_fp, size(img_orig)) ); 
    
    % Find the maximum deviance between the two results 
    
%     deviance = max ( max ( abs ( fm_fp - fm_actual) ) ) ; 
%     
%     disp ("Maximum deviance of FM_FP and FM_ACTUAL")
%     disp (deviance) 
%     
%     
%     
    
end 