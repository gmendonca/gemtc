#ifndef _CPU_QUEUEJOBS_H_
#define _CPU_QUEUEJOBS_H_

struct JobDescription{
  int JobID;
  int JobType;
  int numThreads;
  void *params;
};
typedef struct JobDescription *JobPointer; //needed to make these volatile

struct QueueRecord {
  struct JobDescription *Array; //Order matters here, we should improve this later
  int Capacity;
  int Rear;
  int Front;
  int ReadLock;
};

typedef struct QueueRecord *Queue;

Queue CreateQueue(int MaxElements);
void DisposeQueue(Queue Q);
void EnqueueJob(JobPointer jobDescription, Queue Q);
JobPointer MaybeFandD(Queue Q);
JobPointer Front(Queue Q);
void Dequeue(Queue Q);

/*int openSpace(Queue Q){
  int temp = (Q->Front - ((Q->Rear+2)%Q->Capacity));
  while(temp<0) temp+=Q->Capacity;
  return temp;
}

void *movePointer(void *p, int n){
   char * ret = (char *) p;
   return ((void *)(ret+n));
}*/

#endif