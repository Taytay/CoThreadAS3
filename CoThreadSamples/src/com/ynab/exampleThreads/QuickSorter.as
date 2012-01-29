// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.exampleThreads
{
	import com.ynab.coroutine.CoRoutineContext;
	import com.ynab.coroutine.CoThread;
	import com.ynab.ITextWriter;
	
	//This is a little test class to show how a synchronous recursive function can be
	//rewritten to be asynchronous
	public class QuickSorter
	{
		public function QuickSorter()
		{
		}
		
		
		//This blocking function has been rewritten below to be asynchronous
		public static function quickSort(arrayInput : Array, left : int, right : int) : void
		{
			var i : int = left;
			var j : int = right;
			var pivotPoint : int = arrayInput[Math.round((left+right)*.5)];
			// Loop
			while (i<=j) 
			{
				while (arrayInput[i]<pivotPoint) 
				{
					i++;
				}
				while (arrayInput[j]>pivotPoint) 
				{
					j--;
				}
				if (i<=j) 
				{
					var tempStore : int = arrayInput[i];
					arrayInput[i] = arrayInput[j];
					i++;
					arrayInput[j] = tempStore;
					j--;
				}
			}
			// Swap
			if (left<j) 
			{
				quickSort(arrayInput, left, j);
			}
			if (i<right) 
			{
				quickSort(arrayInput, i, right);
			}
			return;
		}
		
		
		
		private static var writerThrottle : int = 0; 
		
		//I found an example quicksort algorithm here:http://www.kirupa.com/developer/actionscript/quickSort.htm
		public static function quickSortAsync(arrayInput : Array, left : int, right : int, textWriter : ITextWriter, context : CoRoutineContext) : void
		{
			var i : int = left;
			var j : int = right;
			var pivotPoint : int = arrayInput[Math.round((left+right)*.5)];
			
			if (++writerThrottle % 100 == 0)
			{
				writerThrottle = 1;
				textWriter.writeLine(CoThread.currentThread.toString()+ ": Prcessing quicksort : "+left + ", "+right);
			}
			//We do an infinite loop
			//But we can return false if we want to stop our loop
			context.infiniteLoop(function() : Boolean
			{
				if (i > j)			
				{
					//Break from the loop
					return false;
				}
				
				//I am not breaking these out into separate functions
				//because my assumption is that we can do this in less than our time slice, 
				//even if we have a lot of values to examine. 
				//But, if we wanted to, we could use the context.doWhileLoop to break up even these inner loops
				while (arrayInput[i]<pivotPoint) 
				{
					i++;
				}
				while (arrayInput[j]>pivotPoint) 
				{
					j--;
				}
				if (i<=j) 
				{
					var tempStore : int = arrayInput[i];
					arrayInput[i] = arrayInput[j];
					i++;
					arrayInput[j] = tempStore;
					j--;
				}
				//We return true to tell it to keep going
				return true;
			},
				//We don't need a this pointer, (we're in a static method after all) so we pass null in
				null, 
				//When the above loop is done, the following function will be called
				//we name it for convenience
				function afterAboveLoop() : void
				{
					if (left<j) 
					{
						//Call ourselves again
						quickSortAsync(arrayInput, left, j, textWriter,
							//And when we are done with the call to quickSortAsync, we'll pick up 
							//where we left off with a call to quickSortIToRight
							context.pushFunction(this, quickSortIToRight));
					}
					else
					{
						quickSortIToRight();
					}
					
					function quickSortIToRight() : void
					{
						if (i<right) 
						{
							quickSortAsync(arrayInput, i, right, textWriter, context);
						}
					}
				}
			);
		}
		
	}
}
