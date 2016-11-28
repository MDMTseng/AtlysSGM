
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name VmodCAM_Ref_VGA_Split -dir "D:/Program/MYPRJ~1/HG_Sync/FPGA/fpgadisparity/DisPrj/source/planAhead_run_4" -part xc6slx45csg324-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "D:/Program/MYPRJ~1/HG_Sync/FPGA/fpgadisparity/DisPrj/source/atlys_vmodcam.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {ipcore_dir/blkRAM_W32D640_SP.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {iodrp_mcb_controller.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {iodrp_controller.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {mcb_soft_calibration.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {mcb_soft_calibration_top.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {mcb_raw_wrapper.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {SPI_slave.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {SPI_3BGroup_warpClkDomain.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {remote_sources/_/lib/digilent/Video.vhd}]]
set_property file_type VHDL $hdlfile
set_property library digilent $hdlfile
set hdlfile [add_files [list {remote_sources/_/lib/digilent/TWICtl.vhd}]]
set_property file_type VHDL $hdlfile
set_property library digilent $hdlfile
set hdlfile [add_files [list {remote_sources/_/lib/digilent/TMDSEncoder.vhd}]]
set_property file_type VHDL $hdlfile
set_property library digilent $hdlfile
set hdlfile [add_files [list {remote_sources/_/lib/digilent/SerializerN_1.vhd}]]
set_property file_type VHDL $hdlfile
set_property library digilent $hdlfile
set hdlfile [add_files [list {remote_sources/_/lib/digilent/LocalRst.vhd}]]
set_property file_type VHDL $hdlfile
set_property library digilent $hdlfile
set hdlfile [add_files [list {remote_sources/_/lib/digilent/InputSync.vhd}]]
set_property file_type VHDL $hdlfile
set_property library digilent $hdlfile
set hdlfile [add_files [list {PixDiff.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {PixCoordinator.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {memc3_wrapper.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ipcore_dir/dcm_recfg.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ipcore_dir/dcm_fixed.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {getMaxIdx.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ColorTranse.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {SysCon.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {remote_sources/_/lib/digilent/VideoTimingCtl.vhd}]]
set_property file_type VHDL $hdlfile
set_property library digilent $hdlfile
set hdlfile [add_files [list {remote_sources/_/lib/digilent/DVITransmitter.vhd}]]
set_property file_type VHDL $hdlfile
set_property library digilent $hdlfile
set hdlfile [add_files [list {hijacker.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {FBCtl.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {CamCtl.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {VmodCAM_Ref.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
add_files [list {SW1.ngc}]
add_files [list {SW2.ngc}]
add_files [list {ShiftReg_SW1.ngc}]
add_files [list {ShiftReg_SW2.ngc}]
add_files [list {asevweccv.ngc}]
add_files [list {sdsdsdasd.ngc}]
set_property top VmodCAM_Ref $srcset
add_files [list {atlys.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {timing.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {atlys_vmodcam.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {hijacker.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/blkRAM2.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/blkRAM_W32D640_SP.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/TestIPCore.ncf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx45csg324-3
