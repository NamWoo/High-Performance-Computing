PROGRAM character_ex
CHARACTER(LEN=17)::string = 'This is a string.'
WRITE(*,10) string
WRITE(*,11) string
WRITE(*,12) string
10 FORMAT(' ', A)
11 FORMAT(' ', A20)
12 FORMAT(' ', A6)
END PROGRAM character_ex

