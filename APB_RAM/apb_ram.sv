// APB RAM Slave 

module apb_ram #(
  parameter ADDR_WIDTH = 9, // 9-bit: up to 511,addr>=256 is "invalid"         
  parameter DATA_WIDTH = 32,
  parameter MEM_DEPTH  = 256,
  parameter WAIT_CYCLES = 1           // 0 = no wait states
)(
  input  logic                    pclk,
  input  logic                    presetn,
  input  logic [ADDR_WIDTH-1:0]   paddr,
  input  logic                    pwrite,
  input  logic                    psel,
  input  logic                    penable,
  input  logic [DATA_WIDTH-1:0]   pwdata,
  output logic [DATA_WIDTH-1:0]   prdata,
  output logic                    pready,
  output logic                    pslverr
);

  logic [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

   
  // FSM state 
  typedef enum logic [1:0] {
    IDLE   = 2'b00,
    SETUP  = 2'b01,
    ACCESS = 2'b10
  } apb_state_t;

  apb_state_t state, next_state;

  logic [3:0] wait_cnt;

  wire addr_valid = (paddr < MEM_DEPTH);

  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn)
      state <= IDLE;
    else
      state <= next_state;
  end

  // Next-state 
  always_comb begin
    next_state = state;
    case (state)
      IDLE:
        if (psel && !penable)
          next_state = SETUP;

      SETUP:
        if (psel && penable)
          next_state = ACCESS;
        else
          next_state = IDLE;

      ACCESS:
        if (psel && penable && pready)
          next_state = IDLE;
        else
          next_state = ACCESS;

      default:
        next_state = IDLE;
    endcase
  end

  // Wait counter 
  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn)
      wait_cnt <= '0;
    else if (state == SETUP && next_state == ACCESS)
      wait_cnt <= WAIT_CYCLES;
    else if (state == ACCESS && wait_cnt != 0)
      wait_cnt <= wait_cnt - 1'b1;
  end

  // PREADY 
  always_comb begin
    if (state == ACCESS)
      pready = (wait_cnt == 0);
    else
      pready = 1'b0;
  end

  // PSLVERR 
  always_comb begin
    pslverr = (state == ACCESS) && pready && !addr_valid;
  end

  
  // write
  always_ff @(posedge pclk) begin
    if (state == ACCESS && pready && pwrite && addr_valid) begin
      mem[paddr] <= pwdata;
    end
  end

  // read 
  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      prdata <= '0;
    end
    else if (state == SETUP && !pwrite) begin
      
      // Pre-fetch read data during SETUP so it's ready by ACCESS//
      prdata <= addr_valid ? mem[paddr] : '0;
    end
  end

endmodule
