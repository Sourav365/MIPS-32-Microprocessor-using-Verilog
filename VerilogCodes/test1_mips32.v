`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2023 11:09:39
// Design Name: 
// Module Name: test1_mips32
// Project Name: 
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


module test1_mips32();

    reg clk1, clk2;
    integer k;
    
    top_module mips (clk1, clk2);
    
    initial begin
        clk1=0; clk2=0;
        repeat(20) begin
            #5 clk1 = 1; #5 clk1 = 0;
            #5 clk2 = 1; #5 clk2 = 0;
        end
    end
    
    initial $readmemh("F:\\Xilinx_Vivado\\011MIPS32_processor\\instructions\\hex_code_new.txt", mips.Mem);
    
    initial begin
        for(k=0; k<31; k=k+1)     mips.Reg[k] = k;
        /*mips.Mem [0] = 32'h2801000a;
        mips.Mem [1] = 32'h28020014;
        mips.Mem [2] = 32'h28030019;
        mips.Mem [3] = 32'h0ce77800;
        mips.Mem [4] = 32'h0ce77800;
        mips.Mem [5] = 32'h00222000;
        mips.Mem [6] = 32'h0ce77800;
        mips.Mem [7] = 32'h00832800;
        mips.Mem [8] = 32'hfc000000;*/
        
        mips.HALTED = 0;
        mips.PC = 0;
        mips.TAKEN_BRANCH = 0;
        
        #280
        for(k=0; k<6; k=k+1)
            $display("R%1d => %2d", k, mips.Reg[k]);
    end
    
    initial begin
        $dumpfile ("mips.vcd");
        $dumpvars (0, test1_mips32);
        #300; $finish;
    end
endmodule
