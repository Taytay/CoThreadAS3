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
    import flash.utils.getDefinitionByName;
    
    import org.libspark.asreflect.builders.BasicTypeFactory;
    
    /**
     * ASReflectを簡単に使用するためのユーティリティクラスです。
     *
     * @author yossy
     */
    public class ASReflect
    {
        private static var factory:TypeFactory = new BasicTypeFactory();
     
				
				public static function getClassFromName(className : String) : Class
				{
					if (className == "__AS3__.vec::Vector.<*>")
					{
						className = "Object";
					} 
					return Class(getDefinitionByName(className))
				}
				
        /**
         * 指定されたクラスからそのクラスの型情報を表すTypeクラスのインスタンスを返します。
         * @param from 型情報を取得するクラス
         * @return <code>from</code>で指定されたクラスの型情報を表すTypeクラスのインスタンス
         */
        public static function getType(from:Class):Type
        {
            return factory.create(from);
        }
        
        /**
         * 指定されたオブジェクトからそのオブジェクトのクラスの型情報を表すTypeクラスのインスタンスを返します。
         * @param instance 型情報を取得するオブジェクト
         * @return <code>instance</code>で指定されたオブジェクトの型情報を表すTypeクラスのインスタンス
         */
        public static function getTypeFrom(instance:Object):Type
        {
          return factory.create(instance.constructor);
        }
    }
}