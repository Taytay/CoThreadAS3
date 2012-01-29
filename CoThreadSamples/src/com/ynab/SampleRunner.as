// Written by Taylor Brown for YouNeedABudget.com
// Copyright YouNeedABudget.com, 2012. See LICENSE file for details. 
// You may not use this file except in compliance with the License.

package com.ynab
{
	import com.brokenfunction.json.JsonEncoderCoRoutine;
	import com.ynab.coroutine.CoRoutineContext;
	import com.ynab.coroutine.CoThread;
	import com.ynab.exampleThreads.CounterCoThread;
	import com.ynab.exampleThreads.LoopExamples;
	import com.ynab.exampleThreads.QuickSorter;

	public class SampleRunner
	{
		import com.brokenfunction.json.encodeJson;
		
		import flash.utils.getTimer;
		
		public static function startThreads(textWriter : ITextWriter) : void
		{
			//The following 4 functions show different ways that the CoThread library can be used
			startCounterCoThread(textWriter);

			startJsonEncoder(textWriter);

			startQuickSorter(textWriter);
			
			startInlineCoThread(textWriter);
		}
		
		private static function startInlineCoThread(textWriter:ITextWriter):void
		{
			//Here we'll just show making a random array and printing out its output
			
			var sampleThread : CoThread = new CoThread(startSampleThread, "sampleThread");
			sampleThread.start();
			function startSampleThread(context : CoRoutineContext) : void
			{
				//First we initialize the array
				var testArray : Array = new Array();
				var x : int = 0;
				var numItemsInArray : int = 100000;
				context.infiniteLoop(
					function() : Boolean
					{
						if (x >= numItemsInArray)
						{
							return false;
						}
						testArray[x] = int(Math.random() * 300000);
						++x;
						return true;
					},
					null,
					function afterLoop(): void
					{
						LoopExamples.forEachExample(
							testArray,
							textWriter,
							context);
					}
				);
			}
		}
		
		private static function startQuickSorter(textWriter:ITextWriter):void
		{
			//QuickSorter.quickSort(testArray, 0, testArray.length-1);
			
			//This QuickSorter is an example of a static method that is compatible with cothreads.
			//Instead of inheriting from CoThread, it takes a context in as a parameter. That way, 
			//not all of your code has to inherit from CoThread to be used in a CoThread
			var sorterThread : CoThread = new CoThread(startQuickSort, "SorterCoThread");
			sorterThread.start();
			function startQuickSort(context : CoRoutineContext) : void
			{
				//First we initialize the array
				var testArray : Array = new Array();
				var x : int = 0;
				var numItemsInArray : int = 100000;
				context.infiniteLoop(
					//This function inits the array
					function() : Boolean
					{
						if (x >= numItemsInArray)
						{
							return false;
						}
						testArray[x] = int(Math.random() * 300000);
						++x;
						return true;
					},
					//No "this" pointer needed
					null,
					//This function actually performs the QuickSort
					//And is called after the loop above
					function sortArray() : void
					{
						QuickSorter.quickSortAsync(testArray, 0, testArray.length-1, textWriter, 
							context.pushFunction(null, verifyQuickSort));
						
						function verifyQuickSort() : void
						{
							textWriter.writeLine(CoThread.currentThread.toString() + ": Quicksort done - verifying...");
							
							var i : int = 0;
							context.infiniteLoop(function() : Boolean
							{
								if (i >= testArray.length-1)
								{
									return false;
								}
								if (i % 500 == 0)
								{
									textWriter.writeLine(CoThread.currentThread.toString() + ": Quicksort verifying: "+i);	
								}
								if (testArray[i] > testArray[i+1])
								{
									throw new Error(CoThread.currentThread.toString() + ": QuickSort didn't work");
								}
								++i;
								return true;
							},
								null,
								function() : void
								{
									textWriter.writeLine(CoThread.currentThread.toString() + ": Quicksort verified!");
								});
						}
					}
				);
			}
		}
		
		private static function startJsonEncoder(textWriter:ITextWriter):void
		{
			//Now we'll show some JSON encoding
			var encodeTestObj : Object = {
				a: 234,
				c: [1, 2, 3, 242342298e10, -1235, "test"],
				d: [{a: "test", b: "test"}],
				e: {a:"foo", b:"bar", nested:{a:"nested", b:"nested2"}}
			};
			
			//First we initialize the coroutine encoder
			var jsonEncoder : JsonEncoderCoRoutine = new JsonEncoderCoRoutine(encodeTestObj, null, false);
			
			//Now we create a thread to drive this coroutine
			//The thread takes care of creating and driving our CoRoutineContext for us
			var encoderThread : CoThread = new CoThread(startEncoder, "JsonEncoderCoThread");
			encoderThread.start();
			
			function startEncoder(context : CoRoutineContext) : void
			{
				//Now that we're in this function, we've got our CoRoutineContext, 
				//so we can keep passing this in to other coRoutine functions as well
				jsonEncoder.startParse(context.pushFunction(null, function() : void	
				{
					//This anon function will be called when the jsonEncoder is finished with all of its processing
					//Now I can do more processing that depends on the result of the encoder
					textWriter.writeLine(encoderThread.toString() + "Now the encoder is done - time to process the result");
					
					var strLength : int = jsonEncoder.result.length;
					var index : int = 0;
					context.infiniteLoop(
						function() : Boolean
						{
							if (index >= strLength)
							{
								//Break out of the loop if we get too high up
								return false;
							}
							textWriter.writeLine(encoderThread.toString() + "char at index "+index+" : "+jsonEncoder.result.charAt(index));
							++index;
							return true;
						},null);
				}));
			}
			
			
		}
		
		private static function startCounterCoThread(textWriter:ITextWriter):void
		{
			//Here we're showing what it looks like to use a thread object
			//that actually inherits from CoThread
			var counterCoThread : CounterCoThread = new CounterCoThread(1500000, textWriter);
			counterCoThread.start();
		}		
		
	}
}
