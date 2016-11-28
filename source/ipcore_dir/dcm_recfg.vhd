-- file: dcm_recfg.vhd
-- 
-- (c) Copyright 2008 - 2011 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
------------------------------------------------------------------------------
-- User entered comments
------------------------------------------------------------------------------
-- None
--
------------------------------------------------------------------------------
-- "Output    Output      Phase     Duty      Pk-to-Pk        Phase"
-- "Clock    Freq (MHz) (degrees) Cycle (%) Jitter (ps)  Error (ps)"
------------------------------------------------------------------------------
-- CLK_OUT1___108.000______0.000_______N/A______237.037________N/A
--
------------------------------------------------------------------------------
-- "Input Clock   Freq (MHz)    Input Jitter (UI)"
------------------------------------------------------------------------------
-- __primary_________100.000____________0.010

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity dcm_recfg is
port
 (-- Clock in ports
  CLK_IN1           : in     std_logic;
  -- Clock out ports
  CLK_OUT1          : out    std_logic;
  -- Dynamic reconfiguration ports
  PROGCLK           : in     std_logic;
  PROGEN            : in     std_logic;
  PROGDATA          : in     std_logic;
  PROGDONE          : out    std_logic;
  -- Status and control signals
  RESET             : in     std_logic;
  LOCKED            : out    std_logic
 );
end dcm_recfg;

architecture xilinx of dcm_recfg is
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of xilinx : architecture is "dcm_recfg,clk_wiz_v3_2,{component_name=dcm_recfg,use_phase_alignment=false,use_min_o_jitter=false,use_max_i_jitter=false,use_dyn_phase_shift=false,use_inclk_switchover=false,use_dyn_reconfig=true,feedback_source=FDBK_AUTO,primtype_sel=DCM_CLKGEN,num_out_clk=1,clkin1_period=10.0,clkin2_period=10.0,use_power_down=false,use_reset=true,use_locked=true,use_inclk_stopped=false,use_status=false,use_freeze=false,use_clk_valid=false,feedback_type=SINGLE,clock_mgr_type=AUTO,manual_override=false}";
  -- Input clock buffering / unused connectors
  signal clkin1            : std_logic;
  -- Output clock buffering / unused connectors
  signal clkfx             : std_logic;
  signal clkfx180_unused   : std_logic;
  signal clkfxdv_unused    : std_logic;
  signal clkfbout          : std_logic;
  signal locked_internal   : std_logic;
  signal status_internal   : std_logic_vector(2 downto 1);

begin


  -- Input buffering
  --------------------------------------
  clkin1 <= CLK_IN1;


  -- Clocking primitive
  --------------------------------------
  -- Instantiation of the DCM primitive
  --    * Unused inputs are tied off
  --    * Unused outputs are labeled unused
  dcm_clkgen_inst: DCM_CLKGEN
  generic map
   (CLKFXDV_DIVIDE        => 2,
    CLKFX_DIVIDE          => 25,
    CLKFX_MULTIPLY        => 27,
    SPREAD_SPECTRUM       => "NONE",
    STARTUP_WAIT          => FALSE,
    CLKIN_PERIOD          => 10.0,
    CLKFX_MD_MAX          => 0.000)
  port map
   -- Input clock
   (CLKIN                 => clkin1,
    -- Output clocks
    CLKFX                 => clkfx,
    CLKFX180              => clkfx180_unused,
    CLKFXDV               => clkfxdv_unused,
   -- Ports for dynamic phase shift
    PROGCLK               => PROGCLK,
    PROGEN                => PROGEN,
    PROGDATA              => PROGDATA,
    PROGDONE              => PROGDONE,
   -- Other control and status signals
    FREEZEDCM             => '0',
    LOCKED                => locked_internal,
    STATUS                => status_internal,
    RST                   => RESET);

  LOCKED                <= locked_internal;

  -- Output buffering
  -------------------------------------


  clkout1_buf : BUFG
  port map
   (O   => CLK_OUT1,
    I   => clkfx);



end xilinx;
