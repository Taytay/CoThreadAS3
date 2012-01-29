// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.coroutine
{
	public interface ICoThread
	{
		function get isDone() : Boolean;
		
		/**
		 * Continue processing data. 
		 * 
		 * @property timeSliceInMs - the maximum amount of time to run in milliseconds. 
		 * 		(Note that it might run longer if an internal operation has been written to take longer)  
		 * @return False if processing is finished, otherwise true
		 * false.
		 */
		function process(timeSliceInMs : int) : Boolean
	}
}
