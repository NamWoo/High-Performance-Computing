PROGRAM real_ex
REAL:: a=-12.3, b=.123, c=123.456
WRITE(*,200) a, b, c
WRITE(*,210) a, b, c
200 FORMAT(' ', 2F6.3, F8.3)
210 FORMAT(' ', 3F10.2)
END PROGRAM real_ex

