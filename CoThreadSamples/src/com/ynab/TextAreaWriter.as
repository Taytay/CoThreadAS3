// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab
{
	import spark.components.TextArea;

	public class TextAreaWriter implements ITextWriter
	{
		protected var textArea : TextArea;
		
		public function TextAreaWriter(targetTextArea : TextArea)
		{
			this.textArea = targetTextArea;
		}
		
		public function writeLine(str:String) : void
		{
			textArea.appendText(str+"\n");
			textArea.scroller.verticalScrollBar.value = textArea.scroller.verticalScrollBar.maximum;
		}
	}
}
