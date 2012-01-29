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
     * プロパティやメソッドなど、クラスのメンバの基底インターフェイスです。
     *
     * @author yossy
     */
    public interface Member extends MetadataAware
    {
        /**
         * このメンバの名前を返します。
         */
        function get name():String;
        
        /**
         * このメンバが定義されているクラスを返します。
         */
        function get declaringClass():Class;
        
        /**
         * このメンバが静的メンバであれば<code>true</code>、そうでなければ<code>false</code>を返します。
         */
        function get isStatic():Boolean;
				
				//TB: The URI (namespace) of this member
				function get uri():String;
    }
}