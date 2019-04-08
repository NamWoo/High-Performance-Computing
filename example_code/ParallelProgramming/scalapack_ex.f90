    program parallel_mv
    ! global arrays
    real, dimension(16,16) :: a
    real, dimension(16 ) :: b,y

! variable for BLACS initialization and processor grid creation
    integer iam,nprocs,ictxt,nprow,npcol,myrow,mycol

! variables needed for distributing global arrays across the 
! proc grid
    integer desca(9), descb(9),descy(9),m,n,mb,nb,rsrc,csrc
    integer llda, lldb,info

    ! local arrays
    real, dimension(8,8) :: la
    real, dimension(8) :: lb,ly

! Initializing the BLACS library
    call blacs_pinfo(iam,nprocs)
    call blacs_get(-1,0,ictxt)
! Creating and using the processor gred
    nprow=2; npcol=2
    call blacs_gridinit(ictxt,'r',nprow,npcol)
    call blacs_gridinfo(ictxt,nprow,npcol,myrow,mycol)

! Making the array descriptor vectors
    m=16; n=16
    mb=8; nb=8
    rsrc=0; csrc=0
    llda=8

    call descinit(desca,m,n,mb,nb,rsrc,csrc,ictxt,llda,info)
    n=1; nb=1; lldb=8
    call descinit(descb,m,n,mb,nb,rsrc,csrc,ictxt,lldb,info)
    call descinit(descy,m,n,mb,nb,rsrc,csrc,ictxt,lldb,info)

! Filling the global arrays A,b
    open(unit=12,file="a.dat")  
         read(12,*)  a
    open(unit=13,file="b.dat")
    read(13,*)  b

! Each processors fills in its local arrays with correct elements
    ! from the global arrays
    if(myrow.eq.0.and.mycol.eq.0) then
      do i_loc=1,8
        do j_loc=1,8
          la(i_loc,j_loc)=a(i_loc,j_loc)
        end do
        lb(i_loc)=b(i_loc)
      end do
    end if
    if(myrow.eq.1.and.mycol.eq.0)  then
      do i_loc=1,8
        do j_loc=1,8
          la(i_loc,j_loc)=a(i_loc+llda,j_loc)
             end do
       lb(i_loc)=b(i_loc+lldb)
      end do
    end if
    if(myrow.eq.0.and.mycol.eq.1)  then
      do i_loc=1,8
        do j_loc=1,8
          la(i_loc,j_loc)=a(i_loc,j_loc+llda)
        end do
      end do  
    end if

!=============
    if(myrow.eq.1.and.mycol.eq.1)  then
      do i_loc=1,8
        do j_loc=1,8
          la(i_loc,j_loc)=a(i_loc+llda,j_loc+llda)
        end do
      end do
    end if
!==============

! Call the ScaLAPACK loutine
      n=16
      call psgemv('n',m,n,1.0,la,1,1,desca,lb,1,1, &
                 descb,1,0.0,ly,1,1,descy,1)
! Each processor prints out its part of the product vector y
      if(myrow.eq.0.and.mycol.eq.0)  then
        do i=1,8
          print *,'PE:',myrow,mycol,' y(',i,')=' ,ly(i)
           end do
    end if
    if(myrow.eq.1.and.mycol.eq.0)  then
      do i=1,8
          print *,'PE:',myrow,mycol,' y(',i+lldb,')=' ,ly(i)
      end do
    end if

! Release the proc grid and BLACS library
    call blacs_gridexit(ictxt)
    call blacs_exit(0)

end program parallel_mv

