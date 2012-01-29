// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.coroutine.loops
{
	import com.ynab.coroutine.CoRoutineContext;
	
	public class DoWhileLoop extends ConditionalLoop
	{
		public function DoWhileLoop(loopThisPointer : Object, loopFunction : Function, conditionFunction : Function, functionToCallOnComplete : Function, context : CoRoutineContext)
		{
			super(loopThisPointer, conditionFunction, loopFunction, functionToCallOnComplete, context);
		}
		
		override protected function performLoop() : Boolean
		{
			if (!loopFunction.call(loopThisPointer))
			{
				return false;
			}
			else
			{
				return conditionFunction.call(loopThisPointer);
			}
		}				
		
		
	}
}
