// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.exampleThreads
{
	import com.ynab.coroutine.CoRoutineContext;
	import com.ynab.coroutine.CoThread;
	import com.ynab.ITextWriter;

	//Not all threads have to be inherited from CoThread, but this shows an example that is.
	public class CounterCoThread extends CoThread
	{
		protected var textWriter : ITextWriter;
		
		override public function CounterCoThread(numberToCountTo : Number, targetTextWriter : ITextWriter)
		{
			this.textWriter = targetTextWriter;
			
			//We call the super constructor and pass in the starting function and the name of our thread
			super(
				function(context : CoRoutineContext) : void
				{
					doCount(numberToCountTo, context);
				}, "CounterCoThread"
			);
		}
		
		protected function doCount(numberToCountTo : int, context : CoRoutineContext) : void
		{
			var counter : int = 0;
			
			context.whileLoop(
				this,
				//The first function pointer is the conditional for the while loop
				function() : Boolean
				{
					return counter < numberToCountTo;
				},
				//This is the function that actually gets called with every iteration of the loop
				function() : Boolean
				{
					if ((counter % 1000) == 0)
					{
						textWriter.writeLine(this.toString() + ' CurrentNumber = '+counter);
					}
					++counter;
					return true;
				});
		}
	}
}
