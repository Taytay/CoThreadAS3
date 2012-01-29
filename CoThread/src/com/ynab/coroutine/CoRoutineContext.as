// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.coroutine
{
	import com.ynab.coroutine.loops.DoWhileLoop;
	import com.ynab.coroutine.loops.ForEachLoop;
	import com.ynab.coroutine.loops.InfiniteLoop;
	import com.ynab.coroutine.loops.WhileLoop;
	
	use namespace coroutine_internal;
	
	public class CoRoutineContext
	{
		coroutine_internal var functionStack : Vector.<CoRoutineDelegate>;
		
		public function CoRoutineContext()
		{
			functionStack = new Vector.<CoRoutineDelegate>();
		}
		
		public function pushFunction(thisPointer : Object, func : Function) : CoRoutineContext
		{
			var delegate : CoRoutineDelegate = CoRoutineDelegate.bindFromPool(thisPointer, func, false, null);
			functionStack.push(delegate);
			return this;
		}
		
		public function pushFunctionWithArgs(thisPointer : Object, func : Function, args : Array) : CoRoutineContext
		{
			var delegate : CoRoutineDelegate = CoRoutineDelegate.bindFromPool(thisPointer, func, false, args);
			functionStack.push(delegate);
			return this;
		}
		
		public function pushLoop(thisPointer : Object, func : Function) : CoRoutineContext
		{
			var delegate : CoRoutineDelegate = CoRoutineDelegate.bindFromPool(thisPointer, func, true);
			functionStack.push(delegate);
			return this;
		}
		
		public function foreach(items : *, func : Function, loopThisPointer : Object, functionToCallOnComplete : Function=null) : void
		{
			//We do this so that we don't have to use anonymous functions to save our current state:
			var forEachLoop : ForEachLoop = ForEachLoop.createFromPool(loopThisPointer, items, func, null, functionToCallOnComplete, this);
			forEachLoop.startLoop();
		}
		
		public function foreachWithArguments(items : *, loopThisPointer : Object, func : Function, argsForFunction : Array, functionToCallOnComplete : Function=null) : void
		{
			//We do this so that we don't have to use anonymous functions to save our current state:
			var forEachLoop : ForEachLoop = ForEachLoop.createFromPool(loopThisPointer, items, func, argsForFunction, functionToCallOnComplete, this);
			forEachLoop.startLoop();
		}
		
		public function whileLoop(loopThisPointer : Object, condition : Function, func : Function, functionToCallOnComplete : Function=null) : void
		{
			//We do this so that we don't have to use anonymous functions to save our current state:
			var whileLoop : WhileLoop = new WhileLoop(loopThisPointer, condition, func, functionToCallOnComplete, this);
			whileLoop.startLoop();
		}
		
		public function doWhileLoop(loopThisPointer : Object, func : Function, condition : Function, functionToCallOnComplete : Function=null) : void
		{
			//We do this so that we don't have to use anonymous functions to save our current state:
			var doWhileLoop : DoWhileLoop = new DoWhileLoop(loopThisPointer, func, condition, functionToCallOnComplete, this);
			doWhileLoop.startLoop();
		}
		
		public function infiniteLoop(func : Function, loopThisPointer : Object, functionToCallOnComplete : Function=null) : void
		{
			//We do this so that we don't have to use anonymous functions to save our current state:
			var infiniteLoop : InfiniteLoop = new InfiniteLoop(loopThisPointer, func, functionToCallOnComplete, this);
			infiniteLoop.startLoop();
		}
		
	}
} 
