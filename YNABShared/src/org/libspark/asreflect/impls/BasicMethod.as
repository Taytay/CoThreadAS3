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
    import org.libspark.asreflect.Method;
    import org.libspark.asreflect.Parameter;
    
    /**
     * クラスのメソッドを実装します。
     *
     * @author yossy
     */
    public class BasicMethod extends BasicMember implements Method
    {
        public function BasicMethod(name:String = null, declaringClass:Class = null, returnType:Class = null, isStatic:Boolean = false, uri:String = null)
        {
            super(name, declaringClass, isStatic, uri);
            _returnType = returnType;
        }
        
        private var _parameters:Array = [];
        private var _returnType:Class;
        
        /**
         * @inheritDoc
         */
        public function get parameters():Array
        {
            return _parameters.slice();
        }
        
        /**
         * 引数を追加します。
         * @param parameter 引数
         */
        public function addParameter(parameter:Parameter):void
        {
            _parameters.push(parameter);
        }
        
        /**
         * @inheritDoc
         */
        public function get returnType():Class
        {
            return _returnType;
        }
        
        /**
         * @private
         */
        public function set returnType(value:Class):void
        {
            _returnType = value;
        }
        
        /**
         * @inheritDoc
         */
        public function invoke(object:Object, parameters:Array):*
        {
            if (isStatic) {
                return declaringClass[name].apply(null, parameters);
            }
            if (!(object is declaringClass)) {
                throw new ArgumentError();
            }
            return object[name].apply(object, parameters);
        }
    }
}