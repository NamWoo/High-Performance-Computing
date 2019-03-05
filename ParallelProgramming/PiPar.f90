program main
use omp_lib
implicit none  
integer*8,parameter :: num_step = 500000000
integer*8           :: i
real(kind=8)        :: sum,step,pi,x
real(kind=4)        :: stime,etime
integer             :: tid, num_threads
step = (1.0d0/dble(num_step))
sum  = 0.0d0
write(*,400) 
call cpu_time(stime)  ! starting time

!$OMP PARALLEL PRIVATE(tid,x)
   tid=OMP_GET_THREAD_NUM()
   num_threads=OMP_GET_NUM_THREADS()
   write(*,10) tid, num_threads
!$OMP DO REDUCTION(+:sum)
do i=1,num_step
  x   = (dble(i)-0.5d0)*step   
  sum = sum + 4.d0/(1.d0+x*x)  ! F(x)
enddo
!$OMP END DO
!$OMP END PARALLEL
call cpu_time(etime)  !ending time 
pi = step * sum
write(*,100) pi,dabs(dacos(-1.0d0)-pi)
write(*,300) etime-stime
write(*,400) 
10   format(' My thread ID =',I3,', Total',I3,' threads are activated')
100  format(' PI = ', F17.15,' (Error =',E11.5,')')
300  format(' Elapsed Time = ',F8.3,' [sec] ')
400  format('-------------------------------------------')
stop
end program

