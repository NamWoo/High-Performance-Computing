#include <stdio.h>
#include <unistd.h>
#include <time.h>
double WallTime()
{
    struct timespec tp;
    clock_gettime(CLOCK_REALTIME,&tp);
    return ((double)tp.tv_sec + (double)tp.tv_nsec * 1.e-9);
}

int main(void){
  int i,j;
  clock_t start,end;
  double stime, etime;
  double cpu_time, wallclock;
  stime=WallTime();
  sleep(1);
  etime=WallTime();
  wallclock=etime-stime;
  printf("Wallclock Time : %f\n",wallclock);

  start=clock();
  sleep(1);
  end=clock();
  cpu_time=((double)(end-start))/CLOCKS_PER_SEC;
  printf("CPU Time : %f\n",cpu_time);

  return 0;
}

