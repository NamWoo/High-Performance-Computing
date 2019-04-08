PROGRAM format_ex
INTEGER::i=10
REAL:: result=10.0
WRITE(*,100) i, result
100 FORMAT(' The result for iteration ', I3,' is ', F7.3)
END PROGRAM format_ex

