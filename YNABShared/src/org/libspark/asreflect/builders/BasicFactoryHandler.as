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
    import org.libspark.asreflect.impls.BasicType;
    import org.libspark.asreflect.Method;
    import org.libspark.asreflect.Property;
    import org.libspark.asreflect.Metadata;
    import flash.utils.getDefinitionByName;
    
    /**
     * factory要素を処理します。
     *
     * @author yossy
     */
    public class BasicFactoryHandler implements ElementHandler
    {
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return 'factory';
        }
        
        /**
         * @private
         */
        public function handleStartElement(context:ParseContext, element:XML):void
        {
            context.push(context.getValue('isStatic'));
            context.setValue('isStatic', false);
            context.push(context.getValue('type'));
        }
        
        /**
         * @private
         */
        public function handleChildCreated(context:ParseContext, object:Object):void
        {
          var type:BasicType;
            if (object is Method) {
                type = BasicType(context.peek());
                var method:Method = Method(object);
                
                if (method.declaringClass != type.nativeClass) {
                    return;
                }
                
                type.addMethod(method);
            }
            else if (object is Property) {
                type = BasicType(context.peek());
                var property:Property = Property(object);
                
                if (property.hasAccessor) {
                    if (property.declaringClass != type.nativeClass) {
                        return;
                    }
                }
                else {
                    if (type.superType && type.superType.hasProperty(property.name)) {
                        return;
                    }
                }
                
                type.addProperty(property);
            }
            else if (object is ExtendsClass) {
                BasicType(context.peek()).addSuperClass(ExtendsClass(object).type);
            }
            else if (object is ImplementsInterface) {
                BasicType(context.peek()).addInterface(ImplementsInterface(object).type);
            }
            else if (object is Metadata) {
                BasicType(context.peek()).addMetadata(Metadata(object));
            }
        }
        
        /**
         * @private
         */
        public function handleEndElement(context:ParseContext):Object
        {
            context.pop();
            context.setValue('isStatic', context.pop());
            
            return null;
        }
    }
}