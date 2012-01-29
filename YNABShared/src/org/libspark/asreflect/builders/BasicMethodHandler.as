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
    import org.libspark.asreflect.impls.BasicMethod;
    
    /**
     * method要素を処理し、Methodオブジェクトを生成します。
     *
     * @author yossy
     */
    public class BasicMethodHandler implements ElementHandler
    {
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return 'method';
        }
        
        /**
         * @private
         */
        public function handleStartElement(context:ParseContext, element:XML):void
        {
            var declaringClass:Class = ASReflect.getClassFromName(element.@declaredBy);
            var returnType:Class = null;
            if (element.@returnType == '*') {
                returnType = Object;
            }
            else if (element.@returnType != 'void') {
                try
                {
                  returnType = ASReflect.getClassFromName(element.@returnType);
                }
                catch(e : ReferenceError)
                {
                  //TB: Gets here if it can't find the class
                  returnType = Object;
                }
            };
						var uri:String=element.@uri;
            var isStatic:Boolean = context.getValue('isStatic');
            context.push(new BasicMethod(element.@name, declaringClass, returnType, isStatic, uri));
        }
        
        /**
         * @private
         */
        public function handleChildCreated(context:ParseContext, object:Object):void
        {
            if (object is Parameter) {
                BasicMethod(context.peek()).addParameter(Parameter(object));
            }
            else if (object is Metadata) {
                BasicMethod(context.peek()).addMetadata(Metadata(object));
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