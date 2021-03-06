; Generate the configuration files for the inversion from the options
; marked in the widget

pro generate_conf_files, info, action

; config_inversion.dat
	openr,2,'CONF/config_inversion.dat'
	str = strarr(57)
	readf,2,str
	close,2
	
	str(32) = "'"+info.obs_file+"'"	
	str(35) = "'"+info.output_file+"'"	
	str(47) = strtrim(string(info.verbose),2)
	str(50) = strtrim(string(info.linear_solver),2)
	str(53) = strtrim(string(info.rt_mode),2)
	str(56) = strtrim(string(action),2)
	
	openw,2,'config_inversion.dat',width=132
	for i = 0, 56 do begin
		printf,2,str(i)
	endfor	
	close,2

; J10
	openr,2,'ATOMS/helium_original.mod'
	str = strarr(44)
	readf,2,str
	close,2
	res = strsplit(str[19], ' ', /extract)
	str[19] = res[0]+'    '+res[1]+'    '+res[2]+'    '+res[3]+'    '+res[4]+'    '+res[5]+'    '+res[6]+'    '+info.j10
	openw,2,'ATOMS/helium.mod'
	for i = 0, 43 do begin
		printf,2,str[i]
	endfor
	close,2
	
; direct_range_10830.dat
	openr,2,'CONF/direct_range.dat'
	str = strarr(63)
	readf,2,str
	close,2
			
	str(5) = strtrim(string(info.dir_feval),2)
	str(8) = strtrim(string(info.dir_redvol),2)
	str(11) = strtrim(string(info.dir_range_bfield[0]),2)+'   '+strtrim(string(info.dir_range_bfield[1]),2)
	str(14) = strtrim(string(info.dir_range_thetab[0]),2)+'   '+strtrim(string(info.dir_range_thetab[1]),2)
	str(17) = strtrim(string(info.dir_range_chib[0]),2)+'   '+strtrim(string(info.dir_range_chib[1]),2)
	str(20) = strtrim(string(info.dir_range_vdopp[0]),2)+'   '+strtrim(string(info.dir_range_vdopp[1]),2)
	str(23) = strtrim(string(info.dir_range_tau[0]),2)+'   '+strtrim(string(info.dir_range_tau[1]),2)
	str(26) = strtrim(string(info.dir_range_depol[0]),2)+'   '+strtrim(string(info.dir_range_depol[1]),2)
	str(29) = strtrim(string(info.dir_range_vmacro[0]),2)+'   '+strtrim(string(info.dir_range_vmacro[1]),2)
	str(32) = strtrim(string(info.dir_range_damping[0]),2)+'   '+strtrim(string(info.dir_range_damping[1]),2)
	str(35) = strtrim(string(info.dir_range_beta[0]),2)+'   '+strtrim(string(info.dir_range_beta[1]),2)
	str(38) = strtrim(string(info.dir_range_height[0]),2)+'   '+strtrim(string(info.dir_range_height[1]),2)
	str(41) = strtrim(string(info.dir_range_tau2[0]),2)+'   '+strtrim(string(info.dir_range_tau2[1]),2)
	str(44) = strtrim(string(info.dir_range_vmacro2[0]),2)+'   '+strtrim(string(info.dir_range_vmacro2[1]),2)
	str(47) = strtrim(string(info.dir_range_bfield2[0]),2)+'   '+strtrim(string(info.dir_range_bfield2[1]),2)
	str(50) = strtrim(string(info.dir_range_thetab2[0]),2)+'   '+strtrim(string(info.dir_range_thetab2[1]),2)
	str(53) = strtrim(string(info.dir_range_chib2[0]),2)+'   '+strtrim(string(info.dir_range_chib2[1]),2)
	str(56) = strtrim(string(info.dir_range_vdopp2[0]),2)+'   '+strtrim(string(info.dir_range_vdopp2[1]),2)
	str(59) = strtrim(string(info.dir_range_ff[0]),2)+'   '+strtrim(string(info.dir_range_ff[1]),2)
	str(62) = strtrim(string(info.dir_range_beta2[0]),2)+'   '+strtrim(string(info.dir_range_beta2[1]),2)
	openw,2,'direct_range.dat',width=132
	for i = 0, 62 do begin
		printf,2,str(i)
	endfor	
	close,2
	
; init_parameters_10830.dat
	openr,2,'CONF/init_parameters.dat'
	str = strarr(60)
	readf,2,str
	close,2
		
	str(5) = strtrim(string(info.stimulated),2)
	str(8) = 1
	if (info.depol eq 0.d0) then begin
		str(11) = 0
	endif else begin
		str(11) = 1
	endelse
	str[14] = strtrim(string(info.depol),2)
	str[17] = strtrim(string(info.zeeman_pb),2)	
	str[20] = strtrim(string(info.number_slabs),2)

	if (info.number_slabs eq 1 or info.number_slabs eq 2) then begin
		str[23] = strtrim(string(info.Bfield),2)+'  '+strtrim(string(info.thetaB),2)+'  '+strtrim(string(info.chiB),2)
	endif
	if (info.number_slabs eq 3 or info.number_slabs eq -2) then begin
		str[23] = strtrim(string(info.Bfield),2)+'  '+strtrim(string(info.thetaB),2)+'  '+strtrim(string(info.chiB),2)+$
			'  '+strtrim(string(info.Bfield2),2)+'  '+strtrim(string(info.thetaB2),2)+'  '+strtrim(string(info.chiB2),2)
	endif
	
	str[26] = strtrim(string(info.height),2)
	
	if (info.number_slabs eq 1) then begin
		str(29) = strtrim(string(info.tau),2)
	endif
	if (info.number_slabs eq 2 or info.number_slabs eq 3) then begin
		str(29) = strtrim(string(info.tau),2)+' '+strtrim(string(info.tau2),2)
	endif
	if (info.number_slabs eq -2) then begin
		str(29) = strtrim(string(info.tau),2)+' '+strtrim(string(info.tau2),2)+' '+$
			strtrim(string(info.ff),2)
	endif
	
	str(32) = strtrim(string(info.source),2)
	str(35) = strtrim(string(info.boundary(0)),2)+' '+strtrim(string(info.boundary(1)),2)+' '+$
		strtrim(string(info.boundary(2)),2)+' '+strtrim(string(info.boundary(3)),2)
	str(38) = strtrim(string(info.multiplet),2)
	str(41) = strtrim(string(info.atom_pol),2)
	str(44) = strtrim(string(info.theta_obs),2)+'  '+strtrim(string(info.chi_obs),2)+'  '+strtrim(string(info.gamm_obs),2)
	
	wave = wavelength_component(info.atom,info.multiplet-1)

	if (info.number_slabs eq 1 or info.number_slabs eq 2) then begin
		str[50] = strtrim(string(wave),2)+'  '+strtrim(string(info.vdopp),2)+'  '+strtrim(string(info.damping),2)
	endif
	if (info.number_slabs eq 3 or info.number_slabs eq -2) then begin
		str[50] = strtrim(string(wave),2)+'  '+strtrim(string(info.vdopp),2)+'  '+strtrim(string(info.vdopp2),2)+$
			'  '+strtrim(string(info.damping),2)
	endif

	if (info.number_slabs eq 1) then begin
		str(53) = strtrim(string(info.vmacro),2)
	endif
	if (info.number_slabs eq 2 or info.number_slabs eq 3 or info.number_slabs eq -2) then begin
		str(53) = strtrim(string(info.vmacro),2)+' '+strtrim(string(info.vmacro2),2)
		str(32) = strtrim(string(info.source),2)+' '+strtrim(string(info.source2),2)
	endif
	
	str(56) = strtrim(string(info.mag_opt),2)
	str(59) = strtrim(string(info.stimulated),2)
	
	openw,2,'init_parameters.dat',width=132
	for i = 0, 59 do begin
		printf,2,str(i)
	endfor	
	close,2

; invert_parameters_10830.dat
	openr,2,'CONF/invert_parameters.dat'
	str = strarr(78)
	readf,2,str
	close,2
	
	str(5) = strtrim(string(info.itermax),2)
	str(8) = strtrim(string(info.ncycles),2)
	str(11) = strtrim(string(info.inv_bfield(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_bfield(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_bfield(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_bfield(3),FORMAT='(I1)'),2)+' '
				
	str(14) = strtrim(string(info.inv_thetaB(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_thetaB(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_thetaB(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_thetaB(3),FORMAT='(I1)'),2)+' '
				
	str(17) = strtrim(string(info.inv_chiB(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_chiB(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_chiB(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_chiB(3),FORMAT='(I1)'),2)+' '
				
	str(20) = strtrim(string(info.inv_vdopp(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_vdopp(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_vdopp(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_vdopp(3),FORMAT='(I1)'),2)+' '
				
	str(23) = strtrim(string(info.inv_tau(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_tau(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_tau(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_tau(3),FORMAT='(I1)'),2)+' '
				
	str(26) = strtrim(string(info.inv_depol(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_depol(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_depol(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_depol(3),FORMAT='(I1)'),2)+' '
				
	str(29) = strtrim(string(info.inv_vmacro(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_vmacro(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_vmacro(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_vmacro(3),FORMAT='(I1)'),2)+' '
				
	str(32) = strtrim(string(info.inv_damping(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_damping(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_damping(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_damping(3),FORMAT='(I1)'),2)+' '
				
	str(35) = strtrim(string(info.inv_source(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_source(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_source(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_source(3),FORMAT='(I1)'),2)+' '
				
	str(38) = strtrim(string(info.inv_height(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_height(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_height(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_height(3),FORMAT='(I1)'),2)+' '

	str(41) = strtrim(string(info.inv_tau2(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_tau2(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_tau2(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_tau2(3),FORMAT='(I1)'),2)+' '

	str(44) = strtrim(string(info.inv_vmacro2(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_vmacro2(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_vmacro2(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_vmacro2(3),FORMAT='(I1)'),2)+' '

	str(47) = strtrim(string(info.inv_Bfield2(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_Bfield2(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_Bfield2(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_Bfield2(3),FORMAT='(I1)'),2)+' '

	str(50) = strtrim(string(info.inv_thetab2(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_thetab2(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_thetab2(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_thetab2(3),FORMAT='(I1)'),2)+' '

	str(53) = strtrim(string(info.inv_chib2(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_chib2(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_chib2(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_chib2(3),FORMAT='(I1)'),2)+' '

	str(56) = strtrim(string(info.inv_vdopp2(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_vdopp2(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_vdopp2(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_vdopp2(3),FORMAT='(I1)'),2)+' '
				
	str(59) = strtrim(string(info.inv_ff(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_ff(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_ff(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_ff(3),FORMAT='(I1)'),2)+' '

	str(62) = strtrim(string(info.inv_source2(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_source2(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_source2(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inv_source2(3),FORMAT='(I1)'),2)+' '
				
	str(65) = strtrim(string(info.stI_weight(0)),2)+' '+$
				strtrim(string(info.stI_weight(1)),2)+' '+$
				strtrim(string(info.stI_weight(2)),2)+' '+$
				strtrim(string(info.stI_weight(3)),2)+' '
				
	str(68) = strtrim(string(info.stQ_weight(0)),2)+' '+$
				strtrim(string(info.stQ_weight(1)),2)+' '+$
				strtrim(string(info.stQ_weight(2)),2)+' '+$
				strtrim(string(info.stQ_weight(3)),2)+' '
				
	str(71) = strtrim(string(info.stU_weight(0)),2)+' '+$
				strtrim(string(info.stU_weight(1)),2)+' '+$
				strtrim(string(info.stU_weight(2)),2)+' '+$
				strtrim(string(info.stU_weight(3)),2)+' '
				
	str(74) = strtrim(string(info.stV_weight(0)),2)+' '+$
				strtrim(string(info.stV_weight(1)),2)+' '+$
				strtrim(string(info.stV_weight(2)),2)+' '+$
				strtrim(string(info.stV_weight(3)),2)+' '
				
	str(77) = strtrim(string(info.inversion_mode(0),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inversion_mode(1),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inversion_mode(2),FORMAT='(I1)'),2)+' '+$
				strtrim(string(info.inversion_mode(3),FORMAT='(I1)'),2)+' '

	openw,2,'invert_parameters.dat',width=132
	for i = 0, 77 do begin
		printf,2,str(i)
	endfor	
	close,2
	
end