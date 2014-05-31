program test_cond
	use phys_constants
	use nucchem_def
	use nucchem_lib
	use crust_eos_lib
	use conductivity_lib
	
	integer :: eos_handle,ierr,i,j
	! composition taken from HZ090 for Fe-chain accreted crust
	integer, dimension(6:14), parameter :: 	zz = [26,26,26,26,24,20,14,24,24], &
														&				aa = [56,56,56,56,56,56,46,96,96]
	real, dimension(6:14), parameter :: xn = [0.00,0.00,0.00,0.00,0.00,0.00,0.07,0.76,0.80]
	integer, dimension(2) :: Z,  N, chem_ids, charged_ids
	real, dimension(2) :: Y, Yion
	integer :: ncharged
	type(composition_info_type) :: ionic
	real :: chi,Xsum
	real, dimension(num_crust_eos_results) :: res
	
	call nucchem_init('../../data','crust_isotopes.data',ierr)
	call crust_eos_startup('../../data/crust_eos')
	eos_handle = alloc_crust_eos_handle(ierr)
	! components = .FALSE.
	! components(icrust_eos_ion) = .TRUE.
	! call crust_eos_set_components(eos_handle,components,ierr)
	
	do i = 6,14
		N = [1,aa(i)-zz(i)]
		Z = [0,zz(i)]
		chem_ids = [(get_nuclide_index_from_ZN(Z(j),N(j)),j=1,2)]

		Y = [xn(i),(1.0-xn(i))/real(aa(i))]
		call compute_composition_moments(2,chem_ids,Y,ionic,Xsum, &
			& ncharged, charged_ids, Yion, exclude_neutrons=.TRUE.)
		ionic% Q = 4.0
		call do_one(10.0**i)
	end do
	call clear_composition(ionic)
	call nucchem_shutdown
	contains
	subroutine do_one(rho)
		real, intent(in) :: rho
		real :: Gamma,eta,f,u,p,s,cv,chi_rho,chi_T
		integer :: phase
		real :: K, lgr, lgT, T, TpT
		type(conductivity_components) :: kappa
		type(crust_eos_component), dimension(num_crust_eos_components) :: eos_components
		integer :: ii
		
		lgr = log10(rho)
		chi = use_default_nuclear_size
		do ii = 1, 11
			lgT = 7.5 + (ii-1)/10.0
			T = 10.0**lgT
			call eval_crust_eos(eos_handle,rho,T,ionic, &
				& ncharged, charged_ids, Yion, res, phase, chi, eos_components)
			eta = res(i_Theta) !1.0/TpT
			Gamma = res(i_Gamma)
			call get_thermal_conductivity(rho,T,chi,Gamma,eta,ionic,kappa)
			print '(5f6.2,6es14.6)', &
			 	& lgr,lgT,ionic%Z,ionic%A,ionic%Yn,Gamma,kappa% total,kappa%ee,kappa%ei,kappa%eQ,kappa%sf
		end do
	end subroutine do_one
end program test_cond