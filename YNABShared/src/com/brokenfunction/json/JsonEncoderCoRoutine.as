package com.brokenfunction.json
{
	
	import com.ynab.coroutine.CoRoutine;
	import com.ynab.coroutine.CoRoutineContext;
	import com.ynab.coroutine.CoThread;
	
	import flash.net.ObjectEncoding;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.IDataOutput;
	import flash.utils.describeType;
	
	import mx.collections.IList;
	
	import org.libspark.asreflect.ASReflect;
	import org.libspark.asreflect.Property;
	import org.libspark.asreflect.Type;
	
	//TB: The JSON code in here is mainly BrokenFunction.com's JSON code,
	//with the exception of the use of ASRelfect to include non-dynamic objects
	//He has an async encoder already. 
	//I tried to generalize his ideas for async recursive functions
	//and extended his async encoder to use these new "Coroutine" classes
	public class JsonEncoderCoRoutine
	{
		private static var _charConvert : Array;
		
		private var _input : *;
		private var _output : IDataOutput;
		private var _byteOutput : ByteArray;
		private var _blockNonFiniteNumbers : Boolean;
		private var _tempBytes : ByteArray = new ByteArray();
		
		private var _isFinished : Boolean = false;
		
		/**
		 * A valid JSON-encoded string if writeTo is not specified, otherwise
		 * this will throw an error.
		 */
		public function get result() : String
		{
			if (!_byteOutput)
			{
				throw new Error("No result available when writeTo is used.");
			}
			if (!_isFinished)
			{
				throw new Error("This coroutine is still in process");
			}
//			if (!this.isDone)
//			{
//				throw new Error("This coroutine is still in process");
//			}
//			if (this.state != STATE_COMPLETED)
//			{
//				throw new Error("This thread hasn't been run yet");
//			}
			_byteOutput.position = 0;
			return _byteOutput.readUTFBytes(_byteOutput.length);
		}
		
		public function JsonEncoderCoRoutine(input : *, writeTo : IDataOutput = null, strictNumberParsing : Boolean = false)
		{
			//TB: the initial stack function
//			super(function(context : CoRoutineContext) : void
//			{
//				parseValue(input, context.pushFunction(this, afterFinished));
//				function afterFinished() : void
//				{
//					_isFinished = true;
//				}
//			}, context);
			
			_input = input;
			_blockNonFiniteNumbers = strictNumberParsing;
			
			// prepare the input
			if (writeTo)
			{
				_output = writeTo;
			}
			else
			{
				_output = _byteOutput = new ByteArray();
			}
			_output.endian = "bigEndian";
			
			// conversions for escaped characters
			if (!_charConvert)
			{
				_charConvert = new Array(0x100);
				for (var j : int = 0; j < 0xa; j++)
				{
					_charConvert[j] = (j + 0x30) | 0x30303000; // 000[0-9]
				}
				for (; j < 0x10; j++)
				{
					_charConvert[j] = (j + 0x37) | 0x30303000; // 000[A-F]
				}
				for (; j < 0x1a; j++)
				{
					_charConvert[j] = (j + 0x20) | 0x30303100; // 00[1][0-9]
				}
				for (; j < 0x20; j++)
				{
					_charConvert[j] = (j + 0x27) | 0x30303100; // 00[1][A-F]
				}
				for (; j < 0x100; j++)
				{
					_charConvert[j] = j;
				}
				_charConvert[0xa] = 0x5c6e; // \n
				_charConvert[0xd] = 0x5c72; // \r
				_charConvert[0x9] = 0x5c74; // \t
				_charConvert[0x8] = 0x5c62; // \b
				_charConvert[0xc] = 0x5c66; // \f
				_charConvert[0x8] = 0x5c62; // \b
				_charConvert[0x22] = 0x5c22; // \"
				_charConvert[0x5c] = 0x5c5c; // \\
				// not necessary for valid json
				//_charConvert[0x2f] = 0x5c2f; // \/
				_charConvert[0x7f] = 0x30303746; // 007F
			}
		}
		
		public function startParse(context : CoRoutineContext) : void
		{
			//TODO - make sure this can't be called more than once
			context.pushFunction(this,
				function() : void
				{
					parseValue(_input, context.pushFunction(this, afterFinished));
					function afterFinished() : void
					{
						_isFinished = true;
					}
				});
		}
		
		private function parseCollection(input : *, context : CoRoutineContext) : void
		{
			_output.writeByte(0x5b); // [
			
			//Get prepared to call the closing bracket when we're done
			context.pushFunction(this, afterLoop);
			
			var first : Boolean = true;
			context.foreach(input,
				function(item : *) : Boolean
				{
					if (first)
					{
						first = false;
					}
					else
					{
						_output.writeByte(0x2c); // ,
					}
					parseValue(item, context);
					return true;
				},
				this);
			
			function afterLoop() : void
			{
				_output.writeByte(0x5d); // ]
			}
			
		}
		
		protected function parseValue(input : *, context : CoRoutineContext) : void
		{
			switch (typeof input)
			{
				case "object":
					if (input)
					{
						if (input is Array)
						{
							parseCollection(input, context);
						}
						else if (input is IList)
						{
							parseCollection(input, context);
						}
						else
						{
							parseObject(input, context);
						}
					}
					else
					{
						_output.writeUnsignedInt(0x6e756c6c); // null
					}
					return;
				case "string":
					parseString(input);
					return;
				case "number":
					if (_blockNonFiniteNumbers && !isFinite(input as Number))
					{
						throw new Error("Number " + input + " is not encodable");
					}
					_output.writeUTFBytes(String(input));
					return;
				case "xml":
					if ((!input.toXMLString is Function) || (input = input.toXMLString() as String) == null)
					{
						throw new Error("unserializable XML object encountered");
					}
					parseString(input);
					return;
				case "boolean":
					if (input)
					{
						_output.writeUnsignedInt(0x74727565); // true
					}
					else
					{
						_output.writeByte(0x66); // f
						_output.writeUnsignedInt(0x616c7365); // alse
					}
					return;
				case "undefined":
					_output.writeUnsignedInt(0x6e756c6c); // null
					return;
				default:
					trace(input);
					break;
			}
			;
		}
		
		private function parseObject(input : Object, context : CoRoutineContext) : void
		{
			_output.writeByte(0x7b); // {
			
			var objType : Type = ASReflect.getTypeFrom(input);
			
			var first : Boolean = true;
			
			//Call this when the loop is done
			context.pushFunction(this, afterLoop);
			
			if (objType.name == "Object")
			{
				//We need to get its dynamic properties instead
				var keys : Array = [];
				for (var i : String in input)
				{
					keys[keys.length] = i;
				}
				context.foreach(keys,
					function(propertyName : String) : Boolean
					{
						if (first)
						{
							first = false;
						}
						else
						{
							_output.writeByte(0x2c); // ,
						}
						parseString(propertyName);
						_output.writeByte(0x3a); // :
						
						parseValue(input[propertyName], context);
						return true;
					}, this);
			}
				//TB: Uncomment if you are using the ASReflect libs
			else
			{
				context.foreach(objType.properties,
					function(property : Property) : Boolean
					{
						var propertyValue : Object;
						
						//The original code ignored read-only variables
						
						if (!property.isWritable || 
							!property.isReadable || 
							((property.uri != null) && (property.uri != "")))
						{
							return true;
						}
						propertyValue = property.getValue(input);
						
						//skip variables with null value
						if (propertyValue == null)
						{
							return true;
						}
						
						//we have to get rid of NaN values and convert them to null
						if (propertyValue is Number && isNaN(Number(propertyValue)))
						{
							return true;
						}
						
						if (first)
						{
							first = false;
						}
						else
						{
							_output.writeByte(0x2c); // ,
						}
						parseString(property.name);
						_output.writeByte(0x3a); // :
						parseValue(propertyValue, context);
						return true;
					},
					this);
			}
			
			function afterLoop() : void
			{
				_output.writeByte(0x7d); // }
			}
		}
		
		private function parseString(input : String) : void
		{
			_output.writeByte(0x22); // "
			_tempBytes.position = 0;
			_tempBytes.length = 0;
			_tempBytes.writeUTFBytes(input);
			var i : int = 0, j : int = 0, char : int;
			var strLen : int = _tempBytes.length;
			
			while (j < strLen)
			{
				char = _charConvert[_tempBytes[j++]];
				if (char > 0x100)
				{
					if (j - 1 > i)
					{
						// flush buffered string
						_output.writeBytes(_tempBytes, i, (j - 1) - i);
					}
					if (char > 0x10000)
					{ // \uxxxx (control character)
						_output.writeShort(0x5c75); // \u
						_output.writeUnsignedInt(char);
					}
					else
					{
						_output.writeShort(char);
					}
					i = j;
				}
			}
			// flush the rest of the string
			if (strLen > i)
			{
				_output.writeBytes(_tempBytes, i, strLen - i);
			}
			_output.writeByte(0x22); // "
		}
		
		//TB: Got this here; http://stackoverflow.com/questions/620045/how-to-refactor-code-inside-curly-braces-in-flex
		//Might be useful when needing to make typesafe classes from the data that has been read in
		//Haven't used it yet though
		//		public static function toInstance(object : Object, clazz : Class) : *
		//		{
		//			var bytes : ByteArray = new ByteArray();
		//			bytes.objectEncoding = ObjectEncoding.AMF0;
		//
		//			// Find the objects and byetArray.writeObject them, adding in the
		//			// class configuration variable name -- essentially, we're constructing
		//			// and AMF packet here that contains the class information so that
		//			// we can simplly byteArray.readObject the sucker for the translation
		//
		//			// Write out the bytes of the original object
		//			var objBytes : ByteArray = new ByteArray();
		//			objBytes.objectEncoding = ObjectEncoding.AMF0;
		//			objBytes.writeObject(object);
		//
		//			// Register all of the classes so they can be decoded via AMF
		//			var typeInfo : XML = describeType(clazz);
		//			var fullyQualifiedName : String = typeInfo.@name.toString().replace(/::/, ".");
		//			registerClassAlias(fullyQualifiedName, clazz);
		//
		//			// Write the new object information starting with the class information
		//			var len : int = fullyQualifiedName.length;
		//			bytes.writeByte(0x10); // 0x10 is AMF0 for "typed object (class instance)"
		//			bytes.writeUTF(fullyQualifiedName);
		//			// After the class name is set up, write the rest of the object
		//			bytes.writeBytes(objBytes, 1);
		//
		//			// Read in the object with the class property added and return that
		//			bytes.position = 0;
		//
		//			// This generates some ReferenceErrors of the object being passed in
		//			// has properties that aren't in the class instance, and generates TypeErrors
		//			// when property values cannot be converted to correct values (such as false
		//			// being the value, when it needs to be a Date instead).  However, these
		//			// errors are not thrown at runtime (and only appear in trace ouput when
		//			// debugging), so a try/catch block isn't necessary.  I'm not sure if this
		//			// classifies as a bug or not... but I wanted to explain why if you debug
		//			// you might seem some TypeError or ReferenceError items appear.
		//			var result : * = bytes.readObject();
		//			return result;
		//		}
		
	}
}