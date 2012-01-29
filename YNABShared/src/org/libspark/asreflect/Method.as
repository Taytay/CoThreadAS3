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
     * クラスのメソッドを表現します。
     *
     * @author yossy
     */
    public interface Method extends Member
    {
        /**
         * このメソッドの引数を表す<code>Parameter</code>の配列を返します。引数が無い場合は空の配列を返します。
         * @see Parameter
         */
        function get parameters():Array;
        
        /**
         * このメソッドの戻り値の型を返します。
         * <code>void</code>の場合は<code>null</code>。<code>*</code>の場合は<code>Object</code>を返します。
         */
        function get returnType():Class;
        
        /**
         * このメソッドが表すメソッドを、指定したオブジェクトに対して指定した引数で呼び出します。
         * このメソッドが<code>static</code>の場合、<code>object</code>は無視されます。<code>null</code>を指定しても構いません。
         * このメソッドが引数を必要としない場合、<code>parameters</code>は無視されます。<code>null</code>を指定しても構いません。
         * @param object メソッドを呼び出す対象となるオブジェクト
         * @param parameters メソッドに渡す引数を格納した配列
         * @return 呼び出したメソッドの戻り値
         * @throws ArgumentError <code>object</code>がこのメソッドが定義されたクラスのインスタンスではない場合、<coe>parameters</code>がメソッドの定義と一致しない場合。
         */
        function invoke(object:Object, parameters:Array):*
    }
}