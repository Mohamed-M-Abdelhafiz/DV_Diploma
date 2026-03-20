vlib work
vmap work work

vlog priority_enc4.v
vlog tb_priority_enc4.v

vsim -voptargs=+acc tb_priority_enc4

add wave *
coverage save -onexit coverage.ucdb

run -all
coverage report -details
