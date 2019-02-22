INTEGER :: Q(5,6), A(30), Q2(10,12), v1(10), v2(12) 
 
A = (/ 13,9,16,7,37,11,3,45,20,56,25,31,54,18,54, &
    2,14,36,19,66,1,52,15,8,77,9,27,20,19,90 /)
Q = RESHAPE((/A/), shape=(/5,6/))
PRINT*, 'Q ='
DO I = 1, 5
  PRINT*,Q(I,:)
ENDDO

PRINT*, ' 1 =',Q(:,2)
PRINT*, ' 2 =',Q(:2, 5:)
PRINT*, ' 3 =',Q(5,4:)
PRINT*, ' 4 =',Q(::2,2)

v1 = (/1,2,3,4,5,1,2,3,4,5/); v2 = (/((j, j=1,6), k =1, 2)/)          !
Subscript vector
Q2 = Q(v1, v2)                                                                     
PRINT*, ' Q2= ' 
DO I = 1, 10
   PRINT*, Q2(I,:)
ENDDO

END

