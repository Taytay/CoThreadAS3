// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.coroutine.loops
{
	import com.lia.utils.SimpleObjectPool;
	import com.ynab.coroutine.CoRoutineContext;
	
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public class ForEachLoop extends BaseLoop
	{
		protected var items : *;
		protected var position : int;
		protected var argsForFunction : Array;
		
		protected static var objectPool : SimpleObjectPool;
		
		{
			objectPool = new SimpleObjectPool(
				createEmptyForEach,
				null,
				200);
		}
		
		protected static function createEmptyForEach() : ForEachLoop
		{
			return new ForEachLoop(null, null, null, null, null);
		}
		
		public function dispose() : void
		{
			objectPool.checkIn(this);
		}			
		
		public static function createFromPool( loopThisPointer : Object, items : *, loopFunction : Function, argsForFunction : Array, functionToCallOnComplete : Function, context : CoRoutineContext) : ForEachLoop
		{
			var retVal : ForEachLoop = ForEachLoop(objectPool.checkOut());
			retVal.initForEach(loopThisPointer, items, loopFunction, argsForFunction, functionToCallOnComplete, context);
			return retVal;
		}
		
		protected function initForEach(loopThisPointer : Object, items : *, loopFunction : Function, argsForEachFunctionCall : Array, functionToCallOnComplete : Function, context : CoRoutineContext) : void
		{
			super.init(loopThisPointer, loopFunction, functionToCallOnComplete, context);
			this.position = 0;
			this.items = items;
			this.argsForFunction = argsForEachFunctionCall;
			if (argsForFunction == null)
			{
				argsForFunction = [null];
			}
			else
			{
				//Insert a null element at the beginning
				argsForFunction.splice(0, 0, null);
			}
		}
		
		public function ForEachLoop(loopThisPointer : Object, items : *, loopFunction : Function, functionToCallOnComplete : Function, context : CoRoutineContext)
		{
			super(loopThisPointer, loopFunction, functionToCallOnComplete, context);
			this.items = items;
		}
		
		override public function startLoop() : void 
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
			//TODO: check for IList so that we can do the simple foreach math instead of relying on slow function calls to proxy.
			if (items is Proxy)
			{
				context.pushLoop(this, loopProxy);
			}
			else if (items is Array)
			{
				context.pushLoop(this, loopArray);
			}
			else if (items is XMLList)
			{
				context.pushLoop(this, loopXMLList);
			}
			else
			{
				throw new Error("Item being looped must be an array or proxy or XMLList");
				//context.pushLoop(this, loopOther);
			}
		}
		
		protected function loopProxy() : Boolean
		{
			position = items.flash_proxy::nextNameIndex(position);
			if (position == 0)
			{
				//We are at the end of our loop right now - no processing necessary
				dispose();
				return false;
			}
			
			var proxy : Proxy = items as Proxy;
			var item : * = proxy.flash_proxy::nextValue(position);
			
			this.argsForFunction[0] = item;
			if (!loopFunction.apply(loopThisPointer, argsForFunction))
			{
				//This function said we should break the loop, so we aren't going to continue; 
				dispose();
				return false;
			}
			
			return true;
		}
		
		
		protected function loopXMLList() : Boolean
		{
			if (position >= items.length())
			{
				//We are at the end of our loop right now - no processing necessary
				dispose();
				return false;
			}
			
			var item : * = items[position++];
			
			this.argsForFunction[0] = item;
			if (!loopFunction.apply(loopThisPointer, argsForFunction))
			{
				//This function said we should break the loop, so we aren't going to continue; 
				dispose();
				return false;
			}
			
			return true;
		}
		
		protected function loopArray() : Boolean
		{
			if (position >= items.length)
			{
				//We are at the end of our loop right now - no processing necessary
				dispose();
				return false;
			}
			
			var item : * = items[position++];
			
			this.argsForFunction[0] = item;
			if (!loopFunction.apply(loopThisPointer, argsForFunction))
			{
				//This function said we should break the loop, so we aren't going to continue; 
				dispose();
				return false;
			}
			
			return true;
		}
		
	}
}
