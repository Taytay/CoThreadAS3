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
    import org.libspark.asreflect.Metadata;
    import org.libspark.asreflect.errors.NotFoundError;
    import flash.utils.Dictionary;
    
    /**
     * メタデータの実装です。
     *
     * @author yossy
     */
    public class BasicMetadata implements Metadata
    {
        private var _name:String;
        private var values:Dictionary = new Dictionary();
        
        public function BasicMetadata(name:String = null)
        {
            _name = name;
        }
        
        /*
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
         * 値を追加します。
         * @param key キー
         * @param value 値
         */
        public function addValue(key:String, value:String):void
        {
            values[key] = value;
        }
        
        /*
         * @inheritDoc
         */
        public function getValue(key:String):String
        {
            if (!hasValue(key)) {
                throw new NotFoundError();
            }
            return values[key];
        }
        
        /*
         * @inheritDoc
         */
        public function hasValue(key:String):Boolean
        {
            return values[key] != null;
        }
    }
}