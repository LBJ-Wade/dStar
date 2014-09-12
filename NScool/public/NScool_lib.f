module NScool_lib

    logical, save :: dbg = .FALSE.

contains
    subroutine NScool_init(my_dStar_dir,ierr)
        use NScool_private_def, only: NScool_private_def_init
!        use init, only: do_slab_init
        character(len=*), intent(in) :: my_dStar_dir
        integer, intent(out) :: ierr
        call NScool_private_def_init(my_dStar_dir)
        ierr = 0
    end subroutine NScool_init
    
    subroutine NScool_shutdown()
!        use init, only: do_NScool_shutdown
!         call do_NScool_shutdown
    end subroutine NScool_shutdown
    
    function alloc_NScool(ierr)
        use NScool_private_def, only: NScool_private_alloc
!         use init, only: alloc_NScool_data
        integer, intent(out) :: ierr
        integer :: alloc_NScool
        alloc_NScool = NScool_private_alloc(ierr)
!         alloc_NScool = alloc_NScool_data(ierr)
    end function alloc_NScool
    
!     subroutine dealloc_NScool(id,ierr)
!         use init, only: dealloc_NScool_data
!         integer, intent(in) :: id
!         integer, intent(out) :: ierr
!         call dealloc_NScool_data(id,ierr)
!     end subroutine dealloc_NScool

    ! read a namelist and set parameters
    subroutine NScool_setup(id,inlist,ierr)
       use NScool_ctrls_io, only: do_one_setup
       integer, intent(in) :: id
       character(len=*), intent(in) :: inlist
       integer, intent(out) :: ierr
       call do_one_setup(id,inlist,ierr)
    end subroutine NScool_setup
   
!     subroutine NScool_create_model(id,ierr)
!        use init, only: model_builder
!        integer, intent(in) :: id
!        integer, intent(out) :: ierr
!
!        call model_builder(id, ierr)
!     end subroutine NScool_create_model

end module NScool_lib
