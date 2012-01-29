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
    import org.libspark.asreflect.Property;
    
    import spark.components.Label;
    
    /**
     * クラスのプロパティを実装します。
     *
     * @author yossy
     */
    public class BasicProperty extends BasicMember implements Property
    {
        public function BasicProperty(name:String = null, declaringClass:Class = null, type:Class = null,
                                      isReadable:Boolean = true, isWritable:Boolean = true, hasAccessor:Boolean = false,
                                      isConst:Boolean = false, isStatic:Boolean = false,
																			uri:String=null)
        {
            super(name, declaringClass, isStatic, uri);
            _type = type;
            _isReadable = isReadable;
            _isWritable = isWritable;
            _hasAccessor = hasAccessor;
            _isConst = isConst;
						
        }
        
        private var _hasAccessor:Boolean;
        private var _isConst:Boolean;
        private var _isReadable:Boolean;
        private var _isWritable:Boolean;
        private var _type:Class;
        
        /**
         * @inheritDoc
         */
        public function get hasAccessor():Boolean
        {
            return _hasAccessor;
        }
        
        /**
         * @private
         */
        public function set hasAccessor(value:Boolean):void
        {
            _hasAccessor = value;
        }
        
        /**
         * @inheritDoc
         */
        public function get isConst():Boolean
        {
            return _isConst;
        }
        
        /**
         * @private
         */
        public function set isConst(value:Boolean):void
        {
            _isConst = value;
        }
        
        /**
         * @inheritDoc
         */
        public function get isReadable():Boolean
        {
            return _isReadable;
        }
        
        /**
         * @private
         */
        public function set isReadable(value:Boolean):void
        {
            _isReadable = value;
        }
        
        /**
         * @inheritDoc
         */
        public function get isWritable():Boolean
        {
            return _isWritable;
        }
        
        /**
         * @private
         */
        public function set isWritable(value:Boolean):void
        {
            _isWritable = value;
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
        public function getValue(object:Object):Object
        {
            if (isStatic) {
                return declaringClass[name];
            }
            
						//TB: If you are trying to get the value of a property with a uri,
						//the following will not work and will throw an exception
						//I don't need this right now, so I'm not going to bother finding out how to do it,
						//but I wanted to note it.
            return object[name];
        }
        
        /**
         * @inheritDoc
         */
        public function setValue(object:Object, value:Object):void
        {
            if (isStatic) {
                declaringClass[name] = value;
                return;
            }
            if (!(object is declaringClass)) {
                throw new ArgumentError();
            }
            object[name] = value;
        }
    }
}