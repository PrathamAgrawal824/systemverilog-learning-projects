interface apb_if #(parameter ADDR_WIDTH = 9, DATA_WIDTH = 32) (input logic pclk);

  logic                  presetn;
  logic [ADDR_WIDTH-1:0] paddr;   
  logic                  pwrite;
  logic                  psel;
  logic                  penable;
  logic [DATA_WIDTH-1:0] pwdata;
  logic [DATA_WIDTH-1:0] prdata;
  logic                  pready;
  logic                  pslverr;

endinterface
