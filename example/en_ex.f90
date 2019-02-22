PROGRAM en_ex
REAL::a=1234567.90, b=1.2e-7
WRITE(*,'(2(E15.5E1))')a,b
WRITE(*,'(2(E15.5E2))')a,b
WRITE(*,'(2(E15.5E3))')a,b
WRITE(*,'(A)')'======= ES ========='
WRITE(*,'(2(ES15.5E1))')a,b
WRITE(*,'(2(ES15.5E2))')a,b
WRITE(*,'(2(ES15.5E3))')a,b
WRITE(*,'(A)')'======= EN ========='
WRITE(*,'(2(EN15.5E1))')a,b
WRITE(*,'(2(EN15.5E2))')a,b
WRITE(*,'(2(EN15.5E3))')a,b
END PROGRAM en_ex

