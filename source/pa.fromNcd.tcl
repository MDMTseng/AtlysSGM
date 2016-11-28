
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name VmodCAM_Ref_VGA_Split -dir "D:/Program/MYPRJ~1/HG_Sync/FPGA/fpgadisparity/DisPrj/source/planAhead_run_5" -part xc6slx45csg324-3
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "D:/Program/MYPRJ~1/HG_Sync/FPGA/fpgadisparity/DisPrj/source/VmodCAM_Ref.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/Program/MYPRJ~1/HG_Sync/FPGA/fpgadisparity/DisPrj/source} {ipcore_dir} }
add_files [list {ipcore_dir/blkRAM2.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/blkRAM_W16D638.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/blkRAM_W18D639.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/blkRAM_W32D640_SP.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/TestIPCore.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "D:/Program/MYPRJ~1/HG_Sync/FPGA/fpgadisparity/DisPrj/source/atlys_vmodcam.ucf" [current_fileset -constrset]
add_files [list {atlys.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {timing.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {atlys_vmodcam.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {hijacker.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "D:/Program/MYPRJ~1/HG_Sync/FPGA/fpgadisparity/DisPrj/source/VmodCAM_Ref.ncd"
if {[catch {read_twx -name results_1 -file "D:/Program/MYPRJ~1/HG_Sync/FPGA/fpgadisparity/DisPrj/source/VmodCAM_Ref.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"D:/Program/MYPRJ~1/HG_Sync/FPGA/fpgadisparity/DisPrj/source/VmodCAM_Ref.twx\": $eInfo"
}
