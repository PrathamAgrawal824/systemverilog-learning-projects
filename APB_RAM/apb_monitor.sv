// Monitor
class apb_monitor;

  virtual apb_if vif;
  mailbox #(apb_transaction) mon2sco_mbx;

  function new(mailbox #(apb_transaction) mon2sco_mbx);
    this.mon2sco_mbx = mon2sco_mbx;
  endfunction

  task run();
    forever begin
      @(posedge vif.pclk);

      if (vif.psel && vif.penable && vif.pready) begin
        apb_transaction tr = new();   

        tr.paddr = vif.paddr;
        tr.pwdata = vif.pwdata;
        tr.op  = vif.pwrite ? WRITE : READ;
        tr.prdata = vif.prdata;
        tr.pslverr = vif.pslverr;
        tr.addr_type = (vif.paddr < apb_transaction::MEM_DEPTH) ? ADDR_VALID : ADDR_INVALID;

        tr.display("MON");
        mon2sco_mbx.put(tr);
      end
    end
  endtask

endclass
