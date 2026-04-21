`timescale 1ns / 1ps

module memoryTB();

    // 1. Clock and Input Regs (The Stimulus)
    reg clk;
    reg [31:0] ALUResult, WriteData;
    reg [4:0] WriteReg;
    reg [1:0] WBControl;
    reg MemWrite, MemRead, Branch, Zero;

    // 2. Output Wires (The Observations)
    wire [31:0] ReadData, ALUResult_out;
    wire [4:0] WriteReg_out;
    wire [1:0] WBControl_out;
    wire PCSrc;

    // 3. Instantiate the Unit Under Test (UUT)
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

    // 4. Clock Generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 5. Test Stimulus Block
    initial begin
        // Initialize everything to 0
        ALUResult = 0; WriteData = 0; WriteReg = 0; 
        WBControl = 0; MemWrite = 0; MemRead = 0; 
        Branch = 0; Zero = 0;

        #10; // Wait for initial reset phase

        // --- TEST CASE 1: Memory Read ---
        // Let's read from address 4 (which is initialized in data.txt)
        ALUResult = 32'h00000004;
        WriteReg  = 5'h02;
        WBControl = 2'b11; // RegWrite=1, MemToReg=1
        MemRead   = 1;
        MemWrite  = 0;
        
        #10; // Wait for one clock cycle
        $display("Read Test: Address 4 holds %h", ReadData);

        // --- TEST CASE 2: Memory Write ---
        // Now let's write 'C0FFEE00' into address 4
        ALUResult = 32'h00000004;
        WriteData = 32'hC0FFEE00;
        MemRead   = 0;
        MemWrite  = 1;
        
        #10; // Rising edge at #20ns triggers the write

        // --- TEST CASE 3: Verify the Write ---
        // Flip back to Read to see if 'C0FFEE00' is actually there
        MemWrite  = 0;
        MemRead   = 1;
        
        #10; // Rising edge at #30ns triggers the read
        $display("Verify Test: Address 4 now holds %h", ReadData);

        // --- TEST CASE 4: Branch Logic (The AND Gate) ---
        // Simulate a BEQ instruction where $rs == $rt
        Branch = 1;
        Zero   = 1;
        
        #5; // Branch logic is combinational, no need to wait for clock edge
        if (PCSrc == 1) 
            $display("Branch Test: PCSrc is HIGH - Branch Taken!");
        else
            $display("Branch Test: FAILED");

        #15;
        $display("Simulation Complete.");
        $finish;
    end

endmodule