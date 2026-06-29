//Transaction
typedef enum {READ, WRITE} apb_op_t;
typedef enum {ADDR_VALID, ADDR_INVALID} addr_type_t;

class apb_transaction;

  rand bit [8:0]  paddr;      
  rand bit [31:0] pwdata;
  rand apb_op_t   op;          
  rand addr_type_t addr_type; 


  bit [31:0] prdata;
  bit pslverr;

  parameter MEM_DEPTH = 256;


  // 80% valid , 20% invalid 
  constraint c_addr_type_dist {
    addr_type dist { ADDR_VALID := 80, ADDR_INVALID := 20 };
  }

  constraint c_addr_range {
    (addr_type == ADDR_VALID)   -> paddr < MEM_DEPTH;
    (addr_type == ADDR_INVALID) -> paddr >= MEM_DEPTH;
  }

  constraint c_op_dist {
    op dist { READ := 50, WRITE := 50 };
  }

  //derive pwrite from op

  function bit pwrite();
    return (op == WRITE);
  endfunction


  function void display(string tag = "TXN");
    $display("[%0s] op=%-5s paddr=0x%0h(%0d) pwdata=0x%0h prdata=0x%0h pslverr=%0b addr_type=%-12s @ %0t",
              tag, op.name(), paddr, paddr, pwdata, prdata, pslverr, addr_type.name(), $time);
  endfunction

  
  
  // Deep copy 

  function apb_transaction copy();
    apb_transaction t = new();
    t.paddr     = this.paddr;
    t.pwdata    = this.pwdata;
    t.op        = this.op;
    t.addr_type = this.addr_type;
    t.prdata    = this.prdata;
    t.pslverr   = this.pslverr;
    return t;
  endfunction

endclass
