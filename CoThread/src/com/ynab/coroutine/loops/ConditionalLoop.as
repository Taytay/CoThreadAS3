// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.coroutine.loops
{
	import com.ynab.coroutine.CoRoutineContext;
	
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public class ConditionalLoop extends BaseLoop
	{
		protected var conditionFunction : Function;		
		
		public function ConditionalLoop(loopThisPointer : Object, conditionFunction : Function, loopFunction : Function, functionToCallOnComplete : Function, context : CoRoutineContext)
		{
			super(loopThisPointer, loopFunction, functionToCallOnComplete, context);
			
			this.conditionFunction = conditionFunction;
		}
		
		
	}
}
