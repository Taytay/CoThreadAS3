// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab
{
	public class TraceWriter implements ITextWriter
	{
		public function TraceWriter()
		{
		}
		
		public function writeLine(str:String) : void
		{
			trace(str);
		}
	}
}
