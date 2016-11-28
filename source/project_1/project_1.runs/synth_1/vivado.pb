
[
 Attempting to get a license: %s
78*common2"
Implementation2default:defaultZ17-78
Y
Failed to get a license: %s
295*common2"
Implementation2default:defaultZ17-301
Ð
¹WARNING: No 'Implementation' license found. This message may be safely ignored if a Vivado WebPACK or device-locked license, common for board kits, will be used during implementation.

4*vivadoZ15-19
V
 Attempting to get a license: %s
78*common2
	Synthesis2default:defaultZ17-78
T
Failed to get a license: %s
295*common2
	Synthesis2default:defaultZ17-301
ƒ
+Loading parts and site information from %s
36*device2?
+C:/Xilinx/Vivado/2013.4/data/parts/arch.xml2default:defaultZ21-36

!Parsing RTL primitives file [%s]
14*netlist2U
AC:/Xilinx/Vivado/2013.4/data/parts/xilinx/rtl/prims/rtl_prims.xml2default:defaultZ29-14
™
*Finished parsing RTL primitives file [%s]
11*netlist2U
AC:/Xilinx/Vivado/2013.4/data/parts/xilinx/rtl/prims/rtl_prims.xml2default:defaultZ29-11
5
Refreshing IP repositories
234*coregenZ19-234
>
"No user IP repositories specified
1154*coregenZ19-1704
s
"Loaded Vivado IP repository '%s'.
1332*coregen23
C:/Xilinx/Vivado/2013.4/data/ip2default:defaultZ19-2313
o
Command: %s
53*	vivadotcl2G
3synth_design -top VmodCAM_Ref -part xc7k70tfbg676-12default:defaultZ4-113
/

Starting synthesis...

3*	vivadotclZ4-3
¯
%IP '%s' is locked. Locked reason: %s
1260*coregen2
	dcm_recfg2default:default2M
9Property 'IS_LOCKED' is set to true by the system or user2default:defaultZ19-2162
¯
%IP '%s' is locked. Locked reason: %s
1260*coregen2
	dcm_fixed2default:default2M
9Property 'IS_LOCKED' is set to true by the system or user2default:defaultZ19-2162
•
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2default:default2
xc7k70t2default:defaultZ17-347
…
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2default:default2
xc7k70t2default:defaultZ17-349
–
%s*synth2†
rStarting Synthesize : Time (s): cpu = 00:00:07 ; elapsed = 00:00:07 . Memory (MB): peak = 319.684 ; gain = 66.414
2default:default
á
%s is not a %s998*oasys2
hijacker2default:default2
entity2default:default2a
KD:/Program/MYPRJ~1/HG_Sync/FPGA/fpgadisparity/DisPrj/source/VmodCAM_Ref.vhd2default:default2
1432default:default8@Z8-998
‰
Sactual for formal port %s is neither a static name nor a globally static expression1565*oasys2
red_i2default:default2a
KD:/Program/MYPRJ~1/HG_Sync/FPGA/fpgadisparity/DisPrj/source/VmodCAM_Ref.vhd2default:default2
2792default:default8@Z8-1565
‹
Sactual for formal port %s is neither a static name nor a globally static expression1565*oasys2
green_i2default:default2a
KD:/Program/MYPRJ~1/HG_Sync/FPGA/fpgadisparity/DisPrj/source/VmodCAM_Ref.vhd2default:default2
2802default:default8@Z8-1565
Š
Sactual for formal port %s is neither a static name nor a globally static expression1565*oasys2
blue_i2default:default2a
KD:/Program/MYPRJ~1/HG_Sync/FPGA/fpgadisparity/DisPrj/source/VmodCAM_Ref.vhd2default:default2
2812default:default8@Z8-1565
á
&unit %s ignored due to previous errors2810*oasys2

behavioral2default:default2a
KD:/Program/MYPRJ~1/HG_Sync/FPGA/fpgadisparity/DisPrj/source/VmodCAM_Ref.vhd2default:default2
1052default:default8@Z8-2810
–
%s*synth2†
rFinished Synthesize : Time (s): cpu = 00:00:08 ; elapsed = 00:00:08 . Memory (MB): peak = 347.066 ; gain = 93.797
2default:default
L
Releasing license: %s
83*common2
	Synthesis2default:defaultZ17-83
¼
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
52default:default2
32default:default2
02default:default2
12default:defaultZ4-41
E

%s failed
30*	vivadotcl2 
synth_design2default:defaultZ4-43
W
Command failed: %s
69*common2+
Vivado Synthesis failed2default:defaultZ17-69
w
Exiting %s at %s...
206*common2
Vivado2default:default2,
Wed Sep 17 11:03:04 20142default:defaultZ17-206