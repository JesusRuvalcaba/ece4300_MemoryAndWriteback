//memoryTB.v

module memoryTB();
    reg clk;
    reg [31:0] ALUResult, WriteData;
    reg [4:0] WriteReg;
    reg [1:0] WBControl;
    reg MemWrite, MemRead, Branch, Zero;
    wire [31:0] ReadData, ALUResult_out;
    wire [4:0] WriteReg_out;
    wire [1:0] WBControl_out;
    wire PCSrc;

    mem_stage uut (
        .clk(clk),
        .ALUResult(ALUResult),
        .WriteData(WriteData),
        .WriteReg(WriteReg),
        .WBControl(WBControl),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Branch(Branch),
        .Zero(Zero),
        .ReadData(ReadData),
        .ALUResult_out(ALUResult_out),
        .WriteReg_out(WriteReg_out),
        .WBControl_out(WBControl_out),
        .PCSrc(PCSrc)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("Time\tclk\tALUResult\tWriteData\tWriteReg\tWBControl\tMemWrite\tMemRead\tBranch\tZero\tReadData\t\tALUResult_out\tWriteReg_out\tWBControl_out\tPCSrc");
        $monitor("%0t\t%b\t%h\t%h\t%h\t%b\t%b\t%b\t%b\t%b\t%h\t%h\t%h\t%b\t%b",
                 $time, clk, ALUResult, WriteData, WriteReg, WBControl,
                 MemWrite, MemRead, Branch, Zero,
                 ReadData, ALUResult_out, WriteReg_out, WBControl_out, PCSrc);

        // Initial values
        ALUResult = 32'h00000004;
        WriteData = 32'h12345678;
        WriteReg  = 5'h02;
        WBControl = 2'b01;
        MemWrite  = 0;
        MemRead   = 1;
        Branch    = 0;
        Zero      = 0;

        #10;

        // Mem Write
        MemWrite = 1;
        MemRead  = 0;
        #10;

        // Read back same location
        MemWrite = 0;
        MemRead  = 1;
        #10;

        // Branch test: should make PCSrc = 1
        Branch = 1;
        Zero   = 1;
        #10;

        // Branch test: should make PCSrc = 0
        Branch = 1;
        Zero   = 0;
        #10;

        // Another read from different address
        ALUResult = 32'h00000008;
        Branch    = 0;
        Zero      = 0;
        MemRead   = 1;
        MemWrite  = 0;
        #10;

        $finish;
    end

endmodule
