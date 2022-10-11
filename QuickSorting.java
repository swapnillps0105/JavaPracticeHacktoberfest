public class QuickSorting {
    static void Swap(int []array,int i,int j){
        int temp=array[i];
        array[i]=array[j];
        array[j]=temp;
    }
    static int Partition(int[] Array,int low,int high){
        int Pivot=Array[low];
        int i=low;
        int j=high;
        while(i<j){
            while (Array[i]<=Pivot) i++;
            while (Array[j]>Pivot) j--;
            if(i<j){
                Swap(Array,i,j);
            }
        }
        Swap(Array,j,low);
        return j;
    }
    static  void QuickSort(int []Array,int low,int high){
       if(low<high){
           int Pivot =Partition(Array,low,high);
           QuickSort(Array,low,Pivot-1);
           QuickSort(Array,Pivot+1,high);
       }
    }
    static void PrintArray(int[] array){
        for(Integer i :array){
            System.out.print(" "+i+" ");
        }
    }
    public static void main(String[] args){
       int []Array={4,6,2,5,7,9,1,3};
       int length=Array.length;
       QuickSort(Array,0,length-1);
       PrintArray(Array);

    }

}
