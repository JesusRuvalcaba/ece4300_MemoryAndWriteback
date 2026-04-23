//memoryTB.v
`timescale 1ns / 1ps

module memoryTB();

    reg clk;
    reg [1:0] wb_ctlout;
    reg branch, memread, memwrite;
    reg zero;
    reg [31:0] alu_result, rdata2out;
    reg [4:0] five_bit_muxout;

    wire MEM_PCSrc;
    wire MEM_WB_regwrite, MEM_WB_memtoreg;
    wire [31:0] read_data, mem_alu_result;
    wire [4:0] mem_write_reg;

    MEMORY uut (
        .wb_ctlout(wb_ctlout),
        .branch(branch),
        .memread(memread),
        .memwrite(memwrite),
        .zero(zero),
        .alu_result(alu_result),
        .rdata2out(rdata2out),
        .five_bit_muxout(five_bit_muxout),
        .MEM_PCSrc(MEM_PCSrc),
        .MEM_WB_regwrite(MEM_WB_regwrite),
        .MEM_WB_memtoreg(MEM_WB_memtoreg),
        .read_data(read_data),
        .mem_alu_result(mem_alu_result),
        .mem_write_reg(mem_write_reg)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        // Initial values
        wb_ctlout       = 2'b00;
        branch          = 0;
        memread         = 0;
        memwrite        = 0;
        zero            = 0;
        alu_result      = 32'h00000000;
        rdata2out       = 32'h12345678;
        five_bit_muxout = 5'd2;

        #10;
    
        // read from address 4 before writing
        
      
        
        // read from address 8 before writing
        alu_result  = 32'd4;
        memread = 1;
        #10;
        
      
        alu_result = 32'd8;
        #10;
        
        // Write 12345678 into address 4

        memread  = 0;
        alu_result = 32'd4;
        
        #10;

        // Stop write
        memwrite = 0;
        #10;

        // Read back from address 4
        memread = 1;
        #10;

        // Branch test: MEM_PCSrc should be 1
        branch = 1;
        zero   = 1;
        #10;

        // Branch test: MEM_PCSrc should be 0
        zero   = 0;
        #10;

        // Clear branch
        branch = 0;
        zero   = 0;
        memread = 0;
        #10;

        alu_result      = 32'h00000008;
        rdata2out       = 32'hABCD1234;
        five_bit_muxout = 5'd5;
        wb_ctlout       = 2'b10;
        memwrite        = 1;
        #10;

        // Stop write
        memwrite = 0;
        #10;

        // Read back from address 8
        memread = 1;
        #10;
        
        // and gate stimuli
        branch = 0; 
        zero = 0; 
        #10;
        
        branch = 0; 
        zero = 1; 
        #10;
        
        branch = 1; 
        zero = 0; 
        #10;
        
        branch = 1; 
        zero = 1; 
        #10;

        $finish;
    end

endmodule
