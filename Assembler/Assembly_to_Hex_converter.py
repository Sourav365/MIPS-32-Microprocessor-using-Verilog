file_in = open('F:\\Xilinx_Vivado\\011MIPS32_processor\\instructions\\test2_data.txt','r')
lines = file_in.readlines()

file_out = open("F:\\Xilinx_Vivado\\011MIPS32_processor\\instructions\\hex_code_new.txt", "w")

ADD ='000000'; SUB ='000001'; AND  ='000010';
OR  ='000011'; SLT ='000100'; MUL  ='000101';
LW  ='001000'; SW  ='001001'; ADDI ='001010';
SUBI='001011'; SLTI='001100'; BNEQZ='001101';
BEQZ='001110'; HLT ='111111';



for line in lines:
    print(line)
    x = line.split()
    y=""
    z=""
    encoded="";
    
    match(x[1]):
        case 'ADD'  :       ##ADD rd,rs,rt => OPCODE | rs | rt | rd | 11{0}
            y=(x[2]).split(',');
            encoded = ADD + '{:05b}'.format(int(y[1][1:])) +\
            '{:05b}'.format(int(y[2][1:])) + '{:05b}'.format(int(y[0][1:])) + 11*'0';             

        case 'SUB'  :       ##SUB rd,rs,rt => OPCODE | rs | rt | rd | 11{0}
            y=(x[2]).split(',');
            encoded = SUB + '{:05b}'.format(int(y[1][1:])) +\
            '{:05b}'.format(int(y[2][1:])) + '{:05b}'.format(int(y[0][1:])) + 11*'0';               

        case 'AND'  :       ##AND rd,rs,rt => OPCODE | rs | rt | rd | 11{0}
            y=(x[2]).split(',');
            encoded = AND + '{:05b}'.format(int(y[1][1:])) +\
            '{:05b}'.format(int(y[2][1:])) + '{:05b}'.format(int(y[0][1:])) + 11*'0';

        case 'OR'   :       ##OR  rd,rs,rt => OPCODE | rs | rt | rd | 11{0}
            y=(x[2]).split(',');
            encoded = OR  + '{:05b}'.format(int(y[1][1:])) +\
            '{:05b}'.format(int(y[2][1:])) + '{:05b}'.format(int(y[0][1:])) + 11*'0';

        case 'SLT'  :       ##SLT rd,rs,rt => OPCODE | rs | rt | rd | 11{0}
            y=(x[2]).split(',');
            encoded = SLT  + '{:05b}'.format(int(y[1][1:])) +\
            '{:05b}'.format(int(y[2][1:])) + '{:05b}'.format(int(y[0][1:])) + 11*'0';

        case 'MUL'  :       ##MUL rd,rs,rt => OPCODE | rs | rt | rd | 11{0}
            y=(x[2]).split(',');
            encoded = MUL  + '{:05b}'.format(int(y[1][1:])) +\
            '{:05b}'.format(int(y[2][1:])) + '{:05b}'.format(int(y[0][1:])) + 11*'0';

        case 'LW'   :       ##LW rt,Imm_data(rs) => OPCODE | rs | rt | Imm_data
            y=(x[2]).split(','); z=y[1].split('(');
            encoded = LW + '{:05b}'.format(int(z[1][1:-1])) +\
            '{:05b}'.format(int(y[0][1:])) + '{:016b}'.format(int(z[0]))

        case 'SW'   :       ##SW rs,Imm_data(rt) => OPCODE | rt | rs | Imm_data
            y=(x[2]).split(','); z=y[1].split('(');
            encoded = SW + '{:05b}'.format(int(z[1][1:-1])) +\
            '{:05b}'.format(int(y[0][1:])) + '{:016b}'.format(int(z[0]))
        
        case 'ADDI' :       ##ADDI rt,rs,Imm_data => OPCODE | rs | rt | Imm_data
            y=(x[2]).split(',');
            encoded = ADDI + '{:05b}'.format(int(y[1][1:])) +\
            '{:05b}'.format(int(y[0][1:])) + '{:016b}'.format(int(y[2]));               

        case 'SUBI' :       ##SUBI rt,rs,Imm_data => OPCODE | rs | rt | Imm_data
            y=(x[2]).split(',');
            encoded = SUBI + '{:05b}'.format(int(y[1][1:])) +\
            '{:05b}'.format(int(y[0][1:])) + '{:016b}'.format(int(y[2]));
                    
        case 'SLTI' : encoded = SLTI

        case 'BNEQZ': encoded = BNEQZ

        case 'BEQZ' : encoded = BEQZ

        case 'HLT'  :
            encoded = HLT + 26*'0'
        

    #print(y) #Print 2nd part of OPCODE

    #out_hex=(hex(int(encoded,2))) #Convert bin_string->int->hex

    out = '{:08x}'.format(int(encoded,2)) #32-bit hex_string(8)
    print(out)
    file_out.writelines(x[0]+'  '+out+'\t//'+' '.join(x[1:])+'\n')


file_in.close()
file_out.close()
