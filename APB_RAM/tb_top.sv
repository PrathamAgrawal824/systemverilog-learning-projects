// Testbench Top
`include "apb_if.sv"
`include "apb_transaction.sv"
`include "apb_generator.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"
`include "apb_scoreboard.sv"
`include "apb_environment.sv"

module tb_top;

  logic pclk = 0;
  always #5 pclk = ~pclk;   // 100MHz

  apb_if vif (pclk);

  // DUT instance 
  apb_ram #(.ADDR_WIDTH(9), .DATA_WIDTH(32), .MEM_DEPTH(256), .WAIT_CYCLES(1)) dut (
    .pclk    (vif.pclk),
    .presetn (vif.presetn),
    .paddr   (vif.paddr),        
    .pwrite  (vif.pwrite),
    .psel    (vif.psel),
    .penable (vif.penable),
    .pwdata  (vif.pwdata),
    .prdata  (vif.prdata),
    .pready  (vif.pready),
    .pslverr (vif.pslverr)
  );

  apb_environment env;

  initial begin
    env = new(vif);
    env.gen.count = 50; //50 stimuli generated    
    env.run();
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_top);
  end

endmodule
