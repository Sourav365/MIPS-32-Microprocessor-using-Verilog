`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2023 15:40:57
// Design Name: 
// Module Name: test2_mips32
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


module test2_mips32();

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
        /*mips.Mem [0] = 32'h28010078;
        mips.Mem [1] = 32'h0c631800;
        mips.Mem [2] = 32'h20220000;
        mips.Mem [3] = 32'h0c631800;
        mips.Mem [4] = 32'h2842002d;
        mips.Mem [5] = 32'h0c631800;
        mips.Mem [6] = 32'h24220001;
        mips.Mem [7] = 32'hfc000000;
        */
        mips.Mem [120] = 55; //55+45=100
        
        mips.HALTED = 0;
        mips.PC = 0;
        mips.TAKEN_BRANCH = 0;
        
        #500
        $display("Mem[120] => %4d\nMem[121] => %4d", mips.Mem[120],mips.Mem[121]);
    end
    
    initial begin
        $dumpfile ("mips.vcd");
        $dumpvars (0, test2_mips32);
        
    end
endmodule
