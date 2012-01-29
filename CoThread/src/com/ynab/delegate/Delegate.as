// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.delegate
{

	public class Delegate
	{
		private var _thisObj : Object;

		public function get thisObj():Object
		{
			return _thisObj;
		}

		private var _func : Function;

		public function get func():Function
		{
			return _func;
		}

		private var _argArray : Array;

		public function get argArray():Array
		{
			return _argArray;
		}

		
		public function Delegate(thisObj : Object, func : Function, ... args)
		{
			fill(thisObj, func, args);
		}
		
		public function fill(thisObj : Object, func : Function, argArray : Array=null) : void
		{
			this._thisObj = thisObj;
			this._func = func;
			this._argArray = argArray;
			
			//You could take this out for release mode to speed it up a bit
			//It's invaluable during testing/debugging though
			if (this._func != null)
			{
				var argLength : int = _argArray ? _argArray.length : 0;
				if (_func.length != argLength)
				{
					throw new ArgumentError("Function length doesn't match arg length");
				}
			}
		}
			
		
		public function call() : *
		{
			return this._func.apply(_thisObj, _argArray);
		}
	}
}