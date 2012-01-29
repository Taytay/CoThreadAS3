// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.coroutine.scheduling
{
	import com.ynab.coroutine.ICoThread;
	
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import mx.core.FlexGlobals;
	import spark.components.Application;
	
	public class EnterFrameScheduler implements ICoThreadScheduler
	{
		protected var coThread : ICoThread;
		
		protected var topLevelApplication : Application 
		
		//I Seemed to get better results from 30ms
		public function EnterFrameScheduler(minTimeSlice : int=30, timeBetweenSlices : int=1)
		{
			this._minTimeSlice = minTimeSlice;
			this._timeBetweenSlices = timeBetweenSlices;
			init();
		}
		
		public function addThread(thread : ICoThread) : void
		{
			if (this.coThread != null)
			{
				throw new ArgumentError("This scheduler already has a thread. Call removeThread first.");
			}
			//topLevelApplication = FlexGlobals.topLevelApplication as Application;
			var obj : Object = FlexGlobals.topLevelApplication;
			topLevelApplication = FlexGlobals.topLevelApplication as Application;
			topLevelApplication.stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 100);

			this.coThread = thread;
			processThreads();
		}
		
		public function removeThread(thread : ICoThread) : void
		{
			if (this.coThread != thread)
			{
				throw new ArgumentError("Attempting to remove a thread that isn't scheduled");
			}
			this.coThread = null;
			handleThreadDone();
		}
		
		public function isRunning(thread : ICoThread) : Boolean
		{
			return ((thread != null) && (this.coThread == thread)); 
		}
		
		private var _minTimeSlice : int;
		public function get minTimeSlice():int
		{
			return _minTimeSlice;
		}
		
		public function set minTimeSlice(value:int):void
		{
			_minTimeSlice = value;
			//resetTimer(); 
		}
		
		private var _timeBetweenSlices : int;
		public function get timeBetweenSlices():int
		{
			return _timeBetweenSlices;
		}
		
		public function set timeBetweenSlices(value:int):void
		{
			_timeBetweenSlices = value;
			//resetTimer();
		}
		
//		protected function resetTimer() : void
//		{
//			var isRunning : Boolean = timer ? timer.running : false;
//			if (timer != null)
//			{
//				timer.removeEventListener(TimerEvent.TIMER, onTimer);
//			}
//			timer = null;
//			init();
//			if (isRunning)
//			{
//				timer.start();
//			}
//		}
		
		protected var timer : Timer;
		
		protected function init() : void
		{
			if (timer != null)
			{
				throw new Error("Already inited");
			}
			//timer = new Timer(timeBetweenSlices, 0);
			//timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
		}

		private function handleEnterFrame(event:Event):void
		{
			if ((getTimer() - _timeLastSliceFinished) > _timeBetweenSlices)
			{
				processThreads();
			}
		}
		
//		protected function onTimer(event : TimerEvent): void
//		{
//			processThreads();
//		}
		
		protected function processThreads() : void
		{
			//timer.stop();
			
			if (runSlice())
			{
				//if (this.coThread != null)
				{
					//TB: for a while I tried using callLater instead of the timer
					//because it got us called faster, but it also dropped my framerate more than I expected
					//So I am sticking with a timer for now.
					//					if (timeBetweenSlices < 5)
					//					{
					//						topLevelApplication.callLater(processThreads);
					//					}
					//					else
					//					{
					//timer.start();
					//}
				}
			}
			else
			{
				handleThreadDone();
			}
		}
		
		protected var _timeLastSliceFinished : int = 0;
		
		protected function runSlice() : Boolean
		{
			if (coThread == null)
			{
				//We're suspended right now - just wait for the next one
				return true;
			}
			var startTime : int = getTimer();
			var moreProcessingRemaining : Boolean = coThread.process(minTimeSlice);
			_timeLastSliceFinished = getTimer();
			var elapsedTime : int = _timeLastSliceFinished - startTime;
			
			return moreProcessingRemaining;
		}
		
		protected function handleThreadDone() : void
		{
			(FlexGlobals.topLevelApplication as Application).stage.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			//timer.stop();
		}
		
	}
}
