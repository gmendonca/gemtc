#include <stdlib.h>
#include "Queue.h"
#include <stdio.h>
#include "omp.h"

////////////////////////////////////////////////////////////
// Constructor and Deconsturctor
////////////////////////////////////////////////////////////

Queue CreateQueue(int MaxElements) {
   Queue Q = (Queue) malloc (sizeof(struct QueueRecord));

   Q->Array = (struct JobDescription *) malloc(sizeof(struct JobDescription)*MaxElements);
  
   Q->Capacity = MaxElements;
   Q->Front = 1;
   Q->Rear = 0;
   Q->ReadLock = 0;
  
  return Q;
}

void DisposeQueue(Queue Q) {
  free(Q->Array);
  free(Q);
}

////////////////////////////////////////////////////////////
// Host Functions to Change Queues
////////////////////////////////////////////////////////////

void EnqueueJob(JobPointer jobDescription, Queue Q) {
//called by CPU
   int temp;
   omp_lock_t writelock;

   omp_init_lock(&writelock);

   while (IsFull(Q));

   omp_set_lock(&writelock);
   //#pragma omp critical
   //{ 
      // floating point exception from mod capacity if 0 or -n
      temp = (Q->Rear+1)%(Q->Capacity);
      
      // set job description
      Q->Array[temp] = *jobDescription;
      Q->Rear = temp;
   //}
   omp_unset_lock(&writelock);

   return;
}

JobPointer MaybeFandD(Queue Q){

   omp_lock_t writelock;

   omp_init_lock(&writelock);
   
      if(IsEmpty(Q)){
	 return NULL;
      }else{
	 omp_set_lock(&writelock);
	 if (IsEmpty(Q)) {
	    omp_unset_lock(&writelock);
	    return NULL;
	 }
	 JobPointer result = (JobPointer) malloc(sizeof(JobPointer));
	 //Maybe it will need another IsEmpty test here
	 //JobPointer result = (JobPointer) malloc(sizeof(JobPointer));
	 *result = Q->Array[Q->Front];
	 Q->Front = (Q->Front+1)%(Q->Capacity);
	 omp_unset_lock(&writelock);
	 //printf("JobID = %d\nJobType = %d\n", result->JobID, result->JobType);
	 //printf("Thread = %d\n", omp_get_thread_num());
	 return result;
      }
}

JobPointer Front(Queue Q) {
  while(IsEmpty(Q));
   /*if (IsEmpty(Q)) {
      printf ("Front error!!!\n");
      exit(1);
   }*/
  JobPointer result = (JobPointer) malloc(sizeof(JobPointer));
  *result = Q->Array[Q->Front];
  return result;
}

void Dequeue(Queue Q) {
//called by CPU
  while(IsEmpty(Q));
   /*if (IsEmpty(Q)) {
      printf ("Dequeue error!!!\n");
      exit(1);
   }*/
  Q->Front = (Q->Front+1)%(Q->Capacity);
   return;
}


int IsEmpty(Queue Q) {
  return (Q->Rear+1)%Q->Capacity == Q->Front;
}

int IsFull(Queue Q) {
  return (Q->Rear+2)%Q->Capacity == Q->Front;
}








