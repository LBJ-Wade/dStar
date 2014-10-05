module NScool_ctrls_io
    use NScool_def
    include 'NScool_controls.inc'

    namelist /controls/ &
        load_model_file, & 
        model_file, & 
        write_interval_for_terminal, & 
        write_interval_for_terminal_header, & 
        write_interval_for_history, & 
        write_interval_for_profile, & 
        output_directory, & 
        which_solver, & 
        maximum_number_of_models, & 
        maximum_timestep, & 
        maximum_end_time, & 
        extra_real_controls, & 
        extra_integer_controls, & 
        extra_logical_controls, & 
        fix_core_temperature, & 
        core_temperature, & 
        fix_atmosphere_temperature_when_accreting, & 
        atmosphere_temperature_when_accreting, &
        Mdot, &
        core_mass, &
        core_radius, &
        lgPcrust_bot, &
        lgPcrust_top, &
        target_resolution_lnP,  &
        lgP_min_heating_outer, &
        lgP_max_heating_outer, &
        Q_heating_outer, &
        lgP_min_heating_inner, &
        lgP_max_heating_inner, &
        Q_heating_inner, &
        turn_on_shell_Urca, &
        shell_Urca_luminosity_coeff, &
        lgP_shell_Urca, &
        lg_atm_light_element_column, &
        fix_Qimp, &
        Qimp
        
contains
    subroutine do_one_setup(id,inlist,ierr)
        integer, intent(in) :: id
        character(len=*), intent(in) :: inlist
        integer, intent(out) :: ierr
        type(NScool_info), pointer :: s
        
        call get_NScool_info_ptr(id,s,ierr)
        if (ierr /= 0) return
        call set_default_controls
        call read_controls(id,inlist,ierr)
        call store_controls(s, ierr)
    end subroutine do_one_setup

    subroutine read_controls(id,filename,ierr)
       integer, intent(in) :: id
       character(len=*), intent(in) :: filename
       integer, intent(out) :: ierr
       type(NScool_info), pointer :: s
       integer :: iounit
      
       ierr = 0
       call get_NScool_info_ptr(id,s,ierr)
       if (ierr /= 0) return
      
       if (len_trim(filename) > 0) then
          open (newunit=iounit,file=trim(filename),  &
          & action='read', delim='quote', status='old', iostat=ierr)
          if (ierr /= 0) then
             write(*,*) 'failed to open control namelist file ',trim(filename)
             return
          end if
          read(iounit,nml=controls,iostat=ierr)
          close(iounit)
          if (ierr /= 0) then
             write(*,'(///,a)') 'failed while reading control namelist file '//trim(filename)
          end if
       end if
    end subroutine read_controls
   
    subroutine set_default_controls()
       include 'controls.defaults'
    end subroutine set_default_controls

    subroutine store_controls(s,ierr)
        use constants_def, only : Msun, secyer
       use num_lib, only : solver_option
       type(NScool_info), pointer :: s
       integer, intent(out) :: ierr
      
       ierr = 0

       s% load_model_file = load_model_file
       s% model_file = model_file
       s% write_interval_for_terminal = write_interval_for_terminal
       s% write_interval_for_terminal_header = write_interval_for_terminal_header
       s% write_interval_for_history = write_interval_for_history
       s% write_interval_for_profile = write_interval_for_profile
       s% output_directory = output_directory
       s% which_solver = trim(which_solver) !solver_option(trim(which_solver),ierr)
       if (ierr /= 0) then
           write (*,*) 'unable to parse solver option'
           return
       end if
       
       s% base_profile_filename = trim(s% output_directory)//'/profile'
       s% history_filename = trim(s% output_directory)//'/history.data'
       
       s% maximum_number_of_models = maximum_number_of_models
       s% maximum_timestep = maximum_timestep
       s% maximum_end_time = maximum_end_time
       s% extra_real_controls = extra_real_controls
       s% extra_integer_controls = extra_integer_controls
       s% extra_logical_controls = extra_logical_controls
       s% fix_core_temperature = fix_core_temperature
       s% core_temperature = core_temperature
       s% fix_atmosphere_temperature_when_accreting = fix_atmosphere_temperature_when_accreting
       s% atmosphere_temperature_when_accreting = atmosphere_temperature_when_accreting
       s% Mdot = Mdot
       s% Mcore = core_mass
       s% Rcore = core_radius
       s% Psurf = 10.0**lgPcrust_top
       s% Pcore = 10.0**lgPcrust_bot
       s% target_resolution_lnP = target_resolution_lnP
       s% Tcore = core_temperature
       s% lgP_min_heating_outer = lgP_min_heating_outer
       s% lgP_max_heating_outer = lgP_max_heating_outer
       s% Q_heating_outer = Q_heating_outer
       s% lgP_min_heating_inner = lgP_min_heating_inner
       s% lgP_max_heating_inner = lgP_max_heating_inner
       s% Q_heating_inner = Q_heating_inner
       s% turn_on_shell_Urca = turn_on_shell_Urca
       s% shell_Urca_luminosity_coeff = shell_Urca_luminosity_coeff
       s% lgP_shell_Urca = lgP_shell_Urca
       
       s% lg_atm_light_element_column = lg_atm_light_element_column
       s% fix_Qimp = fix_Qimp
       s% Qimp = Qimp

   end subroutine store_controls
   
   subroutine write_controls(io,ierr)
       integer, intent(in) :: io
       integer, intent(out) :: ierr
       write(io,nml=controls,iostat=ierr)
   end subroutine write_controls
   
end module NScool_ctrls_io
