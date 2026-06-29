// Driver
class apb_driver;

  virtual apb_if vif;
  mailbox #(apb_transaction) gen2drv_mbx;

  semaphore drv_done;

  function new(mailbox #(apb_transaction) gen2drv_mbx);
    this.gen2drv_mbx = gen2drv_mbx;
  endfunction

// Driver Reset 
  task reset();
    vif.presetn <= 1'b0;
    vif.psel    <= 1'b0;
    vif.penable <= 1'b0;
    vif.pwrite  <= 1'b0;
    vif.paddr   <= '0;
    vif.pwdata  <= '0;
    repeat (5) @(posedge vif.pclk);
    vif.presetn <= 1'b1;
    @(posedge vif.pclk);
    $display("[DRV] : RESET DONE");
    $display("------------------------------------------------");
  endtask

 //Main task run
  
  task run();
    forever begin
      apb_transaction tr;
      gen2drv_mbx.get(tr);

      //SETUP phase
      @(posedge vif.pclk);
      vif.psel    <= 1'b1;
      vif.penable <= 1'b0;
      vif.paddr   <= tr.paddr;
      vif.pwrite  <= tr.pwrite();
      vif.pwdata  <= (tr.op == WRITE) ? tr.pwdata : '0;

      //ACCESS phase
      @(posedge vif.pclk);
      vif.penable <= 1'b1;

      // Wait till slave is ready 
      while (!vif.pready) begin
        @(posedge vif.pclk);
      end

      // Transfer completes when pready=1
      tr.display("DRV");

      //Back to IDLE state
      @(posedge vif.pclk);
      vif.psel    <= 1'b0;
      vif.penable <= 1'b0;
      vif.pwrite  <= 1'b0;
      vif.paddr   <= '0;
      vif.pwdata  <= '0;

      drv_done.put(1);
    end
  endtask

endclass
