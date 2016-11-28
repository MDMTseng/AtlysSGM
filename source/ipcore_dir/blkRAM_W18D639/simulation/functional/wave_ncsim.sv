

 
 
 




window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"

      waveform add -signals /blkRAM_W18D639_tb/status
      waveform add -signals /blkRAM_W18D639_tb/blkRAM_W18D639_synth_inst/bmg_port/CLKA
      waveform add -signals /blkRAM_W18D639_tb/blkRAM_W18D639_synth_inst/bmg_port/ADDRA
      waveform add -signals /blkRAM_W18D639_tb/blkRAM_W18D639_synth_inst/bmg_port/DINA
      waveform add -signals /blkRAM_W18D639_tb/blkRAM_W18D639_synth_inst/bmg_port/WEA
      waveform add -signals /blkRAM_W18D639_tb/blkRAM_W18D639_synth_inst/bmg_port/ENA
      waveform add -signals /blkRAM_W18D639_tb/blkRAM_W18D639_synth_inst/bmg_port/DOUTA

console submit -using simulator -wait no "run"
