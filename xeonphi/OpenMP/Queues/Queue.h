#include <stdlib.h>

struct JobDescription{
  int JobID;
  int JobType;
  int numThreads;
  void *params;
};
typedef struct JobDescription *JobPointer; //needed to make these volatile

struct QueueRecord {
  JobPointer* Array; //Order matters here, we should improve this later
  int Capacity;
  int Rear;
  int Front;
  int ReadLock;
};

typedef struct QueueRecord *Queue;

int IsEmpty(Queue Q) {
  return (Q->Rear+1)%Q->Capacity == Q->Front;
}

int IsFull(Queue Q) {
  return (Q->Rear+2)%Q->Capacity == Q->Front;
}

int openSpace(Queue Q){
  int temp = (Q->Front - ((Q->Rear+2)%Q->Capacity));
  while(temp<0) temp+=Q->Capacity;
  return temp;
}

void *movePointer(void *p, int n){
   char * ret = (char *) p;
   return ((void *)(ret+n));
}