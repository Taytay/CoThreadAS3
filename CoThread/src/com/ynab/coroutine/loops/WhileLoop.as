// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.coroutine.loops
{
	import com.ynab.coroutine.CoRoutineContext;
	
	public class WhileLoop extends ConditionalLoop
	{
		public function WhileLoop(loopThisPointer : Object, conditionFunction : Function, loopFunction : Function, functionToCallOnComplete : Function, context : CoRoutineContext)
		{
			super(loopThisPointer, conditionFunction, loopFunction, functionToCallOnComplete, context);
		}
		
		override protected function performLoop() : Boolean
		{
			if (conditionFunction.call(loopThisPointer))
			{
				//We'll want to repeat this later
				if (!loopFunction.call(loopThisPointer))
				{
					return false;
				}
				return true;
			}
			else
			{
				return false;
			}
		}
		
		
	}
}
