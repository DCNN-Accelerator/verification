`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DCNN Accelerator Senior Project
// Engineer: Hussain Khajanchi
// 
// Create Date: 02/05/2020 02:47:31 PM
// Design Name: Convolution Unit Smoke Test
// Module Name: conv_tb
// Project Name: SoPU Verification
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module conv_tb();


    // Instantiate Driver and Reciever Signals
    reg clk, rst, sop_enable; 
    
    reg [7:0] kernel_arr [48:0]; 
    reg [7:0] img_window [48:0]; 
        
    wire [15:0] output_FM;
    wire out_vld; 
    
    //Instantiate Local Variables for verification
    integer expected_val = 0;  
    
    // Instantiate UUT 
    fp_sop_0 DUT 
    (
      .ap_clk(clk),                        // input wire ap_clk
      .ap_rst(rst),                        // input wire ap_rst
      
      .kernel_patch_0_V(kernel_arr[0]),
      .kernel_patch_1_V(kernel_arr[1]),
      .kernel_patch_2_V(kernel_arr[2]),
      .kernel_patch_3_V(kernel_arr[3]),
      .kernel_patch_4_V(kernel_arr[4]),
      .kernel_patch_5_V(kernel_arr[5]),
      .kernel_patch_6_V(kernel_arr[6]),
      .kernel_patch_7_V(kernel_arr[7]),
      .kernel_patch_8_V(kernel_arr[8]),
      .kernel_patch_9_V(kernel_arr[9]),
      .kernel_patch_10_V(kernel_arr[10]),
      .kernel_patch_11_V(kernel_arr[11]),
      .kernel_patch_12_V(kernel_arr[12]),
      .kernel_patch_13_V(kernel_arr[13]),
      .kernel_patch_14_V(kernel_arr[14]),
      .kernel_patch_15_V(kernel_arr[15]),
      .kernel_patch_16_V(kernel_arr[16]),
      .kernel_patch_17_V(kernel_arr[17]),
      .kernel_patch_18_V(kernel_arr[18]),
      .kernel_patch_19_V(kernel_arr[19]),
      .kernel_patch_20_V(kernel_arr[20]),
      .kernel_patch_21_V(kernel_arr[21]),
      .kernel_patch_22_V(kernel_arr[22]),
      .kernel_patch_23_V(kernel_arr[23]),
      .kernel_patch_24_V(kernel_arr[24]),
      .kernel_patch_25_V(kernel_arr[25]),
      .kernel_patch_26_V(kernel_arr[26]),
      .kernel_patch_27_V(kernel_arr[27]),
      .kernel_patch_28_V(kernel_arr[28]),
      .kernel_patch_29_V(kernel_arr[29]),
      .kernel_patch_30_V(kernel_arr[30]),
      .kernel_patch_31_V(kernel_arr[31]),
      .kernel_patch_32_V(kernel_arr[32]),
      .kernel_patch_33_V(kernel_arr[33]),
      .kernel_patch_34_V(kernel_arr[34]),
      .kernel_patch_35_V(kernel_arr[35]),
      .kernel_patch_36_V(kernel_arr[36]),
      .kernel_patch_37_V(kernel_arr[37]),
      .kernel_patch_38_V(kernel_arr[38]),
      .kernel_patch_39_V(kernel_arr[39]),
      .kernel_patch_40_V(kernel_arr[40]),
      .kernel_patch_41_V(kernel_arr[41]),
      .kernel_patch_42_V(kernel_arr[42]),
      .kernel_patch_43_V(kernel_arr[43]),
      .kernel_patch_44_V(kernel_arr[44]),
      .kernel_patch_45_V(kernel_arr[45]),
      .kernel_patch_46_V(kernel_arr[46]),
      .kernel_patch_47_V(kernel_arr[47]),
      .kernel_patch_48_V(kernel_arr[48]),
      
      .pixel_window_0_V(img_window[0]),
      .pixel_window_1_V(img_window[1]),
      .pixel_window_2_V(img_window[2]),
      .pixel_window_3_V(img_window[3]),
      .pixel_window_4_V(img_window[4]),
      .pixel_window_5_V(img_window[5]),
      .pixel_window_6_V(img_window[6]),
      .pixel_window_7_V(img_window[7]),
      .pixel_window_8_V(img_window[8]),
      .pixel_window_9_V(img_window[9]),
      .pixel_window_10_V(img_window[10]),
      .pixel_window_11_V(img_window[11]),
      .pixel_window_12_V(img_window[12]),
      .pixel_window_13_V(img_window[13]),
      .pixel_window_14_V(img_window[14]),
      .pixel_window_15_V(img_window[15]),
      .pixel_window_16_V(img_window[16]),
      .pixel_window_17_V(img_window[17]),
      .pixel_window_18_V(img_window[18]),
      .pixel_window_19_V(img_window[19]),
      .pixel_window_20_V(img_window[20]),
      .pixel_window_21_V(img_window[21]),
      .pixel_window_22_V(img_window[22]),
      .pixel_window_23_V(img_window[23]),
      .pixel_window_24_V(img_window[24]),
      .pixel_window_25_V(img_window[25]),
      .pixel_window_26_V(img_window[26]),
      .pixel_window_27_V(img_window[27]),
      .pixel_window_28_V(img_window[28]),
      .pixel_window_29_V(img_window[29]),
      .pixel_window_30_V(img_window[30]),
      .pixel_window_31_V(img_window[31]),
      .pixel_window_32_V(img_window[32]),
      .pixel_window_33_V(img_window[33]),
      .pixel_window_34_V(img_window[34]),
      .pixel_window_35_V(img_window[35]),
      .pixel_window_36_V(img_window[36]),
      .pixel_window_37_V(img_window[37]),
      .pixel_window_38_V(img_window[38]),
      .pixel_window_39_V(img_window[39]),
      .pixel_window_40_V(img_window[40]),
      .pixel_window_41_V(img_window[41]),
      .pixel_window_42_V(img_window[42]),
      .pixel_window_43_V(img_window[43]),
      .pixel_window_44_V(img_window[44]),
      .pixel_window_45_V(img_window[45]),
      .pixel_window_46_V(img_window[46]),
      .pixel_window_47_V(img_window[47]),
      .pixel_window_48_V(img_window[48]),
      
      .sop_enable(sop_enable),                // input wire sop_enable
      .out_valid(out_vld),                  // output wire out_valid
      .out_val_V(output_FM)                  // output wire [15 : 0] out_val_V
    );
    
    
    // 100 MHz Clock generation
    initial forever begin
    clk = 0; 
    #5; 
    clk = 1; 
    #5; 
    end 
    
   // Define Reset Signal 
    initial begin
    rst = 1; 
    #300; 
    rst = 0; 
    end 
    
    
    task instantiate_img_window;
    begin
    
        for (int i = 0; i < 49; i++)
        begin
        
        //Fills Image array with random integers between 0-255
            img_window[i] <= $urandom_range(0,255);
            
        end   
    end
    endtask
    
    task instantiate_kernel_arr;
    begin
    
        for (int i = 0; i < 49; i++)
            begin
            
             //Fills the kernels with random integers
                kernel_arr[i] <= 8'h7F;
            
            end 
    end 
    endtask 
    
    //Pulses the DUT enable signal
    task trigger_DUT_enable;
    begin
    
        sop_enable <= 0; 
        #50; 
        sop_enable <= 1; 
        #50; 
        sop_enable <= 0; 
    
    
    end 
        
    
    endtask
    
    
    task compute_expected_value; 

        begin
        
            for (int i = 0; i < 49; i++)
            begin
                expected_val = expected_val + kernel_arr[i] * img_window[i];
            end 
        
        end 
    
    endtask
    
    initial begin
    
    
    //Instantiate Driver variables
    instantiate_img_window; 
    instantiate_kernel_arr; 
    
    //Pulse the DUT to start
    #300;
    
    trigger_DUT_enable; 
    compute_expected_value;
    //Recieve output and then compare to expected value
    if (out_vld)
        begin
        $display("Expected Value: "); 
        $display(expected_val); 
        
        $display("Recieved Value: ");
        $display(output_FM); 
        
        
        
        end 
        
    
    
    
    
    end //Testing end 
    
    




endmodule
