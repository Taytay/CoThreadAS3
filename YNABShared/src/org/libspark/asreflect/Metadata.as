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
     * メタデータを表します。
     *
     * @author yossy
     */
    public interface Metadata
    {
        /**
         * このメタデータの名前を返します。
         */
        function get name():String;
        
        /**
         * このメタデータの値を取得します。
         * @param key 取得する値のキー
         * @return <code>key</code>で指定されたキーの値
         * @throws NotFoundError 指定されたキーの値が見つからない場合
         */
        function getValue(key:String):String;
        
        /**
         * 指定されたキーの値が存在するかどうかを返します。
         * @param key チェックするキー
         * @return <code>key</code>で指定されたキーの値があれば<code>true</code>、そうでなければ<code>false</code>
         */
        function hasValue(key:String):Boolean;
    }
}