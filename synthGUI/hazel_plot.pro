;-----------------------------------------
; Plot the profiles
;-----------------------------------------
pro plot_profiles, stokes, state

; Multiterm code
	 if (state.which_code eq 0) then begin
	 
; He I
	 	if (state.which_atom eq 0) then begin
	 	   file_with_atom = 'ATOMS/helium.mod'
	 	endif	 
	 
; S I
	 	if (state.which_atom eq 1) then begin
	 	  	file_with_atom = 'ATOMS/sulfur.mod'
	 	endif
	 
; Na I
	 	if (state.which_atom eq 2) then begin
	 	   file_with_atom = 'ATOMS/sodium.mod'
	 	endif
	 endif
	 
; Multilevel with HFS
	 if (state.which_code eq 1) then begin
	 
; Na I HFS
	 	if (state.which_atom eq 0) then begin
	 	  	file_with_atom = 'ATOMS/sodium_hfs.mod'
	 	endif
	 endif
	 	 	 	 
	 wavelength = wavelength_atom_multiplet(file_with_atom,state.Multiplet)
	 
	 plot_observation = 0
	 if (file_test(state.obs_file) eq 1) then begin
		  obs = ddread(state.obs_file,offset=1,/count,/noverb)
		  change_symbol, 'circle', 0.3
		  plot_observation = 1
		  cwpal
	 endif
	 
	 angstrom = '!3' + STRING(197B) + '!X'	 
	 !p.multi = [0,2,2]
	 
	 xmin = min(stokes(0,*))
	 xmax = max(stokes(0,*))
	 
	 wl = stokes(0,*)
	 
	 abso = 1.d0
	 if (state.normaliz eq 0) then begin
	 	  abso = max(stokes(1,*)) - min(stokes(1,*))
	 	  label = 'peak'  
	 endif
	 if (state.normaliz eq 2) then begin
	 	  abso = stokes[1,0]
	 	  label = 'continuum'
	 endif
	 
	 plot,wl,stokes(1,*)/abso,xtit='Wavelength shift ['+angstrom+']',ytit='I/I!dmax!n',$
	 	thick=2,xsty=1,tit='!7k!6='+strtrim(string(wavelength),2)
	 
	 if (plot_observation eq 1) then begin

	 	absoObs = 1.0
	 	if (state.normaliz eq 0) then begin
	 		absoObs = max(obs(1,*)) - min(obs(1,*))
	 	endif
	 	if (state.normaliz eq 2) then begin
	 		absoObs = obs[1,0]
	 	endif

	 	oplot,obs(0,*),obs(1,*)/absoObs,psym=8,col=2
	 endif
	 	
	 
	 maxq = max(stokes(2,*)/abso)
	 minq = min(stokes(2,*)/abso)
	 maxu = max(stokes(3,*)/abso)
	 minu = min(stokes(3,*)/abso)
	 max = max([maxq,maxu])
	 min = min([minq,minu])
	 	 	 
    plot,wl,stokes(2,*)/abso,xtit='Wavelength shift ['+angstrom+']',ytit='Q/I!dmax!n',thick=2, yran=[min,max],xsty=1
	 if (plot_observation eq 1) then begin
	 	  oplot,obs(0,*),obs(2,*),psym=8,col=2
	 endif
    
	 plot,wl,stokes(3,*)/abso,xtit='Wavelength shift ['+angstrom+']',ytit='U/I!dmax!n',thick=2, yran=[min,max],xsty=1
	 if (plot_observation eq 1) then begin
	 	  oplot,obs(0,*),obs(3,*),psym=8,col=2
	 endif
    
	 max = max(stokes(4,*)/abso)
	 min = min(stokes(4,*)/abso)
	 plot,wl,stokes(4,*)/abso,xtit='Wavelength shift ['+angstrom+']',ytit='V/I!dmax!n',thick=2, yran=[min,max],xsty=1
	 if (plot_observation eq 1) then begin
	 	  oplot,obs(0,*),obs(4,*),psym=8,col=2
	 endif


	 if (state.postcript eq 2) then begin
		file = dialog_pickfile(PATH=state.path_save, GET_PATH=path_save)
		; state.path_save = path_save
		; widget_control, handler, SET_UVALUE=state
	endif


	if (state.postcript eq 2) then begin
		openw,2,file,width=132
		printf,2,n_elements(stokes[0,*]),'  "', label, '"'
		stokes[1:4,*] = stokes[1:4,*] / abso
		printf,2,stokes
		close,2
	endif
    
	 
	 !p.multi=0
end