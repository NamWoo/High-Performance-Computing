
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


