%% Header

% Hussain Khajanchi
% DCNN Senior Project 

% FPGA Runner module

% Description - This module emulates the end-to-end functionality of the convolution hardware on the FPGA by testing the UART input/output 
% Uses MATLAB class implementations of the SoPU, ILB, and UART read/write modules to packetize image/kernel data, compute the SOP,  and to rebuild feature map data


    
%% MATLAB Implementation
function [fm_array, test_img, test_kernel] = FPGA_Runner(img_size, kernel_size)

    %% Setup for FPGA Convolution 

  
    % Create random integer matrix for test image and random float matrix for test kernel
    test_img    = randi(255, img_size);
        
    % Zero pad the image
%     new_img_dim = ceil(img_size / kernel_size ) * kernel_size; 

    new_img_dim = img_size + 2;
    
    new_img = zeros(new_img_dim); 
    new_img(2:new_img_dim-1, 2:new_img_dim-1) = test_img; 
    
        
    test_kernel = rand(kernel_size); 
    
    % Create FPGA Module Objects for full HW design emulation
    
%     inputUART  = UART(test_img, test_kernel); 
    inputUART  = UART(new_img, test_kernel); 
    SoPU_obj   = SoPU(kernel_size, kernel_size);
    
%     ILB_obj    = ILB(kernel_size-1, img_size); 
    ILB_obj    = ILB(kernel_size-1, new_img_dim); 
    
%     outputUART = UART( zeros(img_size),[] ); 
    outputUART = UART( zeros(new_img_dim),[] ); 
   
   % Parameters for Convolution Control 
   kernel_len = numel(test_kernel); % also equal to kernel_size ^2, assuming square kernel
   img_len    = numel(new_img); % same as numFM, but keeping the two separate for code clarity
   numFM      = numel(new_img); % assuming 'same' style convolution
   
   sopu_ctr = 0; 
   fm_ctr   = 0; 
   
   % When the SoPU counter reaches this point, the "convolution" starts becoming valid 
   sop_valid_threshold = (floor(kernel_size/2) * new_img_dim) + (floor (kernel_size/2) + 1) -1; 

    
    %% Convolution Algorithm Execution
    
    %%% 
        % Algorithm for FPGA-based convolution
        
        % 1) Read UART bytes until Kernel is filled 
        
        % 2) For byte in UART:
        %    - shift SoPU image window
        %    - write uart byte to image window
        %    - write uart byte to ILB
        %    - read ILB bytes into SoPU 
        %    - compute conv and output FM value
        %    - write to output UART stream
        
        % 3) Unpack output UART stream into 2D Feature Map 
        
    
    %%%
    
  
    % Step 1:  Fill Kernel in SoPU
      
    for i = 1:kernel_len
        
        uartByte  = inputUART.readByte();        
        SoPU_obj  = SoPU_obj.kernel_write(uartByte);     
        inputUART = inputUART.incrementReadPtr(); 
        
    end 
    
    assert (inputUART.readPtr == (kernel_len + 1), inputUART.readPtr); %make sure we read in all the kernel values

    % Step 2 of Convolution Algorithm
              
    % Iterate through all of the input image pixels in the UART stream
    for i = 1:img_len
        
        % Read bytes from UART stream and ILB, and then write the UART value to the ILB
        currentPixel   = inputUART.readByte();     
        curr_ilb_bytes = ILB_obj.readBytes(); 
        ILB_obj        = ILB_obj.writeByte(currentPixel); 

        
        % Run the SoPU to get the next feature map, used a local function for encapsulation
        [SoPU_obj, currentFM] = runSoPU(SoPU_obj, currentPixel, curr_ilb_bytes); 
       
        % if the SoPU ctr is above the threshold, start saving output FM values and increment the fm_ctr
        if (sopu_ctr >= sop_valid_threshold)
            
            outputUART = outputUART.writeByte(currentFM);
            fm_ctr = fm_ctr + 1; 
            
        end 
       
        inputUART = inputUART.incrementReadPtr(); %increment read ptr for UART
        sopu_ctr  = sopu_ctr + 1; % increment SoPU counter to keep track of valid
       
    end 
    
    
    assert (sopu_ctr == img_len, num2str(sopu_ctr)); % should not be over that at this point
    assert (fm_ctr == (img_len - sop_valid_threshold), fm_ctr); 
    assert (outputUART.writePtr == (fm_ctr + 1)); 
    
    
    num_fm_remaining = numFM - fm_ctr; 
    
    for i = 1:num_fm_remaining
        
        %Garbage Values now that UART is depleted
        currentPixel   = 0; 
        curr_ilb_bytes = ILB_obj.readBytes(); 
        ILB_obj        = ILB_obj.writeByte(currentPixel); 
        
        [SoPU_obj, currentFM] = runSoPU(SoPU_obj, currentPixel, curr_ilb_bytes); 
        
        outputUART = outputUART.writeByte(currentFM); 
        
        %increment helper variables
        sopu_ctr = sopu_ctr + 1;
        fm_ctr = fm_ctr + 1; 
        
  
    end 
    
  assert (fm_ctr == numFM);
  fm_array = transpose (reshape(outputUART.uart_stream, size(new_img))); 
  
  % slice to get the original img_size 
  fm_array = fm_array(2:new_img_dim-1, 2:new_img_dim-1); 
  fm_actual = imfilter(test_img, test_kernel, 'same');
  
  % floating point matrices won't be exactly the same, checking magnitude of error instead
  error_mag = norm( abs(fm_array - fm_actual)); 
  rtol = 1e-10; 
  
  if (error_mag < rtol) 
      disp("test passed")
  else 
      disp("test failed")
  end 
  
  
end 



function [SoPU, outputFM] = runSoPU(SoPU, uartByte, ilb_Bytes)

% Given an inputByte and a vector of bytes from the ILB, this function
% mimics the functionality of the SoPU

% 1) Shift Image window
% 2) Write uartByte to image window
% 3) Write ilbBytes to image window
% 4) Run Sum-of-Products and compute convolution

        SoPU  = SoPU.imgWindowShift(); 
        SoPU  = SoPU.imgWrite_UART(uartByte); 
        SoPU  = SoPU.imgWrite_ILB(ilb_Bytes); 
        
        outputFM = SoPU.run_conv();


end 






