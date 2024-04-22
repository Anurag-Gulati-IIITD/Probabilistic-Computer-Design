onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pbit_tb/CLK
add wave -noupdate /pbit_tb/RST
add wave -noupdate /pbit_tb/MODE
add wave -noupdate /pbit_tb/valid_in
add wave -noupdate /pbit_tb/in1
add wave -noupdate /pbit_tb/in2
add wave -noupdate /pbit_tb/op
add wave -noupdate /pbit_tb/res
add wave -noupdate /pbit_tb/multiplier_inst/psl_inst/in_reverse
add wave -noupdate /pbit_tb/valid_res
add wave -noupdate -expand /pbit_tb/multiplier_inst/mri_inst/count
add wave -noupdate /pbit_tb/multiplier_inst/psl_inst/psl_out
add wave -noupdate /pbit_tb/multiplier_inst/psl_inst/out
add wave -noupdate /pbit_tb/multiplier_inst/psl_inst/temp_out
add wave -noupdate /pbit_tb/multiplier_inst/psl_inst/z
add wave -noupdate /pbit_tb/multiplier_inst/psl_inst/temp_z
add wave -noupdate /pbit_tb/multiplier_inst/psl_inst/update_sequence
add wave -noupdate /pbit_tb/multiplier_inst/mri_inst/upd_count
add wave -noupdate /pbit_tb/multiplier_inst/mri_inst/decision_count
add wave -noupdate /pbit_tb/multiplier_inst/mri_inst/P2
add wave -noupdate /pbit_tb/multiplier_inst/mri_inst/P3
add wave -noupdate /pbit_tb/multiplier_inst/pending_request
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24023803 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 291
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {105 us}
