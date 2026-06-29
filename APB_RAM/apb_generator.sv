// Generator
class apb_generator;

  apb_transaction tr;
  mailbox #(apb_transaction) gen2drv_mbx;

  int count = 0;
  
  //implementing semaphores instead of events to avoid race condition that occured earlier
 
  semaphore drv_done;  
  semaphore sco_done;   
  semaphore gen_done;  

  function new(mailbox #(apb_transaction) gen2drv_mbx);
    this.gen2drv_mbx = gen2drv_mbx;
    drv_done = new(0);
    sco_done = new(0);
    gen_done = new(0);
  endfunction

  task run();
    repeat (count) begin
      tr = new();
      if (!tr.randomize())
        $error("[GEN] : Randomization failed");

      gen2drv_mbx.put(tr);
      tr.display("GEN");

      drv_done.get(1);  //waiting for driver and sco to complete their task
      sco_done.get(1);  
    end
    gen_done.put(1);
  endtask
endclass