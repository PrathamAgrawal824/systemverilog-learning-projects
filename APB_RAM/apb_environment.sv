// Environment
class apb_environment;

  apb_generator   gen;
  apb_driver      drv;
  apb_monitor     mon;
  apb_scoreboard  sco;

  mailbox #(apb_transaction) gen2drv_mbx;
  mailbox #(apb_transaction) mon2sco_mbx;

  virtual apb_if vif;

  function new(virtual apb_if vif);
    gen2drv_mbx = new();
    mon2sco_mbx = new();

    gen = new(gen2drv_mbx);
    drv = new(gen2drv_mbx);
    mon = new(mon2sco_mbx);
    sco = new(mon2sco_mbx);

    this.vif = vif;
    drv.vif  = this.vif;
    mon.vif  = this.vif;

    drv.drv_done = gen.drv_done;
    sco.sco_done = gen.sco_done;
  endfunction

  task pre_test();
    drv.reset();
  endtask

  task test();
    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_any
  endtask

  task post_test();
    gen.gen_done.get(1);
    sco.report();
    $finish();
  endtask

  task run();
    pre_test();
    test();
    post_test();
  endtask

endclass
