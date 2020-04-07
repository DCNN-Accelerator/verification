
% FPGA Tester script

function [pass] = FPGA_Tester(img_path, kernel_path)

%%%
    % Testing Script that loads in an image, and computes a convolution using the DCNN Accelerator FPGA Algorithm
    % @param img_path   : a path to an image for testing
    % @param kernel_path: path to a csv file for filtering
    % @return pass  : 1 if the algorithm computed the convolution correctly, 0 if not
    
%%%


    test_img     = imread(img_path); 
    test_kernel = csvread(kernel_path);
    
    % Image preprocessing
    test_img = imresize (rgb2gray(test_img), [512,512]) ; % converts from RGB colorspace to greyscale, and then resizes the image to 512x512
    paddedImg = zeroPad(test_img, size(test_kernel,1) ); 
    
    % tolerance value for difference in computed convolution and ground truth
    rtol = 1e-10;
    
    disp( "Input Image Path:")
    img_path    
    disp ("Input Kernel Path:")
    kernel_path
    
    disp ("Input Kernel Dimensions")
    size(test_kernel)   
    disp ("Input image dimensions")
    size(paddedImg)
    
    [execTime, fmStream] = FPGA_Runner(paddedImg, test_kernel); 
    
    numZeroLayers = floor(size(test_kernel,1)/2);
    
    %1D to 2D 
    fmArray = transpose( reshape(fmStream, size(paddedImg)) ); 
    
    %Extract valid outputs
    fpgaFM = fmArray( numZeroLayers:numZeroLayers+size(test_img,1)-1, numZeroLayers:numZeroLayers+size(test_img,1)-1 );
    trueFM = imfilter(test_img, test_kernel, 'same'); 
    pass = ( norm( abs(fpgaFM - trueFM)) < rtol);
    
    if pass
        disp("Test Passed!")
    else
        disp ("Test Failed!")
    end 
    
    disp("Execution Time:", execTime, "s"); 
    
end 

function zeroPadded = zeroPad(img, kernel_size)

    % Zero pads the input image for convolution
    
    new_img_dim = size(img,1) + (kernel_size-1);
    zeroPadded = zeros(new_img_dim); 
    num_zero_layers = (kernel_size - 1) / 2; 
    
    zeroPadded(num_zero_layers + 1: size(zeroPadded,1)-num_zero_layers, num_zero_layers+1:size(zeroPadded,1)-num_zero_layers) = img; 

end 