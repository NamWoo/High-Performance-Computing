SUBROUTINE s1(a,b,c,k, m, n)
REAL::a(100,100)     ! static
REAL::b(m,n)           ! adjustable
REAL::c(-10:20,k:n)  ! adjustable
REAL, DIMENSION(8,8)::a1
REAL, DIMENSION(64)::a2
REAL, DIMENSION(16,32)::a3
a1=a(1:8, 1:8)
a2=RESHAPE(a(1:8,1:8),(/64/))
a3=a(1:16,1:32)
CALL subby(a1)          ! ok
CALL subby(a2)          ! ok(1d  2d로 변환)
CALL subby(a3(::2,::4))             ! ok
CALL subby(reshape(a2,(/8,8/)))    ! ok
CONTAINS
    SUBROUTINE subby(exsp)
    IMPLICIT NONE
    REAL, DIMENSION(8,8)::exsp
    PRINT*, 'SIZE=', SIZE(exsp)
    PRINT*, 'SHAPE=', SHAPE(exsp)
    END SUBROUTINE subby
END SUBROUTINE s1

