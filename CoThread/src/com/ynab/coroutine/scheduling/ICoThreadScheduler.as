// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.coroutine.scheduling
{
	import com.ynab.coroutine.ICoThread;

	public interface ICoThreadScheduler
	{
		function isRunning(thread : ICoThread) : Boolean;
		function addThread(thread : ICoThread) : void;
		
		function removeThread(thread : ICoThread) : void;
		
		function get minTimeSlice() : int;
		function set minTimeSlice(value : int) : void;
		
		function get timeBetweenSlices() : int;
		function set timeBetweenSlices(value : int) : void;
	}
}
