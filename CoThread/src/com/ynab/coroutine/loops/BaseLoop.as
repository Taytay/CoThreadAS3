// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.coroutine.loops
{
	import com.ynab.coroutine.CoRoutineContext;

	public class BaseLoop
	{
		protected var loopFunction : Function;
		protected var loopThisPointer : Object;
		protected var functionToCallOnComplete : Function;
		protected var context : CoRoutineContext;
		
		public function init(loopThisPointer : Object, loopFunction : Function, functionToCallOnComplete : Function, context : CoRoutineContext) : void
		{
			this.loopThisPointer = loopThisPointer;
			this.loopFunction = loopFunction;
			this.functionToCallOnComplete = functionToCallOnComplete;
			this.context = context;
		}
		
		public function BaseLoop(loopThisPointer : Object, loopFunction : Function, functionToCallOnComplete : Function, context : CoRoutineContext)
		{
			init(loopThisPointer, loopFunction, functionToCallOnComplete, context);
		}
		
		public function startLoop() : void 
		{
			//The first thing we do is push the functionToCallOnComplete
			//Because that function is what we want to call after our loop, which we're about to push onto the stack
			if (functionToCallOnComplete != null)
			{
				context.pushFunction(loopThisPointer, functionToCallOnComplete);	
			}
			
			//We want to tell the context that the next particular function should be called repeatedly until told otherwise
			//That way we don't have to keep popping and pushing the same function
			//So we use the pushLoop function
			context.pushLoop(this, performLoop);
		}
		
		protected function performLoop() : Boolean
		{
			throw new Error("Must override in a derived class");
		}
		
	}
}
