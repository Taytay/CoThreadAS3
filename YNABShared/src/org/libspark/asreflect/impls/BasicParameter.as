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

package org.libspark.asreflect.impls
{
    import org.libspark.asreflect.Parameter;
    
    /**
     * コンストラクタやメソッドの引数の実装です。
     *
     * @author yossy
     */
    public class BasicParameter implements Parameter
    {
        public function BasicParameter(index:int = -1, type:Class = null, isOptional:Boolean = false)
        {
            _index = index;
            _type = type;
            _isOptional = isOptional;
        }
        
        private var _index:int;
        private var _type:Class;
        private var _isOptional:Boolean;
        
        /**
         * @inheritDoc
         */
        public function get index():int
        {
            return _index;
        }
        
        /**
         * @private
         */
        public function set index(value:int):void
        {
            _index = value;
        }
        
        /**
         * @inheritDoc
         */
        public function get type():Class
        {
            return _type;
        }
        
        /**
         * @private
         */
        public function set type(value:Class):void
        {
            _type = value;
        }
        
        /**
         * @inheritDoc
         */
        public function get isOptional():Boolean
        {
            return _isOptional;
        }
        
        /**
         * @private
         */
        public function set isOptional(value:Boolean):void
        {
            _isOptional = value;
        }
    }
}