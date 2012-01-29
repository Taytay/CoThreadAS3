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
     * クラスの型情報を表現します。
     *
     * @author yossy
     */
    public interface Type extends MetadataAware
    {
        /**
         * このクラスの名前を返します。
         */
        function get name():String;
        
        /**
         * このクラスが定義されているパッケージの名前を返します。トップレベルの場合は空文字列を返します。
         */
        function get packageName():String;
        
        /**
         * このクラスの完全修飾名を返します。
         */
        function get qualifiedName():String;
        
        /**
         * このクラスが表現する<code>Class</code>オブジェクトを返します。
         */
        function get nativeClass():Class;
        
        /**
         * このクラスのスーパークラスを返します。このクラスがインターフェイス、又は<code>Object</code>の場合は<code>null</code>を返します。
         */
        function get superClass():Class;
        
        /**
         * このクラスの全てのスーパークラスを表す<coode>Class</code>の配列を返します。このクラスがインターフェイス、又は<code>Object</code>の場合は空の配列を返します。
         */
        function get superClasses():Array;
        
        /**
         * このクラスがインターフェイスであれば<code>true</code>、そうでなければ<code>false</code>を返します。
         */
        function get isInterface():Boolean;
        
        /**
         * このクラスが実装する全てのインターフェイスを表す<code>Class</code>の配列を返します。
         */
        function get interfaces():Array;
        
        /**
         * このクラスによって定義されているプロパティをを表す<code>Property</code>の配列返します。
         * スーパークラスから継承したプロパティは含まれません。
         * @see Property
         */
        function get declaredProperties():Array;
        
        /**
         * このクラスによって定義されているメソッドを表す<code>Method</code>の配列を返します。
         * スーパークラスから継承したメソッドは含まれません。
         * @see Method
         */
        function get declaredMethods():Array;
        
        /**
         * このクラスに定義されている全てのプロパティを表す<code>Property</code>の配列を返します。
         * スーパークラスから継承したプロパティも含まれます。
         * @see Property
         */
        function get properties():Array;
        
        /**
         * このクラスに定義されている全てのメソッドを表す<code>Method</code>の配列を返します。
         * スーパークラスから継承したメソッドも含まれます。
         * @see Method
         */
        function get methods():Array;
        
        /**
         * このクラスのコンストラクタの引数を表す<code>Parameter</code>の配列を返します。引数が無い場合は空の配列を返します。
         * @see Parameter
         */
        function get parameters():Array;
        
        /**
         * このクラスが指定されたクラスのサブクラスであるかどうかを返します。
         * @param type 比較対象のクラス
         * @return このクラスが<code>type</code>で指定されたクラスのサブクラスであれば<code>true</code>、そうでなければ<code>false</code>
         */
        function isSubclassOf(type:Class):Boolean;
        
        /**
         * このクラスが指定されたインターフェイスを実装しているかどうかを返します。
         * @param type 比較対象のインターフェイス
         * @return このクラスが<code>type</code>で指定されたインターフェイスを実装していれば<code>true</code>、そうでなければ<code>false</code>
         */
        function isImplements(type:Class):Boolean;
        
        /**
         * 指定されたクラスがこのクラスに代入可能かどうかを返します。
         * @param type 比較対象のクラス
         * @return <code>type</code>がこのクラスに代入可能であれば<code>true</code>、そうでなければ<code>false</code>
         */
        function isAssignableFrom(type:Class):Boolean;
        
        /**
         * 指定されたオブジェクトがこのクラス又はサブクラスのインスタンスであるかどうかを返します。<code>is</code>演算子と同じです。
         * @param object 比較対象のオブジェクト
         * @return <code>object</code>がこのクラス又はサブクラスのインスタンスであれば<code>true</code>、そうでなければ<code>false</code>
         */
        function isInstance(object:Object):Boolean;
        
        /**
         * このクラスの新しいインスタンスを生成します。
         * @param parameters このクラスのコンストラクタに渡す引数の配列
         * @return 生成されたインスタンス
         * @throws ArgumentError <code>parameters</code>で渡された引数が定義と一致しない場合
         */
        function newInstance(parameters:Array):Object
        
        /**
         * このクラスによって定義されたプロパティを返します。スーパークラスから継承したプロパティは含みません。
         * @param name 取得するプロパティの名前
         * @return <code>name</code>で指定された名前のプロパティ
         * @throws NotFoundError 指定されたプロパティが見つからない場合
         */
        function getDeclaredProperty(name:String):Property;
        
        /**
         * 指定された名前のプロパティがこのクラスによって定義されているかどうかを返します。スーパークラスから継承したプロパティは含みません。
         * @param name チェックするプロパティの名前
         * @return <code>name</code>で指定された名前のプロパティが定義されていれば<code>true</code>、そうでなければ<code>false</code>
         */
        function hasDeclaredProperty(name:String):Boolean;
        
        /**
         * このクラスによって定義されたメソッドを返します。スーパークラスから継承したメソッドは含みません。
         * @param name 取得するメソッドの名前
         * @return <code>name</code>で指定された名前のメソッド
         * @throws NotFoundError 指定されたメソッドが見つからない場合
         */
        function getDeclaredMethod(name:String):Method;
        
        /**
         * 指定された名前のメソッドがこのクラスによって定義されているかどうかを返します。スーパークラスから継承したメソッドは含みません。
         * @param name チェックするメソッドの名前
         * @return <code>name</code>で指定された名前のメソッドが定義されていれば<code>true</code>、そうでなければ<code>false</code>
         */
        function hasDeclaredMethod(name:String):Boolean;
        
        /**
         * このクラスに定義されたプロパティを返します。スーパークラスから継承したプロパティも含みます。
         * @param name 取得するプロパティの名前
         * @return <code>name</code>で指定された名前のプロパティ
         * @throws NotFoundError 指定されたプロパティが見つからない場合
         */
        function getProperty(name:String):Property;
        
        /**
         * 指定された名前のプロパティがこのクラスに定義されているかどうかを返します。スーパークラスから継承したプロパティも含みます。
         * @param name チェックするプロパティの名前
         * @return <code>name</code>で指定された名前のプロパティが定義されていれば<code>true</code>、そうでなければ<code>false</code>
         */
        function hasProperty(name:String):Boolean;
        
        /**
         * このクラスに定義されたメソッドを返します。スーパークラスから継承したメソッドも含みます。
         * @param name 取得するメソッドの名前
         * @return <code>name</code>で指定された名前のメソッド
         * @throws NotFoundError 指定されたメソッドが見つからない場合
         */
        function getMethod(name:String):Method;
        
        /**
         * 指定された名前のメソッドがこのクラスに定義されているかどうかを返します。スーパークラスから継承したメソッドも含みます。
         * @param name チェックするメソッドの名前
         * @return <code>name</code>で指定された名前のメソッドが定義されていれば<code>true</code>、そうでなければ<code>false</code>
         */
        function hasMethod(name:String):Boolean;
    }
}