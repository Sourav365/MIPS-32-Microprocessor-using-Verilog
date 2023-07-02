`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Sourav Das
// 
// Create Date: 25.01.2023 11:04:07
// Design Name: MIPS-32 pipelined design
// Module Name: top_module
// Project Name: MIPS-32 pipelined design
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


module top_module(
    input clk1, clk2
    );
    
    parameter word_size = 32, memory_size = 1024, no_of_GPR = 32;
    /*
     * Defining all registers
     */
     
    //Temp registers for pipeline architecture
    reg [(word_size-1):0] PC, IF_ID_IR, IF_ID_NPC;
    reg [(word_size-1):0] ID_EX_IR, ID_EX_NPC, ID_EX_A, ID_EX_B, ID_EX_Imm;
    reg [ 2:0]            ID_EX_type, EX_MEM_type, MEM_WB_type;
    reg [(word_size-1):0] EX_MEM_IR, EX_MEM_B, EX_MEM_ALUOut;
    reg                   EX_MEM_cond;
    reg [(word_size-1):0] MEM_WB_IR, MEM_WB_ALUOut, MEM_WB_LMD;
    
    //GPR bank 32x32
    reg [(word_size-1):0] Reg [0:(no_of_GPR-1)];
    
    //1024x32 bit memory
    reg [(word_size-1):0] Mem [0:(memory_size-1)];
    
    /*
     * 
     */
    parameter ADD=6'b000000, SUB=6'b000001, 
              AND=6'b000010, OR =6'b000011,
              SLT=6'b000100, MUL=6'b000101,
              LW =6'b001000, SW =6'b001001,
              ADDI=6'b001010, SUBI=6'b001011,
              SLTI=6'b001100, BNEQZ=6'b001101,
              BEQZ=6'b001110, HLT=6'b111111;
    
    //Types of instructions
    parameter RR_ALU=3'b000, RM_ALU=3'b001,
              LOAD  =3'b010, STORE =3'b011,
              BRANCH=3'b100, HALT  =3'b101;
    
    //other reg.
    reg HALTED, TAKEN_BRANCH;          
    
    
    /******************IF stage******************/
    always @(posedge clk1) begin
        if(HALTED == 0) begin    //Not halted
            
            //Branch Instruction
            if(((EX_MEM_IR[31:26] == BEQZ) && (EX_MEM_cond == 1)) ||    //BRANCH if 0 instruction and output is 0
                ((EX_MEM_IR[31:26] == BNEQZ)&&(EX_MEM_cond == 0)))      //BRANCH if not 0 instruction and output is not 0
            begin
                //Set branch_taken
                TAKEN_BRANCH <= #2 1'b1;  
                //Load instructions from memory address calculated by EX_MEM_ALUOut according to branch instruc.              
                IF_ID_IR     <= #2 Mem[EX_MEM_ALUOut];  
                //NPC indicates to desired branch address +1  
                IF_ID_NPC    <= #2 EX_MEM_ALUOut + 1;       //????????????
                //PC indicates to desired branch address +1
                PC           <= #2 EX_MEM_ALUOut + 1;       //????????????
            end 
            
            //Not a branch Instruction
            else begin
                //Load instructions from memory address indicated by PC
                IF_ID_IR     <= #2 Mem[PC];
                //NPC indicates to PC +1  
                IF_ID_NPC    <= #2 PC + 1;
                //PC indicates to PC +1
                PC           <= #2 PC + 1;  
            end
        end
    end
    
    
    /******************ID stage******************/
    always @(posedge clk2) begin
        if (HALTED == 0) begin      //Not halted instrc.
        
            //If 'rs' is R0 (contain 0, can't change value), assign 0, else assign reg number  
            if (IF_ID_IR[25:21] == 5'b00000) ID_EX_A <= 0;
            else ID_EX_A <= #2 Reg[IF_ID_IR[25:21]];
            
            //If 'rt' is R0 (contain 0, can't change value), assign 0, else assign reg number  
            if (IF_ID_IR[20:16] == 5'b00000) ID_EX_B <= 0;
            else ID_EX_B <= #2 Reg[IF_ID_IR[20:16]];
            
            ID_EX_NPC       <= #2 IF_ID_NPC;    //Forward data of NPC to next reg.
            ID_EX_IR        <= #2 IF_ID_IR;     ////Forward data of IR to next reg.
            ID_EX_Imm       <= #2 {{16{IF_ID_IR[15]}}, {IF_ID_IR[15:0]}}; //Sign extention of 16 bit Imm value to 32 bit value
            
            //Defining Addressing types of instructions
            case (IF_ID_IR[31:26]) //'OPCODE'
                ADD,SUB,AND,OR,SLT,MUL              : ID_EX_type <= #2 RR_ALU;
                ADDI, SUBI, SLTI                    : ID_EX_type <= #2 RM_ALU;
                LW                                  : ID_EX_type <= #2 LOAD;
                SW                                  : ID_EX_type <= #2 STORE;
                BEQZ,BNEQZ                          : ID_EX_type <= #2 BRANCH;
                HLT                                 : ID_EX_type <= #2 HALT;
                default                             : ID_EX_type <= #2 HALT;
            endcase
        end
    end
    
    
    
    /******************EX stage******************/
    always @(posedge clk1) begin
        if (HALTED == 0) begin      //Not halted instrc.
            
            TAKEN_BRANCH    <= #2 1'b0;         //?????????????????????????
            EX_MEM_type     <= #2 ID_EX_type;   //Forward instruc. type
            EX_MEM_IR       <= #2 ID_EX_IR;     //forward IR
            
            case (ID_EX_type)
                RR_ALU: begin
                          case(ID_EX_IR[31:26])
                              ADD     : EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_B;
                              SUB     : EX_MEM_ALUOut <= #2 ID_EX_A - ID_EX_B;
                              AND     : EX_MEM_ALUOut <= #2 ID_EX_A & ID_EX_B;
                              OR      : EX_MEM_ALUOut <= #2 ID_EX_A | ID_EX_B;
                              SLT     : EX_MEM_ALUOut <= #2 ID_EX_A < ID_EX_B;
                              MUL     : EX_MEM_ALUOut <= #2 ID_EX_A * ID_EX_B;
                              default : EX_MEM_ALUOut <= #2 32'hxxxx_xxxx;
                          endcase
                        end
                RM_ALU: begin
                          case(ID_EX_IR[31:26])
                              ADDI     : EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_Imm;
                              SUBI     : EX_MEM_ALUOut <= #2 ID_EX_A - ID_EX_Imm;
                              SLTI     : EX_MEM_ALUOut <= #2 ID_EX_A < ID_EX_Imm;
                              default  : EX_MEM_ALUOut <= #2 32'hxxxx_xxxx;
                          endcase
                        end
                LOAD,STORE: begin
                            EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_Imm; //Calculate effective address
                            EX_MEM_B      <= #2 ID_EX_B;    //Forward B value required for STORE instruc.
                        end
                BRANCH: begin
                          EX_MEM_ALUOut <= #2 ID_EX_NPC + ID_EX_Imm; //Calculate effective address
                          EX_MEM_cond   <= #2 (ID_EX_A == 0);
                        end
            endcase
        end
    end
    
    /******************MEM stage******************/
    always @(posedge clk2) begin
        if(HALTED == 0) begin //Not a halt instruc
            MEM_WB_type     <= #2 EX_MEM_type;      //Transfer type of instruction to next stage
            MEM_WB_IR       <= #2 EX_MEM_IR;        //Transfer IR to next stage
            
            case(EX_MEM_type)
                RR_ALU, RM_ALU  : MEM_WB_ALUOut   <= #2 EX_MEM_ALUOut;
                LOAD            : MEM_WB_LMD      <= #2 Mem[EX_MEM_ALUOut];
                STORE           : if(TAKEN_BRANCH == 0) //No branch taken, then store
                                    Mem[EX_MEM_ALUOut]  <= #2 EX_MEM_B;
            endcase
        end
    end
    
    /******************WB stage******************/
    always @(posedge clk1) begin
        if(TAKEN_BRANCH == 0) begin //No branch taken, then write back
            case (MEM_WB_type)
                RR_ALU      : Reg[MEM_WB_IR[15:11]]  <= #2 MEM_WB_ALUOut;   //'rd'
                RM_ALU      : Reg[MEM_WB_IR[20:16]]  <= #2 MEM_WB_ALUOut;   //'rt'
                LOAD        : Reg[MEM_WB_IR[20:16]]  <= #2 MEM_WB_LMD;      //'rt'
                HALT        : HALTED                 <= #2 1'b1;
            endcase
        end
    end
endmodule