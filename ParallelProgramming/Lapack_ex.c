#include <stdio.h>
#define size 3				/* 행렬의 차수 */
void sgesv_(int*,int*,float*, int*,int*,float*,int*,int*);
void main()
{
     int i, j , c1, c2, pivot[size], ok;
     float A[size][size], b[size], AT[size*size];	
                                 /* single precision!!! */
     A[0][0]=3.1;  A[0][1]=1.3;  A[0][2]=-5.7;	/* 행렬 A */
     A[1][0]=1.0;  A[1][1]=-6.9; A[1][2]=5.8;
     A[2][0]=3.4;  A[2][1]=7.2;  A[2][2]=-8.8;	 
    
     b[0]=-1.3;
     b[1]=-0.1;
     b[2]=1.8;

for (i=0; i<size; i++)	/* 저장방식의 차이 때문에 행렬의 변환필요 */
    {
           for(j=0; j<size; j++) AT[j+size*i]=A[j][i];
    }
    c1=size;
    c2=1;    			
    /* LAPACK루틴(SGESV)을 이용해 해를 구함*/
    sgesv_(&c1, &c2, AT, &c1, pivot, b, &c1, &ok);
     for (j=0; j<size; j++) printf("%e\n", b[j]);	
} 

