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
    import flash.utils.getDefinitionByName;
    
    import org.libspark.asreflect.ASReflect;
    import org.libspark.asreflect.Metadata;
    import org.libspark.asreflect.Parameter;
    import org.libspark.asreflect.impls.BasicProperty;
    
    /**
     * accessor要素を処理し、Propertyオブジェクトを生成します。
     *
     * @author yossy
     */
    public class BasicAccessorHandler implements ElementHandler
    {
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return 'accessor';
        }
        
        /**
         * @private
         */
        public function handleStartElement(context:ParseContext, element:XML):void
        {
            var declaringClass:Class = ASReflect.getClassFromName(element.@declaredBy);
            var type:Class = element.@type == '*' ? Object : ASReflect.getClassFromName(element.@type);
            var isStatic:Boolean = context.getValue('isStatic');
            var access:String = element.@access;
						//TB: The namespace for this property
						//For instance, if an mx_internal property is declared, its uri will be: http://www.adobe.com/2006/flex/mx/internal
						var uri:String = element.@uri;
            var isReadable:Boolean = access == 'readonly' || access == 'readwrite';
            var isWritable:Boolean = access == 'writeonly' || access == 'readwrite';
            context.push(new BasicProperty(element.@name, declaringClass, type, isReadable, isWritable, true, false, isStatic, uri));
        }
        
        /**
         * @private
         */
        public function handleChildCreated(context:ParseContext, object:Object):void
        {
            if (object is Metadata) {
                BasicProperty(context.peek()).addMetadata(Metadata(object));
            }
        }
        
        /**
         * @private
         */
        public function handleEndElement(context:ParseContext):Object
        {
            return context.pop();
        }
    }
}