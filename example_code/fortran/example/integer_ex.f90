PROGRAM integer_ex
INTEGER:: index = -12, junk=4, number=-12345
WRITE(*,200) index, index+12, junk, number
WRITE(*,210) index, index+12, junk, number
WRITE(*,220) index, index+12, junk, number
200 FORMAT(' ', 2I5,   I6, I10)
210 FORMAT(' ', 2I5.2, I6, I10.8)
220 FORMAT(' ', 2I5.3, I6, I5)
END PROGRAM integer_ex

