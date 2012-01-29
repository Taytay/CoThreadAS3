/*      
.__       _____   ____    ______      ______   __  __     
/\ \     /\  __`\/\  _`\ /\__  _\    /\__  _\ /\ \/\ \    
\ \ \    \ \ \/\ \ \,\L\_\/_/\ \/    \/_/\ \/ \ \ `\\ \   
.\ \ \  __\ \ \ \ \/_\__ \  \ \ \       \ \ \  \ \ , ` \  
..\ \ \L\ \\ \ \_\ \/\ \L\ \ \ \ \       \_\ \__\ \ \`\ \ 
...\ \____/ \ \_____\ `\____\ \ \_\      /\_____\\ \_\ \_\
....\/___/   \/_____/\/_____/  \/_/      \/_____/ \/_/\/_/


.______  ____    ______  ______   _____   __  __  ____    ____     ____    ______   ____    ______   
/\  _  \/\  _`\ /\__  _\/\__  _\ /\  __`\/\ \/\ \/\  _`\ /\  _`\  /\  _`\ /\__  _\ /\  _`\ /\__  _\  
\ \ \L\ \ \ \/\_\/_/\ \/\/_/\ \/ \ \ \/\ \ \ `\\ \ \,\L\_\ \ \/\_\\ \ \L\ \/_/\ \/ \ \ \L\ \/_/\ \/  
.\ \  __ \ \ \/_/_ \ \ \   \ \ \  \ \ \ \ \ \ , ` \/_\__ \\ \ \/_/_\ \ ,  /  \ \ \  \ \ ,__/  \ \ \  
..\ \ \/\ \ \ \L\ \ \ \ \   \_\ \__\ \ \_\ \ \ \`\ \/\ \L\ \ \ \L\ \\ \ \\ \  \_\ \__\ \ \/    \ \ \ 
...\ \_\ \_\ \____/  \ \_\  /\_____\\ \_____\ \_\ \_\ `\____\ \____/ \ \_\ \_\/\_____\\ \_\     \ \_\
....\/_/\/_/\/___/    \/_/  \/_____/ \/_____/\/_/\/_/\/_____/\/___/   \/_/\/ /\/_____/ \/_/      \/_/

Copyright (c) 2008 Lost In Actionscript - Shane McCartney

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

//TB: Grabbed from here: http://code.google.com/p/lostinactionscript/source/browse/trunk/library/com/lia/utils/SimpleObjectPool.as
package com.lia.utils {
	
	public class SimpleObjectPool {
		
		public var minSize : int;
		public var size : int = 0;
		
		public var create : Function;
		public var clean : Function;
		public var length : int = 0;
		
		private var list : Vector.<Object> = new Vector.<Object>();
		private var disposed : Boolean = false;
		
		public function SimpleObjectPool(create : Function, clean : Function = null, minSize : int = 50) {
			this.create = create;
			this.clean = clean;
			this.minSize = minSize;
			
			for(var i : int = 0;i < minSize; i++) 
			{
				add();
			}
		}
		
		public function add() : void {
			list[length++] = create();
			++size;
		}
		
		public function checkOut() : * {
			if(length == 0) {
				++size;
				return create();
			}
			
			return list[--length];
		}
		
		public function checkIn(item : *) : void {
			if(clean != null)
			{
				clean(item);
			}
			list[length++] = item;
		}
		
		public function dispose() : void {
			if(disposed)
			{
				return;
			}
			
			disposed = true;
			
			create = null;
			clean = null;
			list = null;
		}
	}
}