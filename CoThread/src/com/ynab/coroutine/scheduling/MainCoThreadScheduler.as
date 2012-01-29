// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.coroutine.scheduling
{
	import com.ynab.coroutine.CoRoutineContext;
	import com.ynab.coroutine.CoThread;
	import com.ynab.coroutine.ICoThread;
	
	import mx.collections.ArrayCollection;

	public class MainCoThreadScheduler extends CoThread implements ICoThreadScheduler
	{
		private static var _instance : MainCoThreadScheduler;

		[Bindable]
		public function get minTimeSlice() : int
		{
			return this.scheduler.minTimeSlice;
		}
		
		public function set minTimeSlice(value : int) : void
		{
			this.scheduler.minTimeSlice = value;
		}
		
		[Bindable]
		public function get timeBetweenSlices() : int
		{
			return this.scheduler.timeBetweenSlices;
		}
		
		public function set timeBetweenSlices(value : int) : void
		{
			this.scheduler.timeBetweenSlices = value;
		}
		
		//Found 30 to be a pretty good sweet spot
		public function MainCoThreadScheduler(minTimeSlice : int=30, timeBetweenSlices : int=1)
		{
			var scheduler : ICoThreadScheduler = new TimerScheduler(minTimeSlice, timeBetweenSlices);
			//var scheduler : ICoThreadScheduler = new EnterFrameScheduler(minTimeSlice, timeBetweenSlices);
			super(processThreads, "MainCoThreadScheduler", scheduler);
		}
		
		{
			_instance = new MainCoThreadScheduler();
		}
		
		
		public static function get instance() : MainCoThreadScheduler
		{
			return _instance;
		}
		
		//TB: I'm honestly not sure why I use an ArrayCollection now instead of a Vector
		//I should probably change this back to Vector!
		//var threads : Vector.<CoThread> = new Vector.<CoThread>(); 
		protected var threads : ArrayCollection = new ArrayCollection();
		
		protected function processThreads(context : CoRoutineContext) : void
		{
			context.infiniteLoop(
				function(): Boolean
				{
					if (threads.length == 0)
					{
						//This is the function that we want to come back to later once we have a thread to schedule
						//TODO: In the meantime, let's suspend
						suspend();
						return true;
					}
					
					var timeSliceForEach : int = 0;
					timeSliceForEach = Math.max(1, this.minTimeSlice / threads.length);
					var threadsCopy :Array = this.threads.source.slice();
					
					context.foreach(threadsCopy, 
						function(currentThread : CoThread) : Boolean
						{
							if (!currentThread.process(timeSliceForEach))
							{
								//That thread is done now
								removeThread(currentThread);
							}
							return true;
							//We are not going to get called back if we don't have enough of our time slice remaining
							//
						},
						this);
					return true;		
				}, 
				this);
		}
		
		
		//TB: I experimented with breaking this out into methods, but it didn't seem to help much
//		
//		
//		protected function processThreads(context : CoRoutineContext) : void
//		{
//			this.context = context;
//			context.infiniteLoop(
//				processEveryThread, this);
//		}
//		
//		protected function processEveryThread() : Boolean
//		{
//			if (threads.length == 0)
//			{
//				//This is the function that we want to come back to later once we have a thread to schedule
//				//TODO: In the meantime, let's suspend
//				suspend();
//				return true;
//			}
//			
//			var timeSliceForEach : int = 0;
//			timeSliceForEach = Math.max(1, this.minTimeSlice / threads.length);
//			var threadsCopy :Array = this.threads.source.slice();
//			
//			context.foreachWithArguments(threadsCopy, 
//				this, processSingleThread, [timeSliceForEach]);
//			return true;
//		}
//		
//		protected function processSingleThread(currentThread : CoThread, timeSliceForThread : int) : Boolean
//		{
//			if (!currentThread.process(timeSliceForThread))
//			{
//				//That thread is done now
//				removeThread(currentThread);
//			}
//			return true;
//		}
		
		public function addThread(thread : ICoThread) : void
		{
			this.threads.addItem(thread);
			this.resume();
		}
		
		public function removeThread(thread : ICoThread) : void
		{
			this.threads.removeItemAt(this.threads.getItemIndex(thread));
			if (this.threads.length == 0)
			{
				this.suspend();
			}
		}
		
		public function isRunning(thread : ICoThread) : Boolean
		{
			return this.threads.contains(thread);
		}
	}
}
