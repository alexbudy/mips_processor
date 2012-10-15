`timescale 1ns/1ps

module BIOSTestbench();

    reg Clock, Reset;
    wire FPGA_SERIAL_RX, FPGA_SERIAL_TX;

    reg   [7:0] DataIn;
    reg         DataInValid;
    wire        DataInReady;
    wire  [7:0] DataOut;
    wire        DataOutValid;
    reg         DataOutReady;

    parameter HalfCycle = 5;
    parameter Cycle = 2*HalfCycle;
    parameter ClockFreq = 50_000_000;

    initial Clock = 0;
    always #(HalfCycle) Clock <= ~Clock;

    // Instantiate your CPU here and connect the FPGA_SERIAL_TX wires
    // to the UART we use for testing

MIPS150 CPU(
	.clk(Clock),
	.rst(Reset),
	.stall(1'b0),
	.FPGA_SERIAL_RX(FPGA_SERIAL_RX),
	.FPGA_SERIAL_TX(FPGA_SERIAL_TX)
);


    UART          #( .ClockFreq(       ClockFreq))
                  uart( .Clock(           Clock),
                        .Reset(           Reset),
                        .DataIn(          DataIn),
                        .DataInValid(     DataInValid),
                        .DataInReady(     DataInReady),
                        .DataOut(         DataOut),
                        .DataOutValid(    DataOutValid),
                        .DataOutReady(    DataOutReady),
                        .SIn(             FPGA_SERIAL_TX),
                        .SOut(            FPGA_SERIAL_RX));

    initial begin
      // Reset. Has to be long enough to not be eaten by the debouncer.
      Reset = 0;
      DataIn = 8'h7a;
      DataInValid = 0;
      DataOutReady = 0;
      #(100*Cycle)

      Reset = 1;
      #(50*Cycle)
      Reset = 0;

      // Wait for something to come back
      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      //send l
      DataIn = 8'd108;
      while (!DataInReady) #(Cycle);
      DataInValid = 1'b1;
      #(Cycle)
      DataInValid = 1'b0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      //send w
      DataIn = 8'd119;
      while (!DataInReady) #(Cycle);
      DataInValid = 1'b1;
      #(Cycle)
      DataInValid = 1'b0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      //send space
      DataIn = 8'd32;
      while (!DataInReady) #(Cycle);
      DataInValid = 1'b1;
      #(Cycle)
      DataInValid = 1'b0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      //send 1
      DataIn = 8'd49;
      while (!DataInReady) #(Cycle);
      DataInValid = 1'b1;
      #(Cycle)
      DataInValid = 1'b0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      //send 0
      DataIn = 8'd48;
      while (!DataInReady) #(Cycle);
      DataInValid = 1'b1;
      #(Cycle)
      DataInValid = 1'b0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      //send 0
      DataIn = 8'd48;
      while (!DataInReady) #(Cycle);
      DataInValid = 1'b1;
      #(Cycle)
      DataInValid = 1'b0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      //send 0
      DataIn = 8'd48;
      while (!DataInReady) #(Cycle);
      DataInValid = 1'b1;
      #(Cycle)
      DataInValid = 1'b0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      //send 0
      DataIn = 8'd48;
      while (!DataInReady) #(Cycle);
      DataInValid = 1'b1;
      #(Cycle)
      DataInValid = 1'b0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      //send 3
      DataIn = 8'd51;
      while (!DataInReady) #(Cycle);
      DataInValid = 1'b1;
      #(Cycle)
      DataInValid = 1'b0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      //send 0
      DataIn = 8'd48;
      while (!DataInReady) #(Cycle);
      DataInValid = 1'b1;
      #(Cycle)
      DataInValid = 1'b0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      //send 0
      DataIn = 8'd48;
      while (!DataInReady) #(Cycle);
      DataInValid = 1'b1;
      #(Cycle)
      DataInValid = 1'b0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      //send 0
      DataIn = 8'd48;
      while (!DataInReady) #(Cycle);
      DataInValid = 1'b1;
      #(Cycle)
      DataInValid = 1'b0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      //send return
      DataIn = 8'd13;
      while (!DataInReady) #(Cycle);
      DataInValid = 1'b1;
      #(Cycle)
      DataInValid = 1'b0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;
	
	$display("READING RESULT");
	
		//read result
      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;

      while (!DataOutValid) #(Cycle);
      $display("Got %d", DataOut);
	  DataOutReady = 1;
	  #(Cycle);
	  DataOutReady = 0;
      $finish();
  end

endmodule
