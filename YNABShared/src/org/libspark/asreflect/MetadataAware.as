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

package org.libspark.asreflect
{
    /**
     * メタデータを保持が可能なオブジェクトを表します。
     *
     * @author yossy
     */
    public interface MetadataAware
    {
        /**
         * このオブジェクトが保持しているメタデータを表す<code>Metadata</code>の配列を返します。
         */
        function get metadatas():Array;
        
        /**
         * 指定された名前のメタデータを返します。
         * @param name 取得するメタデータの名前
         * @return <code>name</code>で指定された名前のメタデータ
         * @throws NotFoundError 指定された名前のメタデータが存在しない場合
         */
        function getMetadata(name:String):Metadata
        
        /**
         * 指定された名前のメタデータが存在するかどうかを返します。
         * @param name チェックするメタデータの名前
         * @return <code>name</code>で指定されたメタデータが存在すれば<code>true</code>、そうでなければ<code>false</code>
         */
        function hasMetadata(name:String):Boolean;
    }
}