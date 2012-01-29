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
     * コンストラクタやメソッドの引数を表現します。
     *
     * @author yossy
     */
    public interface Parameter
    {
        /**
         * この引数の<code>0</code>から始まるインデックスを返します。
         */
        function get index():int;
        
        /**
         * この引数の型を返します。<code>*</code>の場合は<code>Object</code>を返します。
         */
        function get type():Class;
        
        /**
         * この引数が省略可能であれば<code>true</code>、そうでなければ<code>false</code>を返します。
         */
        function get isOptional():Boolean;
    }
}