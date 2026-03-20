vdel -all

vlib work
vmap work work

vlog alu_de.v
vlog tb_alu.v

vsim -voptargs=+acc tb

add wave *

run -all

coverage report -details

quit -f
