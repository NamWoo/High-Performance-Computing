PROGRAM goto_ex
INTEGER::i=3
GOTO(10,20,30,40) i
10 PRINT*,'shape function in node 1'
   GOTO 50
20 PRINT*,'shape function in node 2'
   GOTO 50
30 PRINT*,'shape function in node 3'
   GOTO 50
40 PRINT*,'shape function in node 4'
   GOTO 50

PRINT*,'otherwise'
50 CONTINUE
END PROGRAM goto_ex

