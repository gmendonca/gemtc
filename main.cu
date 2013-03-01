#include "gemtc.cu"
#include "Tests/test-mc/tests.cu"
#include <cuda_runtime.h>

int main(int argc, char **argv){

  // creates two queues each size of half this param
  gemtcSetup(2560);

  // doing work on gpu
  int i;
  for(i=0; i<2; i++){
    //    int sleepTime = 6;
    // runs a task on the gpu
    //testArrayAvg();
    //testArrayMax();
    //testArrayMin();
    testAdd();
    printf("\n");
    //testVectorProduct();
    //testMatrixMultiply();
    //testMatrixTranspose();
    //testMatrixSquare();
    //testMatrixVector();
    //testMatrixInverse();
    //testStencil();
    //testBlackScholes();
    //void *ret = run(0, 32, &sleepTime, sizeof(int));
    //printf("%d : Finished job with parameter: %d\n",i, *(int *)ret);
  }

  // stops the superkernel and cleans up some memory
  gemtcCleanup();

  return 0;
}
