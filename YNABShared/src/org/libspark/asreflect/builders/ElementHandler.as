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

package org.libspark.asreflect.builders
{
    /**
     * XML要素を処理し、オブジェクトを生成するためのインターフェイスです。
     *
     * @author yossy
     */
    public interface ElementHandler
    {
        /**
         * この要素の名前を返します。
         */
        function get name():String;
        
        /**
         * 要素の開始を処理します。
         * @param context 現在のコンテキスト
         * @param element 対象となる要素
         */
        function handleStartElement(context:ParseContext, element:XML):void;
        
        /**
         * 子要素によって作られたオブジェクトを処理します。
         * @param context 現在のコンテキスト
         * @param object 子要素によって作られたオブジェクト
         */
        function handleChildCreated(context:ParseContext, object:Object):void;
        
        /**
         * 要素の終了を処理し、最終的にこの要素によって作成されたオブジェクトを返します。
         * @param context 現在のコンテキスト
         * @return この要素によって作成されたオブジェクト
         */
        function handleEndElement(context:ParseContext):Object;
    }
}