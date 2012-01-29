// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.exampleThreads
{
	import com.ynab.ITextWriter;
	import com.ynab.coroutine.CoRoutineContext;
	import com.ynab.coroutine.CoThread;

	public class LoopExamples
	{
		public function LoopExamples()
		{
		}
		
		//This shows a static function that declares itself to be async by taking a CoRoutineContext as a parameter
		public static function forEachExample(arrayToTrace : Array, textWriter : ITextWriter, context : CoRoutineContext) : void
		{
			context.foreach(arrayToTrace, 
				function(item : Object) : Boolean
				{
					textWriter.writeLine(CoThread.currentThread.toString()+": "+item.toString());
					//Tell the loop to keep going
					return true;
				},
				null,
				function() : void
				{
					textWriter.writeLine(CoThread.currentThread.toString()+": DONE!");
				}
			);
		}
		
		
		
	}
}
