// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.coroutine
{
	public class CoRoutine
	{
		protected var _context : CoRoutineContext;
		
		protected var _isDone : Boolean = false;
		protected var _firstFunctionToCall : Function;
		
		public function get context() : CoRoutineContext
		{
			return _context;
		}
		
		public function CoRoutine(firstFunctionToCall : Function, theContext : CoRoutineContext = null)
		{
			if (theContext != null)
			{
				_context = theContext;
			}
			else
			{
				_context = new CoRoutineContext();
			}
			
			//TODO: Check the function to make sure that it has enough parameters
			//and that its parameters are of the right type
			
			// the initial stack function
			this._firstFunctionToCall = firstFunctionToCall;

			//TODO: Need a this context for the first function to call
			context.pushFunction(this, firstFunction);
		}
		
		protected function firstFunction() : void
		{
			_firstFunctionToCall(this.context);
		}
		
		/**
		 * Continue processing data. 
		 * 
		 * @return False if processing is finished, otherwise process will return true
		 * false.
		 */
		public function processNextStep() : Boolean
		{
			if (_isDone)
			{
				//TB: This might be fine - just haven't tested it yet, and want to guard against it for now
				if (_context.coroutine_internal::functionStack.length > 0)
				{
					throw new Error("Doesn't currently support restarting a finished CoRoutine");
				}
				return false;
			}
			var functionDelegate : CoRoutineDelegate;
			var functionStack : Vector.<CoRoutineDelegate> = _context.coroutine_internal::functionStack;
			if (functionStack.length > 0)
			{
				var currentSpotInStack : int = functionStack.length-1;
				functionDelegate = functionStack[currentSpotInStack];
				if (functionDelegate == null)
				{
					functionStack.pop();
				}
				else
				{
					var isLoop : Boolean = functionDelegate.isLoop;
					if (isLoop)
					{
						var retVal : Boolean = functionDelegate.call();
						if (!retVal)
						{
							//The loop function returned false, so we need to remove this delegate from the list of functions 
							//However, we can't just pop it because the function might have called other sub-functions
							//and added to our stack
							//If that is the case, it's easiest/fastest just to null out this spot in the function stack
							//Then, the next time we get here and there is a null function on the stack,
							//we can just pop it and move on
							if (currentSpotInStack == functionStack.length)
							{
								//We can just pop it and move on because the loop is still at the top of the stack
								functionStack.pop();
							}
							else
							{
								functionStack[currentSpotInStack] = null;
							}
							//Regardless, we'll never use this delegate again
							functionDelegate.dispose();
						}
					}
					else
					{
						functionStack.pop();
						functionDelegate.call();
						//We're done with this delegate
						functionDelegate.dispose();
					}
				}
				if (functionStack.length == 0)
				{
					_isDone = true;
				}
				return (!_isDone);
			}
			else
			{
				//This should be impossible
				throw new Error("How'd we get here?");
			}
		}
		
		public function get isDone() : Boolean
		{
			return _isDone;
		}
	}
}
