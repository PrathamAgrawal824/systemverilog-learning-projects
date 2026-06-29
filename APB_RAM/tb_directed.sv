module tb_directed;
  logic pclk=0, presetn;
  logic [8:0] paddr;
  logic pwrite, psel, penable;
  logic [31:0] pwdata, prdata;
  logic pready, pslverr;

  always #5 pclk = ~pclk;

  apb_ram #(.ADDR_WIDTH(9), .DATA_WIDTH(32), .MEM_DEPTH(256), .WAIT_CYCLES(1)) dut (
    .pclk(pclk), .presetn(presetn), .paddr(paddr), .pwrite(pwrite),
    .psel(psel), .penable(penable), .pwdata(pwdata), .prdata(prdata),
    .pready(pready), .pslverr(pslverr)
  );

  task apb_write(input [8:0] a, input [31:0] d);
    @(posedge pclk); psel=1; penable=0; paddr=a; pwrite=1; pwdata=d;
    @(posedge pclk); penable=1;
    while(!pready) @(posedge pclk);
    $display("WRITE addr=%0d data=%0h pslverr=%0b @%0t", a, d, pslverr, $time);
    @(posedge pclk); psel=0; penable=0;
  endtask

  task apb_read(input [8:0] a, output [31:0] d);
    @(posedge pclk); psel=1; penable=0; paddr=a; pwrite=0; pwdata=0;
    @(posedge pclk); penable=1;
    while(!pready) @(posedge pclk);
    d = prdata;
    $display("READ  addr=%0d data=%0h pslverr=%0b @%0t", a, prdata, pslverr, $time);
    @(posedge pclk); psel=0; penable=0;
  endtask

  logic [31:0] rd;
  initial begin
    presetn=0; psel=0; penable=0; pwrite=0; paddr=0; pwdata=0;
    repeat(3) @(posedge pclk);
    presetn=1;
    @(posedge pclk);

    apb_write(9'd10, 32'hDEADBEEF);
    apb_read(9'd10, rd);
    if (rd == 32'hDEADBEEF) $display("PASS: read matches write"); else $display("FAIL: mismatch");

    apb_write(9'd300, 32'h11111111); // invalid addr -> expect pslverr
    apb_read(9'd300, rd);            // invalid addr -> expect pslverr

    apb_read(9'd10, rd); // re-read valid addr, pslverr must be 0
    if(rd==32'hDEADBEEF && !pslverr) $display("PASS: valid addr no pslverr");

    $finish;
  end
endmodule
