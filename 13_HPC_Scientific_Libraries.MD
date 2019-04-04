
* 일정 : 2019/04/01 - 2019/04/04 (총 4일 중 4일차)
* 장소 : 한국과학기술정보연구원(대전 카이스트)


# 수치해석 라이브러리

```
/home01/sedu14/job_examples
hybrid_mvapich2.sh  hybrid_openmpi.sh  mpi.sh  openmp.sh  serial.sh

[sedu14@node8284 ee]$ echo $LD_LIBRARY_PATH

/opt/cray/lib64:/apps/compiler/gcc/7.2.0/openmpi/3.1.0/applib2/mic-knl/fftw_mpi/3.3.7/lib:/apps/compiler/gcc/7.2.0/openmpi/3.1.0/lib:/apps/compiler/gcc/7.2.0/applib1/mic-knl/lapack/3.7.0:/apps/compiler/gcc/7.2.0/lib64:/apps/compiler/gcc/7.2.0/lib/gcc/x86_64-unknown-linux-gnu/7.2.0:/apps/common/gmp/6.1.2/lib:/apps/common/mpfr/4.0.1/lib:/apps/common/mpc/1.1.0/lib:/opt/cray/lib64:

```

```fortran
program a
implicit none
integer::i
integer, parameter::n=6
real::x(n), y(n)
real::sdot,snrm2
do i= 1,n
        x(i)=real(i)
        y(i)=0.0
end do
call scopy(3,x,2,y,2)
print*, 'scopy:x=',x
print*, 'scopy:y=',y
call saxpy(n,2.0,x,1,y,1)
print*, 'saxpy:x=',x
print*, 'saxpy:y=',y
print*, 'norm2:x=',snrm2(n,x,1)
print*, 'norm2:y=',snrm2(n,y,1)
print*, 'x dot y:',sdot(n,x,1,y,1)
end program a
```


```
[sedu14@login04 ee]$ gfortran a.f90 -o a.x -L/apps/compiler/gcc/7.2.0/applib1/mic-knl/lapack/3.7.0 -lblas
```

x를 1부터 6까지 초기화 y는 0으로 초기화 

x copy인데 복사인데 



```fortran

program b
implicit none
integer::i,j,k
integer, parameter::n=2
real::alpha, beta, x(n), y(n), a(n,n)
data a /1,2,1,3/
alpha=2; beta=3

do i=1,n
        x(i)=real(i)
        y(i)=real(i+2)
end do

print*, 'initial:x=',x
print*, 'initial:y=',y
print*, 'initial:a='

do i= 1,n
        print*, (a(i,j),j=1,n)
end do

call sgemv('n',n,n,alpha,a,n,x,1,beta,y,1)
print*, 'sgemv:x=',x
print*, 'sgemv:y=',y
print*, 'sgemv:a'
do i=1,n
        print*,(a(i,j),j=1,n)
end do

call sger(n,n,alpha,x,1,y,1,a,n)
print*, 'sger:x=',x
print*, 'sger:y=',y
print*, 'sger:a'

do i=1,n
        print*,(a(i,j),j=1,n)
end do
end program b

```

```
[sedu14@login04 ee]$ time ./a.x
 initial:x=   1.00000000       2.00000000
 initial:y=   3.00000000       4.00000000
 initial:a=
   1.00000000       1.00000000
   2.00000000       3.00000000
 sgemv:x=   1.00000000       2.00000000
 sgemv:y=   15.0000000       28.0000000
 sgemv:a
   1.00000000       1.00000000
   2.00000000       3.00000000
 sger:x=   1.00000000       2.00000000
 sger:y=   15.0000000       28.0000000
 sger:a
   31.0000000       57.0000000
   62.0000000       115.000000

real    0m0.028s
user    0m0.012s
sys     0m0.015s

```
