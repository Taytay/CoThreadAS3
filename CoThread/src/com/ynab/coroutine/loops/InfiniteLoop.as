// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.coroutine.loops
{
	import com.ynab.coroutine.CoRoutineContext;
	
	public class InfiniteLoop extends BaseLoop
	{
		//TODO : Use object pooling like the foreach loop does.
		public function InfiniteLoop(loopThisPointer : Object, loopFunction : Function, functionToCallOnComplete : Function, context : CoRoutineContext)
		{
			super(loopThisPointer, loopFunction, functionToCallOnComplete, context);
		}
		
		override protected function performLoop() : Boolean
		{
			//We'll want to repeat this later
			if (!loopFunction.call(loopThisPointer))
			{
				return false;
			}
			return true;
		}
		
		
	}
}
