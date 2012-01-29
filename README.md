CoThread for AS3
=================


CoThread lets you to create cooperative "threads" and coroutines in Actionscript 3 (Flex/AIR). 

With CoThread, you can easily break up any task, including _recursive_ functions, so that your UI stays responsive even while your application is doing significant processing.  Asynchronous code that uses CoThread is easy to read and write.

CoThread was written by [Taylor Brown (Taytay)](http://taytay.com) for [You Need a Budget](http://youneedabudget.com), and more information can be found on the [project page](http://taytay.com/CoThreadAS3).

CoThread is hosted on [GitHub](https://github.com/Taytay/CoThreadAS3), and mirrored on [BitBucket](https://bitbucket.org/Taytay/cothreadas3) for my fellow Mercurial-loving developers.


Simple examples
-----------------

Imagine that you need to process every pixel in a large image


	function processAllPixels(pixels : Array) : void
	{
		for each (var pixel : int in pixels)
		{
			processPixel(pixel);
		}
	}

But what if you've got millions of pixels, and each call to processPixel takes 5ms? Any call to processAllPixels will lock your program for a long time.

To make this a "threadable" or "asynchronous" function using CoThread, just do this:


	public function processAllPixelsAsync(pixels : Array, context : CoRoutineContext) : void
	{
		context.foreach(pixels, 
			function(pixel : int) : Boolean  
			{
				processPixel(pixel);	
				//Returns true to continue the for loop
				return true; 
			},
			this
		);
	}


And here's how you call it:

	//Instantiate a CoThread
	var sampleThread : CoThread = new CoThread(startProcessingPixels);

	//Start the thread (calls the function below)
	sampleThread.start();

	function startProcessingPixels(context : CoRoutineContext) : void
	{
		processAllPixelsAsync(pixelArray, context);
	}

The above code will process all of the pixels, but it will split the work up into small chunks so that your UI is never blocked. Cool! 

But that's the small stuff. Iterative functions are easy. Recursive functions are harder:

	//Recursively pretty-prints XML, indenting each deeper level
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

Imagine you need to split the above function up so that it can run in a separate "thread". That means that you need to be able to stop and continue the function arbitrarily. That's difficult when you're 30 function calls deep. 
You could rewrite the above function so that it's not recursive, but if your recursive function is more complicated, or relies on other recursive functions, that isn't a good option.

Here's how you'd write that function asynchronously using CoThread:

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

It's not _extremely_ different from the synchronous version of the code. I didn't have to manually save a lot of state. It just works.

In that example I gave the anonymous functions (printEachChild and afterDonePrintingChildren) a name so that they were easier to read, but I don't have to do that.



Calling an asynchronous function
--------------------------------

All asynchronous functions in the CoThread library take a "CoRoutineContext" as its last parameter. This context is required by the function in order to operate as a CoRoutine (asynchronously), and it has the added benefit of advertising to the caller "I am an asynchronous function. I might return immediately, but I probably still have work to do." To get a CoRoutineContext, you just need a CoThread, as demonstrated above. Here's how we'd call that XML printer:


	//Instantiate a CoThread
	var sampleThread : CoThread = new CoThread(startProcessingXML);

	//Start the thread (calls the function below)
	sampleThread.start();

	function startProcessingXML(context : CoRoutineContext) : void
	{
		printXMLAsync(sampleXML, context);
	}


The function printXMLAsync now has a context on which to operate. Furthermore, it can now call any other asynchronous methods it wants, and can simply pass in its own CoRoutineContext. So let's say that as part of your XML pretty printing, you want to do some Pixel processing. 

Here is our original printEachChild function from printXMLAsync:

	function printEachChild(child : XML) : Boolean
	{
		printXMLAsync(child, indentString, context);
		return true; 
	}


Perhaps some of the children of the XML contain a bitmap we want to process:


	function printEachChild(child : XML) : Boolean
	{
		if (child.name() == "pixels")
		{
			var pixels : Array = getPixelData(child);
			//pass our context into the async processing function
			//processAllPixelsAsync might take 20 minutes to truly complete, but this 
			//printEachChild function won't get called again for the next XML node
			//until it's done processing
			processAllPixelsAsync(pixels, context);
		}
		else
		{
			printXMLAsync(child, indentString, context);
		}
		return true; 
	}

And processAllPixelsAsync has a CoRoutineContext, so it can in turn call other asynchronous functions quite easily.

Chaining async calls
--------------------

But when you call an asynchronous function, it can return almost immediately even though it might have 5 minutes of work left to do. Well, the context can come to our rescue again.

Let's go back to our XML printing example. Recall this function:

	function startPrinting(context : CoRoutineContext) : void
	{
		printXMLAsync(sampleXML, "", context);
	}


Imagine we want to do something after our recursive function is done printing the XML. You can't just do this:

	function startPrinting(context : CoRoutineContext) : void
	{
		printXMLAsync(sampleXML, "", context);
		//You can't just do this:
		trace("I'm done printing the XML!")
	}


That's because the call to printXMLAsync will just _start_ printing the XML. It won't _finish_ printing all of the XML. So we need to tell our context, "After you're done with that function, here's the next function I want you to call."

We do that with the "pushFunction" call:

	function startPrinting(context : CoRoutineContext) : void
	{
		//Tell the context to call "afterDonePrinting" when printXMLAsync is done
		context.pushFunction(afterDonePrinting);
		printXMLAsync(sampleXML, "", context);

		function afterDonePrinting() : void
		{
			trace("I'm really done printing the XML!")
		}
	}


This is relatively readable, but still a bit verbose, and I don't like that I read the pushFunction call before I read the printXMLAsync call. It doesn't read in the same order the code is called. Luckily, context.pushFunction returns the context as its return parameter, so we can do this instead:


	function startPrinting(context : CoRoutineContext) : void
	{
		printXMLAsync(sampleXML, "", 
			context.pushFunction(afterDonePrinting));

		function afterDonePrinting() : void
		{
			trace("I'm really done printing the XML!")
		}
	}


That's a bit better. If you want to be even less verbose, you can just use an anonymous function:


	function startPrinting(context : CoRoutineContext) : void
	{
		printXMLAsync(sampleXML, "", context.pushFunction(
			function() : void
			{
				trace("I'm really done printing the XML!")			
			})
		);

	}

I personally find this the most readable style most of the time. I can write plenty of code inside that anonymous function, including further asynchronous calls, and still manage to read and write it linearly.


Performance (aka: The Bad News)
-----------
Although they are easy to write, there is a performance penalty for these threaded functions. [Instantiating and calling Closures is slower than a normal function call](http://jacksondunstan.com/articles/850). In my tests using the Debugger, performing these functions takes about twice as long as their non-threaded counterparts. I haven't profiled it extensively, (I haven't even profiled it in release mode yet) so it's quite possible that we can bring it down, but even if we can't, I think there are still times when you would be willing to pay such a performance penalty. My first use-case for it was saving our budget files without halting the UI of [our app](http://YouNeedABudget.com). I was happy to have a background save take twice as long as a foreground save. Who cares if it takes an extra few seconds? 5 seconds in the background is MUCH better for the user than 2.5 seconds of an unusable app!


Contribute
----------

If you're passionate about us AS3/Flex/AIR users having easier access to threaded code, please give me a hand! Here are the things that are at the top of my personal list:

* **Improve the Samples**: The sample app could be a lot better. Right now it just relies on using trace to show progress, and the samples are somewhat contrived. 

* **Add some missing functions**: The CoThread Library already supports some common loops (foreach, while, infinite), but does not yet support a simple For loop. It wouldn't be hard to add. I just haven't done it yet.

* **Improve the performance**: People with better knowledge of AS3 performance could have a field day improving this library! Heck, I haven't even profiled a release build yet. 

* **Remove minor dependence on Flex** I'd like for this to be a true AS3 library and not a Flex-based library. Some of the schedulers that the library ships with require Flex, but you could extricate those pretty easily. (I also use StringUtil.substitute in a couple of places, but that is trivial to fix.)

* **Improve the Documentation**: The CoThread Library itself needs to be better documented.


Worker Threads from Adobe
----------
Adobe will eventually introduce Worker Threads, and that might well make this code obsolete, but in the meantime I thought I'd post my library because it's usable today and I think it's really cool.


Inspiration and Thanks!
----------

The inspiration for the inner workings of CoThread came from [BrokenFunction's json code](http://blog.brokenfunction.com/2010/10/actionjson-the-fastest-actionscript-3-0-json-parser) He has an example of an async json parser. It is both recursive and asynchronous. It could pause itself and resume at semi-arbitrary points. It was brilliant. I took his ideas and expounded on them to write CoThread.


