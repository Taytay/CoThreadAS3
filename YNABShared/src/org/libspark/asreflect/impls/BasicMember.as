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
    import org.libspark.asreflect.Member;
    
    /**
     * プロパティやメソッドなど、クラスのメンバの基底クラスです。
     *
     * @author yossy
     */
    public class BasicMember extends MetadataAwareSupport implements Member
    {
        public function BasicMember(name:String = null, declaringClass:Class = null, isStatic:Boolean = false, uri:String = null)
        {
            _name = name;
            _declaringClass = declaringClass;
            _isStatic = isStatic;
						_uri = uri;
        }
        
        private var _name:String;
        private var _declaringClass:Class;
        private var _isStatic:Boolean;
				private var _uri:String;
        
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return _name;
        }
        
        /**
         * @private
         */
        public function set name(value:String):void
        {
            _name = value;
        }
        
        /**
         * @inheritDoc
         */
        public function get declaringClass():Class
        {
            return _declaringClass;
        }
        
        /**
         * @private
         */
        public function set declaringClass(value:Class):void
        {
            _declaringClass = value;
        }
        
        /**
         * @inheritDoc
         */
        public function get isStatic():Boolean
        {
            return _isStatic;
        }
        
        /**
         * @private
         */
        public function set isStatic(value:Boolean):void
        {
            _isStatic = value;
        }
				
				/**
				 * @inheritDoc
				 */
				public function get uri():String
				{
					return _uri;
				}
				
				/**
				 * @private
				 */
				public function set uri(value:String):void
				{
					_uri = value;
				}
    }
}