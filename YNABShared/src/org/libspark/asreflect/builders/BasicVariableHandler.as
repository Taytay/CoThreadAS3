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
     * variable要素を処理し、Propertyオブジェクトを生成します。
     *
     * @author yossy
     */
    public class BasicVariableHandler implements ElementHandler
    {
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return 'variable';
        }
        
        /**
         * @private
         */
        public function handleStartElement(context:ParseContext, element:XML):void
        {
            var declaringClass:Class = Class(context.getValue('declaringClass'));
            var type:Class = element.@type == '*' ? Object : ASReflect.getClassFromName(element.@type);
            var isStatic:Boolean = context.getValue('isStatic');
						var uri:String = element.@uri;
            context.push(new BasicProperty(element.@name, declaringClass, type, true, true, false, false, isStatic, uri));
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