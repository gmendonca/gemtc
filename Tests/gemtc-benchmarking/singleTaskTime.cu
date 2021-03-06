#include "../../gemtc.cu"

#include<stdio.h>

#include<stdlib.h>


int main(int argc, char **argv){

  int NUM_TASKS, SLEEP_TIME;

  if(argc>2){

    NUM_TASKS = atoi(argv[1]);

    SLEEP_TIME = atoi(argv[2]);

    printf("NUM_TASKS= %d\n", NUM_TASKS);
    printf("SLEEP_TIME= %d\n", SLEEP_TIME);

  }else{

    printf("This test requires two parameters:\n");

    printf("   int NUM_TASKS, SLEEP_TIME\n");

    printf("where  NUM_TASKS is the total numer of tasks to be run\n");

    printf("       SLEEP_TIME is the parameter that will be passed to each AddSleep, in microseconds\n");

    exit(1);

  }

  gemtcSetup(25600, 1);

  int j;

  for(j=0; j<NUM_TASKS; j++){ //Launch NUM_TASKS microkernels

    //    int i;

    //    for(i=0; i<1000; i++){

      int *d_sleepTime = (int *) gemtcGPUMalloc(sizeof(int));


      gemtcMemcpyHostToDevice(d_sleepTime, &SLEEP_TIME, sizeof(int));

      gemtcPush(0, 32, j, d_sleepTime);

      //    }

  }
  int i;
  for(i=0; i<NUM_TASKS; i++){ //Wait for NUM_TASKS results

    void *ret=NULL;

    int id;      

    while(ret==NULL){

      gemtcPoll(&id, &ret);

    }


    int h_sleepTime;

    gemtcMemcpyDeviceToHost(&h_sleepTime, ret, sizeof(int));

    printf("Recieved task %d\n", id);

    gemtcGPUFree(ret);

    ret = NULL;

  }
  gemtcCleanup();

  return 0;

}
