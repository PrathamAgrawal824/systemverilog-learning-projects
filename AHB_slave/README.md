# AHB Slave Design and Verification

## Overview

This project implements an AMBA AHB slave with an internal 256-byte memory and a SystemVerilog class-based testbench for functional verification. The design supports single, incrementing, and wrapping burst transfers for both read and write operations.

## Features

* 32-bit AHB slave interface
* Internal 256-byte memory
* Single transfer support
* Incrementing bursts:

  * INCR
  * INCR4
  * INCR8
  * INCR16
* Wrapping bursts:

  * WRAP4
  * WRAP8
  * WRAP16
* Byte, half-word, and word transfers through `HSIZE`
* Address boundary handling for wrapping bursts
* Error response generation for invalid addresses
* Finite State Machine (FSM) based control logic

## Verification Environment

The testbench follows a class-based architecture using:

* Transaction class
* Generator
* Driver
* Monitor
* Scoreboard
* Mailbox-based communication
* Event synchronization between components
* Self-checking data comparison

The scoreboard maintains a reference memory model and validates read data against expected values.

## Files

* `RTL.txt` — AHB slave RTL implementation
* `TB.txt` — SystemVerilog verification environment
* `Output Waveform/` — Simulation waveforms and results

## Tools Used

* SystemVerilog
* EDA Playground
* Vivado 2018.2

## Learning Outcomes

* Understanding of the AMBA AHB protocol
* Implementation of burst transfer mechanisms
* Address wrapping and boundary calculations
* FSM-based bus slave design
* Development of class-based verification environments
* Mailbox and event-driven synchronization
* Self-checking scoreboards and functional validation

## Future Improvements

* Support for wait-state insertion
* Functional coverage collection
* Assertion-based verification (SVA)
* UVM-based migration of the verification environment
* Parameterized memory depth and data width
