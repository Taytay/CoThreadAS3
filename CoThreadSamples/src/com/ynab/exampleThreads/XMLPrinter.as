// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab.exampleThreads
{
	import com.ynab.ITextWriter;
	import com.ynab.coroutine.CoRoutineContext;
	
	import mx.utils.StringUtil;

	//This class has both a synchronous and async public method.
	//The async public method (printXMLAsync) delcares itself to be async by taking a CoRoutineContext as a parameter
	public class XMLPrinter
	{
		protected var _textWriter : ITextWriter;
		
		public function XMLPrinter(textWriter : ITextWriter)
		{
			_textWriter = textWriter;
		}
		
		public function printXML(xml : XML, indentString : String) : void
		{
			if ((xml == null) || (xml.name() == null))
			{
				return;
			}
			else
			{
				indentString += "\t";
				_textWriter.writeLine(indentString + xml.name()+":"+xml.text());
				for each(var child : XML in xml.children())
				{
					printXML(child, indentString);
				}
				_textWriter.writeLine(indentString + "/"+xml.name());
			}
		}
		
		public function printXMLAsync(xml : XML, indentString : String, context : CoRoutineContext) : void
		{
			if ((xml == null) || (xml.name() == null))
			{
				return;
			}
			else
			{
				indentString += "\t";
				_textWriter.writeLine(indentString + xml.name()+":"+xml.text());
				context.foreach(xml.children(),
					function printEachChild(child : XML) : Boolean
					{
						printXMLAsync(child, indentString, context);
						return true; 
					},
					this,
					function afterDonePrintingChildren() : void
					{
						_textWriter.writeLine(indentString + "/"+xml.name());
					}
				);
			}
		}

	}
}
