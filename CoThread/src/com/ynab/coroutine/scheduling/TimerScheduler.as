// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.coroutine.scheduling
{
	import com.ynab.coroutine.ICoThread;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class TimerScheduler implements ICoThreadScheduler
	{
		protected var coThread : ICoThread;
		
		//I Seemed to get better results from 30ms
		public function TimerScheduler(minTimeSlice : int=30, timeBetweenSlices : int=1)
		{
			this._minTimeSlice = minTimeSlice;
			this._timeBetweenSlices = timeBetweenSlices;
			initTimer();
		}
		
		public function addThread(thread : ICoThread) : void
		{
			if (this.coThread != null)
			{
				throw new ArgumentError("This scheduler already has a thread. Call removeThread first.");
			}
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
		
		//protected var threadStartTime : int;
		//protected var threadEndTime : int;
		//protected var processingTime : int;
		
		private var _minTimeSlice : int;
		public function get minTimeSlice():int
		{
			return _minTimeSlice;
		}
		
		public function set minTimeSlice(value:int):void
		{
			_minTimeSlice = value;
			resetTimer(); 
		}
		
		private var _timeBetweenSlices : int;
		public function get timeBetweenSlices():int
		{
			return _timeBetweenSlices;
		}

		public function set timeBetweenSlices(value:int):void
		{
			_timeBetweenSlices = value;
			resetTimer();
		}
		
		protected function resetTimer() : void
		{
			var isRunning : Boolean = timer ? timer.running : false;
			if (timer != null)
			{
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
			timer = null;
			initTimer();
			if (isRunning)
			{
				timer.start();
			}
		}
		
		protected var timer : Timer;
		
		protected function initTimer() : void
		{
			if (timer != null)
			{
				throw new Error("Already inited");
			}
			timer = new Timer(timeBetweenSlices, 0);
			timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
		}
		
		protected function onTimer(event : TimerEvent): void
		{
			processThreads();
		}
		
		protected function processThreads() : void
		{
			timer.stop();
			
			if (runSlice())
			{
				if (this.coThread != null)
				{
					timer.start();
				}
			}
			else
			{
				handleThreadDone();
			}
		}
		
		protected function runSlice() : Boolean
		{
			if (coThread == null)
			{
				//We're suspended right now - just wait for the next one
				return true;
			}
			var startTime : int = getTimer();
			var moreProcessingRemaining : Boolean = coThread.process(minTimeSlice);
			var elapsedTime : int = getTimer() - startTime;
			
			return moreProcessingRemaining;
		}
		
		protected function handleThreadDone() : void
		{
			timer.stop();
		}
		
	}
}
