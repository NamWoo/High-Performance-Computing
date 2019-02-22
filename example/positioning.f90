PROGRAM positioning
CHARACTER(len=10):: first_name='James     '
CHARACTER::initial='R'
CHARACTER(len=16)::last_name='Johnson         '
CHARACTER(len=9)::class='COSC 2301'
INTEGER::grade=92
WRITE(*,100) first_name, initial, last_name, grade, class
100 FORMAT(1X,A10,1X,A1,1X,A10,4X,I3,T51,A9)
END PROGRAM positioning

