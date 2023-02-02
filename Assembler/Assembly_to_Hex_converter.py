file_in = open('F:\\Xilinx_Vivado\\011MIPS32_processor\\instructions\\assembly.txt','r')
lines = file_in.readlines()

file_out = open("F:\\Xilinx_Vivado\\011MIPS32_processor\\instructions\\hex_code.txt", "w")

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
    match(x[0]):
        case 'ADD'  :
            y=(x[1]).split(',');
            encoded = ADD + '{:05b}'.format(int(y[1][1:])) +\
            '{:05b}'.format(int(y[2][1:])) + '{:05b}'.format(int(y[0][1:])) + 11*'0';             

        case 'SUB'  :
            y=(x[1]).split(',');
            encoded = SUB + '{:05b}'.format(int(y[1][1:])) +\
            '{:05b}'.format(int(y[2][1:])) + '{:05b}'.format(int(y[0][1:])) + 11*'0';               

        case 'AND'  :
            y=(x[1]).split(',');
            encoded = AND + '{:05b}'.format(int(y[1][1:])) +\
            '{:05b}'.format(int(y[2][1:])) + '{:05b}'.format(int(y[0][1:])) + 11*'0';

        case 'OR'   :
            y=(x[1]).split(',');
            encoded = OR  + '{:05b}'.format(int(y[1][1:])) +\
            '{:05b}'.format(int(y[2][1:])) + '{:05b}'.format(int(y[0][1:])) + 11*'0';

        case 'SLT'  :
            encoded = SLT

        case 'MUL'  :
            encoded = MUL

        case 'LW'   :
            y=(x[1]).split(','); z=y[1].split('(');
            encoded = LW + '{:05b}'.format(int(z[1][1:-1])) +\
            '{:05b}'.format(int(y[0][1:])) + '{:016b}'.format(int(z[0]))

        case 'SW'   :
            y=(x[1]).split(','); z=y[1].split('(');
            encoded = SW + '{:05b}'.format(int(y[0][1:])) +\
            '{:05b}'.format(int(z[1][1:-1])) + '{:016b}'.format(int(z[0]))
        
        case 'ADDI' :
            y=(x[1]).split(',');
            encoded = ADDI + '{:05b}'.format(int(y[1][1:])) +\
            '{:05b}'.format(int(y[0][1:])) + '{:016b}'.format(int(y[2]));               

        case 'SUBI' :
            y=(x[1]).split(',');
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
    file_out.write(out)
    file_out.write('\n')

file_in.close()
file_out.close()
