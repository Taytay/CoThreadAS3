// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.coroutine
{
	import com.ynab.coroutine.scheduling.ICoThreadScheduler;
	import com.ynab.coroutine.scheduling.MainCoThreadScheduler;
	
	import flash.utils.getTimer;
	
	import mx.utils.StringUtil;

	public class CoThread implements ICoThread 
	{
		public static const STATE_SUSPENDED : int = 0;
		public static const STATE_RUNNING : int = 1; 
		public static const STATE_COMPLETED : int = 2;

		//A reference to the thread currently being processed
		public static var currentThread : CoThread;
		
		private static var _threadIDCounter : uint = 0;
		
		private var _state : int = STATE_SUSPENDED;
		public function get state() : int
		{
			return _state;
		}
		
		protected var coRoutine : CoRoutine;
		protected var scheduler : ICoThreadScheduler;

		private var sleepUntil:int;

		private var _threadID : int;
		public function get threadID():int
		{
			return _threadID;
		}

		private var _name : String;		
		public function get name() : String
		{
			return _name;		
		}
		
		public function toString():String
		{
			return StringUtil.substitute("{0} ({1})", this.name, this.threadID);
		}
		
		public function CoThread(firstFunctionToCall : Function, name : String =null, theScheduler : ICoThreadScheduler=null/*, theContext : CoRoutineContext = null*/)
		{
			_threadID = _threadIDCounter++;
			if (name == null)
			{
				name = "<Unnamed Thread #"+_threadID+">";
			}
			this._name = name;
			coRoutine = new CoRoutine(firstFunctionToCall);
			if (theScheduler == null)
			{
				theScheduler = MainCoThreadScheduler.instance;
			}
			this.scheduler = theScheduler;
		}
		
		protected var completeCallback : Function;
		protected var threadStartTime : int;
		protected var threadEndTime : int;
		protected var processingTime : int;
		
		protected var lastEndTime : int = 0;
		
		/**
		 * Continue processing data. 
		 * 
		 * @property timeSliceInMs - the maximum amount of time to run in milliseconds. 
		 * 		(Note that it might run longer if an internal operation has been written to take longer)  
		 * @return False if processing is finished, otherwise true
		 * false.
		 */
		//TODO - put into own namespace so that someone on the outside can't call process on this object
		//Then again, calling a function in a namespace is supposed to be super slow, so look out...
		public function process(timeSliceInMs : int) : Boolean
		{
			currentThread = this;
			try
			{
				var startTime : int = getTimer();
	//			if (lastEndTime != 0)
	//			{
	//				trace(StringUtil.substitute("Thread {0} is processing after {1}ms", this.name, startTime-lastEndTime));
	//			}
				
				if (sleepUntil != 0)
				{
					if (startTime < sleepUntil)
					{
						return true;
					}
					else
					{
						sleepUntil = 0;
					}
				}
				var elapsedTime : int = 0;
				var coRoutineDone : Boolean;
				
				var moreProcessing : Boolean;
				do
				{
					moreProcessing = this.coRoutine.processNextStep();
					elapsedTime = getTimer() - startTime;
				} while (
						(elapsedTime < timeSliceInMs) &&	
						(moreProcessing) &&	
						(_state == STATE_RUNNING) &&
						(sleepUntil == 0)) 
	
				//trace(StringUtil.substitute("Just ran thread {0} for {1}ms", this.name, elapsedTime));
				//elapsedTime = getTimer() - startTime;
				processingTime += elapsedTime;
				
				lastEndTime = getTimer();
				
				if (coRoutine.isDone)
				{
					notifyDone();
					return false;
				}
				else
				{
					return true;
				}
			}
			finally
			{
				currentThread = null;
			}
			//We should never get here
			return true;
		}
		
		protected function notifyDone() : void
		{
			this._state = STATE_COMPLETED;
			this.threadEndTime = getTimer();
			trace(StringUtil.substitute("Thread {0} is finished in {1}ms. Actual processing time: {2}", this.toString(), this.threadEndTime - this.threadStartTime, this.processingTime));
			
			if (this.completeCallback != null)
			{
				completeCallback();
			}
		}
		
		public function start(completeCallback : Function = null) : void
		{
			threadStartTime = getTimer();
			this.completeCallback = completeCallback;
			resume();
		}
		
		
		public function sleep(ms : int) : void
		{
			sleepUntil = getTimer() + ms;
		}
		
		public function get isDone() : Boolean
		{
			return this.state == STATE_COMPLETED;
		}
		
		public function suspend() : void
		{
			this._state = STATE_SUSPENDED; 
			this.scheduler.removeThread(this);
		}
		
//		public function stop() : void
//		{
//			this.scheduler.removeThread(this);
//		}
		
		public function resume() : void
		{
			if (this.state == STATE_SUSPENDED)
			{
				//TODO: Make this check only happen in debug
				//DEBUG CHECK
				if (this.scheduler.isRunning(this))
				{
					throw new Error("We're suspended, but the scheduler is still running this thread.");
				}
				this._state = STATE_RUNNING;
				this.scheduler.addThread(this);				
			}
		}
		
	}
}
