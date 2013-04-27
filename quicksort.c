/*by Emanuel Valente - 26/04/2013
 * 
 * emanuel at gmail.com
 * 
 */


#include <stdlib.h>
#include <stdio.h>

int* createVector(int seed, int length, int max);
void printVector(int *vector,int length);

//quicksort
void quicksort(int *vector, int left, int right);
int partion(int *vector, int left, int right);
void swap(int *vector, int i, int j);

 
  
int main(int argc, char *argv[])
{
  int length, seed, max;
  int *vector;
  
  if(argc != 4)
  {
    printf("usage: %s <seed> <vector length> <element value range>\n", argv[0]);
    exit(1);
  }
  
  seed = atoi(argv[1]);
  length = atoi(argv[2]);
  max = atoi(argv[3]);
  
  vector = createVector(seed, length, max);
  
  printVector(vector, length);
  
  quicksort(vector, 0, length -1);
  
  printVector(vector, length);
  
  free(vector);
  
  return 0;
  
}

int* createVector(int seed, int length, int max)
{
  int *vector;
  int i;
  
  srand(seed);
  
  vector = (int*)malloc(sizeof(int) * length);
  
  for(i = 0; i < length; i++)
  {
    vector[i] = rand()%max;
  }
 
  
  return vector;
  
}

void printVector(int *vector, int length)
{
  int i;
  
  printf("Printing vector...\n\n");
  
  for(i = 0; i < length; i++)
  {
    printf("%d ", vector[i]);
  }
  
  printf("\n\n");
  
  
}

void quicksort(int *vector, int left, int right)
{
  int cuttof;
  
  if(right - left > 0) {
    cuttof = partition(vector, left, right);
    
    quicksort(vector, left, cuttof -1);
    quicksort(vector, cuttof +1, right);
  }
    
  
}

int partition(int *vector, int left, int right)
{
  int i, j;
  
  i = left;
  
  for(j = left + 1; j <= right; j++)
  {
    if(vector[left] > vector[j])
    {
      i++;
      swap(vector, i, j);
    }
    
  }
  
   swap(vector, left, i);
   
   return i;
    
  
}

void swap(int *vector, int i, int j)
{
  int aux;
  
  aux = vector[i];
  vector[i] = vector[j];
  vector[j] = aux;
  
}
 
 