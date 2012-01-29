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
     * クラスのプロパティを表現します。
     *
     * @author yossy
     */
    public interface Property extends Member
    {
        /**
         * このプロパティがアクセッサ（getter/setter）を持っていれば<code>true</code>、そうでなければ<code>false</code>を返します。
         */
        function get hasAccessor():Boolean;
        
        /**
         * このプロパティが定数（<code>const</code>による宣言）であれば<code>true</code>、そうでなければ<code>false</code>を返します。
         */
        function get isConst():Boolean;
        
        /**
         * このプロパティが読み取り可能であれば<code>true</code>、そうでなければ<code>false</code>を返します。
         */
        function get isReadable():Boolean;
        
        /**
         * このプロパティが書き込み可能であれば<code>true</code>、そうでなければ<code>false</code>を返します。
         */
        function get isWritable():Boolean;
        
        /**
         * このプロパティの型を返します。<code>*</code>の場合は<code>Object</code>を返します。
         */
        function get type():Class;
        
        /**
         * 指定されたオブジェクトについて、このプロパティが表すプロパティの値を返します。
         * このプロパティが<code>static</code>の場合、<code>object</code>は無視されます。<code>null</code>を指定しても構いません。
         * @param object プロパティの読み取り対象となるオブジェクト
         * @return <code>object</code>における、このプロパティが表すプロパティの値
         * @throws ArgumentError <code>object</code>がこのプロパティが定義されたクラスのインスタンスではない場合
         */
        function getValue(object:Object):Object;
        
        /**
         * 指定されたオブジェクトについて、このプロパティが表すプロパティの値を設定します。
         * このプロパティが<code>static</code>の場合、<code>object</code>は無視されます。<code>null</code>を指定しても構いません。
         * @param object プロパティの設定対象となるオブジェクト
         * @param value プロパティの値
         * @throws ArgumentError <code>object</code>がこのプロパティが定義されたクラスのインスタンスではない場合、<code>value</code>がこのプロパティの型と一致しない場合
         */
        function setValue(object:Object, value:Object):void;
    }
}