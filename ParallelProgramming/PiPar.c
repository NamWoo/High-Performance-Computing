#include <stdio.h>
#include <math.h>
#include <time.h>
#include <omp.h>
int main(){
  const long num_step = 500000000;
  long i;
  double sum, step, pi, x;
  time_t st, et;
  int tid, num_threads;
  step = (1.0/(double)num_step);
  sum = 0.0;
  time(&st);
  printf("--------------------------------------------\n");
#pragma omp parallel
#pragma omp for reduction(+:sum), private(x)
  for(i=1;i<=num_step;i++){
    x = ((double)i-0.5)*step;
	sum = sum + 4.0/(1.0 + x*x);
  }
  time(&et);

  pi = step * sum;
  printf("PI = %.15f (Error = %e)\n", pi, fabs(acos(-1.0)-pi));
  printf("Elapsed Time = %.3f [sec]\n", difftime(et,st));
  printf("-------------------------------------------\n");
  return 0;
}

