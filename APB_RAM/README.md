# APB RAM Verification using SystemVerilog

## Overview

This project implements and verifies an APB-based RAM module using a SystemVerilog class-based verification environment. The design supports read and write transactions through the AMBA APB protocol and includes directed as well as randomized testing.

## Features

* APB-compliant RAM design
* Class-based verification environment
* Generator, Driver, Monitor, and Scoreboard architecture
* Mailbox-based communication
* Directed and random transaction generation
* Functional checking through a self-checking scoreboard
* Error reporting using PSLVERR
* Clean transaction-level debugging messages

## Files

* `apb_ram.sv` — APB RAM RTL design
* `apb_if.sv` — APB interface definition
* `apb_transaction.sv` — Transaction class
* `apb_generator.sv` — Stimulus generator
* `apb_driver.sv` — Driver implementation
* `apb_monitor.sv` — Monitor implementation
* `apb_scoreboard.sv` — Self-checking scoreboard
* `apb_environment.sv` — Environment integration
* `tb_directed.sv` — Directed test cases
* `tb_top.sv` — Top-level testbench

## Tools Used

* SystemVerilog
* Vivado 2018.2
* EDA playground

## Learning Outcomes

* Understanding of the APB protocol
* Development of class-based verification environments
* Usage of mailboxes for component communication
* Implementation of self-checking scoreboards
* Writing directed and constrained-random test scenarios
* Debugging protocol-level transactions
