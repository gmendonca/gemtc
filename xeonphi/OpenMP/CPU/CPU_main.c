#include <stdio.h>
#include <stdlib.h>
#include "CPUgemtcOpenMP.h"
#include "Queue.h"
#include "omp.h"
//#include "CPUSuperkernel.c"

int kill;


int main(int argv, char **argc) {

   int numthreads = 1;
   int numTasks = 1;  //Must be multiple of loopSize (currently 100)
   long sleepTime = 1;
   int i, j;
   
   //Get these values from argc, if given
   if(argv>3){
      numthreads = atoi(argc[1]);
      numTasks = atoi(argc[2]);
      sleepTime = atol(argc[3]);
   }
   printf("Received parameters\n");

   int loopSize = 1;//Must be less than QueueSize (currently 1000)
   
   omp_set_num_threads(numthreads);
   struct Parameter_t *val = (struct Parameter_t *)malloc(sizeof(struct Parameter_t));
   
   #pragma omp parallel
   {
      #pragma omp single
      {
      val = CPU_gemtcSetup(1000, numthreads); //1000==QueueSize

      printf("Setup Done\n");
      }

      #pragma omp for
      for(i=0;i<numTasks;i++){
	 printf("Starting to send batch\n");
	 for(j=0;j<loopSize;j++){
	    CPU_gemtcPush(2,1,i,&sleepTime);
	    //superKernel(val);
	    //i++;
	 }
	// #pragma omp critical
	 //{
	 superKernel(val);
	 //}
	 #pragma omp barrier
	 printf("batch sent, starting to receive\n");
	 for(j=0;j<loopSize;j++){
	    JobPointer task;
	    do {
	       task = CPU_gemtcPoll();
	    }
	    while(task == NULL);
	    printf("Result from %d\n", task->JobID);
	    free(task);
	 }
	 printf("batch received\n");
	 
	 #pragma omp barrier
      }
   }
   printf("VOU LIMPAAAARRR\n");
   CPU_gemtcCleanup();
   printf("Cleanup done\n");
   return 0;
}