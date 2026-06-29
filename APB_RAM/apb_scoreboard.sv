// Scoreboard
class apb_scoreboard;

  mailbox #(apb_transaction) mon2sco_mbx;
  semaphore sco_done;

  // Ref memory 
  bit [31:0] ref_mem [0:255];

  int pass_cnt = 0;
  int fail_cnt = 0;

  function new(mailbox #(apb_transaction) mon2sco_mbx);
    this.mon2sco_mbx = mon2sco_mbx;
    foreach (ref_mem[i]) ref_mem[i] = '0;
  endfunction

  task run();
    forever begin
      apb_transaction tr;
      mon2sco_mbx.get(tr);
      tr.display("SCO");

      // Case 1: invalid address -> expect PSLVERR
      if (tr.addr_type == ADDR_INVALID) begin
        if (tr.pslverr)
          pass(tr, "PSLVERR correctly asserted for invalid address");
        else
          fail(tr, "PSLVERR NOT asserted for invalid address");
      end

      // Case 2: valid address -> PSLVERR must NOT be set
      else if (tr.pslverr) begin
        fail(tr, "Unexpected PSLVERR for valid address");
      end

      // Case 3:  WRITE -> update ref memory
      else if (tr.op == WRITE) begin
        ref_mem[tr.paddr] = tr.pwdata;
        pass(tr, $sformatf("WRITE stored: mem[%0d] = 0x%0h", tr.paddr, tr.pwdata));
      end

      // Case 4:  READ -> compare ref memory
      else if (tr.op == READ) begin
        bit [31:0] expected = ref_mem[tr.paddr];
        if (tr.prdata == expected)
          pass(tr, $sformatf("READ match: mem[%0d] = 0x%0h", tr.paddr, expected));
        else
          fail(tr, $sformatf("READ MISMATCH: expected=0x%0h got=0x%0h", expected, tr.prdata));
      end

      $display("---------------------------------------------------------------------");
      sco_done.put(1);
    end
  endtask

  
  //////////////////////////////////////////////////////
  function void pass(apb_transaction tr, string msg);
    pass_cnt++;
    $display("[SCO] : PASS - %0s", msg);
  endfunction

  function void fail(apb_transaction tr, string msg);
    fail_cnt++;
    $display("[SCO] : FAIL - %0s", msg);
    tr.display("SCO-FAIL");
  endfunction

  function void report();
    $display("=======================================================================");
    $display("SCOREBOARD SUMMARY :  PASS = %0d   FAIL = %0d", pass_cnt, fail_cnt);
    $display("=======================================================================");
  endfunction

endclass
