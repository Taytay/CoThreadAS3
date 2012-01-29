/*
 * Copyright(c) 2006-2007 the Spark project.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */

package org.libspark.asreflect.builders
{
    import flash.utils.Dictionary;
    
    /**
     * XMLパース中のコンテキストです。
     *
     * @author yossy
     */
    public class ParseContext
    {
        private var stack:Array = [];
        private var map:Dictionary = new Dictionary();
        
        /**
         * スタックに値を積みます。
         */
        public function push(value:Object):void
        {
            stack.unshift(value);
        }
        
        /**
         * スタックから値を降ろします。
         */
        public function pop():Object
        {
            return stack.shift();
        }
        
        /**
         * スタックに最後に積まれた値を返します。
         */
        public function peek():Object
        {
            return stack[0];
        }
        
        /**
         * 指定されたキーの値を設定します。
         * @param key キー
         * @param value 対応する値
         */
        public function setValue(key:String, value:Object):void
        {
            map[key] = value;
        }
        
        /**
         * 指定されたキーの値を返します。
         * @param キー
         * @return 対応する値
         */
        public function getValue(key:String):Object
        {
            return map[key];
        }
    }
}