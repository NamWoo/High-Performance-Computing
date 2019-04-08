PROGRAM slash
INTEGER::index = 10
REAL::time=0.2, depth=10.0, amplitude=1.0, phase=3.1415
WRITE(*,100) index, time, depth, amplitude, phase
100 FORMAT('1',T20, 'Results for Test Number ',I3,///,&
    1X,'Time      =',F7.0/, &
    1x,'Depth     =',F7.1,' meter',/,&
    1x,'Amplitude =',F8.2/, &
    1x,'Phase     =',F7.1)
END PROGRAM slash

