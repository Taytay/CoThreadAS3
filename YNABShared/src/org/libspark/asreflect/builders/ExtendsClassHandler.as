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
    
    /**
     * extendsClass要素を処理し、ExtendsClassオブジェクトを生成します。
     *
     * @author yossy
     */
    public class ExtendsClassHandler implements ElementHandler
    {
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return 'extendsClass';
        }
        
        /**
         * @private
         */
        public function handleStartElement(context:ParseContext, element:XML):void
        {
          context.push(new ExtendsClass(ASReflect.getClassFromName(element.@type)));
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