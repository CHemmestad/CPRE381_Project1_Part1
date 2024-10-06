add wave -noupdate -divider "{Special}"
add wave -noupdate -label CLK tb_MIPSDataPath2/CLK

add wave -noupdate -divider "{Single Bit Inputs}"
add wave -noupdate -label RESET tb_MIPSDataPath2/s_RST
add wave -noupdate -label nAdd_Sub tb_MIPSDataPath2/s_ADD_SUB
add wave -noupdate -label ALUSrc tb_MIPSDataPath2/s_ALU

add wave -noupdate -divider "{Multi-Bit Inputs}"
add wave -noupdate -radix unsigned -label ReadRegister1 tb_MIPSDataPath2/s_RS
add wave -noupdate -radix unsigned -label ReadRegister2 tb_MIPSDataPath2/s_RT
add wave -noupdate -radix unsigned -label WriteRegister tb_MIPSDataPath2/s_RD

add wave -noupdate -divider "{Immediate in decimal}"
add wave -noupdate -label i_Immediate -radix decimal tb_MIPSDataPath2/s_IMM

add wave -noupdate -divider "{Register Contents}"
add wave -noupdate -label Registers -radix decimal -expand tb_MIPSDataPath2/DUT0/RegisterFile/registerArray

run 1340
