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
    import org.libspark.asreflect.MetadataAware;
    import org.libspark.asreflect.errors.NotFoundError;
    import flash.utils.Dictionary;
    
    /**
     * メタデータを保持が可能なオブジェクトの実装をサポートします。
     *
     * @author yossy
     */
    public class MetadataAwareSupport implements MetadataAware
    {
        private var metaList:Array = [];
        private var metaMap:Dictionary = new Dictionary();
        
        /**
         * @inheritDoc
         */
        public function get metadatas():Array
        {
            return metaList.slice();
        }
        
        /**
         * メタデータを追加します。
         * @param metadata メタデータ
         */
        public function addMetadata(metadata:Metadata):void
        {
            metaList.push(metadata);
            metaMap[metadata.name] = metadata;
        }
        
        /**
         * @inheritDoc
         */
        public function getMetadata(name:String):Metadata
        {
            if (!hasMetadata(name)) {
                throw new NotFoundError();
            }
            return metaMap[name];
        }
        
        /**
         * @inheritDoc
         */
        public function hasMetadata(name:String):Boolean
        {
            return metaMap[name] != null;
        }
    }
}