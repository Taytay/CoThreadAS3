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
    import org.libspark.asreflect.impls.BasicParameter;
    
    /**
     * parameter要素を処理し、Parameterオブジェクトを生成します。
     *
     * @author yossy
     */
    public class BasicParameterHandler implements ElementHandler
    {
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return 'parameter';
        }
        
        /**
         * @private
         */
        public function handleStartElement(context:ParseContext, element:XML):void
        {
            var index:int = parseInt(element.@index) - 1;
            var type:Class = element.@type == '*' ? Object : ASReflect.getClassFromName(element.@type);
            var isOptional:Boolean = element.@optional == 'true' ? true : false;
            context.push(new BasicParameter(index, type, isOptional));
        }
        
        /**
         * @private
         */
        public function handleChildCreated(context:ParseContext, object:Object):void
        {
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