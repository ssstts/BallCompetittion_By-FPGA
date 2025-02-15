transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {d:/intelfpga_lite/22.1/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {d:/intelfpga_lite/22.1/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {d:/intelfpga_lite/22.1/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {d:/intelfpga_lite/22.1/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {d:/intelfpga_lite/22.1/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/fiftyfivenm_ver
vmap fiftyfivenm_ver ./verilog_libs/fiftyfivenm_ver
vlog -vlog01compat -work fiftyfivenm_ver {d:/intelfpga_lite/22.1/quartus/eda/sim_lib/fiftyfivenm_atoms.v}
vlog -vlog01compat -work fiftyfivenm_ver {d:/intelfpga_lite/22.1/quartus/eda/sim_lib/mentor/fiftyfivenm_atoms_ncrypt.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Fan\ Ruixin/Quartus\ test/BallCompetition {D:/Fan Ruixin/Quartus test/BallCompetition/BallCompetition.v}
vlog -vlog01compat -work work +incdir+D:/Fan\ Ruixin/Quartus\ test/BallCompetition {D:/Fan Ruixin/Quartus test/BallCompetition/segment.v}
vlog -vlog01compat -work work +incdir+D:/Fan\ Ruixin/Quartus\ test/BallCompetition {D:/Fan Ruixin/Quartus test/BallCompetition/key_debounce.v}
vlog -vlog01compat -work work +incdir+D:/Fan\ Ruixin/Quartus\ test/BallCompetition {D:/Fan Ruixin/Quartus test/BallCompetition/Display.v}

vlog -vlog01compat -work work +incdir+D:/Fan\ Ruixin/Quartus\ test/BallCompetition {D:/Fan Ruixin/Quartus test/BallCompetition/BallCompetition_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  BallCompetition_tb

add wave *
view structure
view signals
run -all
