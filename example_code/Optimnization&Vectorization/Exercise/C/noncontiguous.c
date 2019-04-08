void func(float *a, int n){
  int i,inc=1;
  for(i=0;i<n;i+=inc)
    a[i]*=2.0;
}

void func1(float *a, int n){
  int i,inc=2;
  for(i=0;i<n;i+=inc)
    a[i]*=2.0;
}

