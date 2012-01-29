// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.coroutine
{
	import com.lia.utils.SimpleObjectPool;
	import com.ynab.delegate.Delegate;

	public class CoRoutineDelegate extends Delegate
	{
		public var isLoop : Boolean = true;
		
		protected static var delegatePool : SimpleObjectPool;
		
		{
			delegatePool = new SimpleObjectPool(
				createEmptyDelegate,
				null,
				200);
		}
		
		//protected static var _delegatePool : SimpleObjectPool;
		
//		public static function bindFromPoolVarArgs(thisObj : Object, func : Function, isLoop : Boolean, ... args) : CoRoutineDelegate
//		{
//			var retVal : CoRoutineDelegate = CoRoutineDelegate(delegatePool.checkOut());
//			retVal.fill(thisObj, func, args);
//			retVal.isLoop = isLoop;
//			return retVal;
//		}
		
		public static function bindFromPool(thisObj : Object, func : Function, isLoop : Boolean, args : Array=null) : CoRoutineDelegate
		{
			var retVal : CoRoutineDelegate = CoRoutineDelegate(delegatePool.checkOut());
			retVal.fill(thisObj, func, args);
			retVal.isLoop = isLoop;
			return retVal;
		}
		
		
		public function dispose() : void
		{
			delegatePool.checkIn(this);
		}
		
		protected static function createEmptyDelegate() : CoRoutineDelegate
		{
			return new CoRoutineDelegate(null, null, false);
		}
		
		public function CoRoutineDelegate(thisObj:Object, func:Function, isLoop:Boolean, ...args)
		{
			super(thisObj, func, isLoop, args);
		}
	}
}
