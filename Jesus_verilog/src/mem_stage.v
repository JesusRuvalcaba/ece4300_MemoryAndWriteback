module mem_stage(
    input wire clk,
    input wire [31:0] ALUResult,
    input wire [31:0] WriteData,
    input wire [4:0] WriteReg,
    input wire [1:0] WBControl,
    input wire MemWrite, MemRead, Branch, Zero,
    output wire [31:0] ReadData, ALUResult_out,
    output wire [4:0] WriteReg_out,
    output wire [1:0] WBControl_out,
    output wire PCSrc
);

    wire MEM_WB_regwrite, MEM_WB_memtoreg;

    MEMORY uut (
        .wb_ctlout(WBControl),
        .branch(Branch),
        .memread(MemRead),
        .memwrite(MemWrite),
        .zero(Zero),
        .alu_result(ALUResult),
        .rdata2out(WriteData),
        .five_bit_muxout(WriteReg),
        .MEM_PCSrc(PCSrc),
        .MEM_WB_regwrite(MEM_WB_regwrite),
        .MEM_WB_memtoreg(MEM_WB_memtoreg),
        .read_data(ReadData),
        .mem_alu_result(ALUResult_out),
        .mem_write_reg(WriteReg_out)
    );

    assign WBControl_out = {MEM_WB_regwrite, MEM_WB_memtoreg};

endmodule
