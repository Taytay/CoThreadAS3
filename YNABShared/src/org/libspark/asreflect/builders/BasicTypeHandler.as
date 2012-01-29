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
    import flash.utils.getQualifiedSuperclassName;
    
    import org.libspark.asreflect.ASReflect;
    import org.libspark.asreflect.Method;
    import org.libspark.asreflect.Property;
    import org.libspark.asreflect.Type;
    import org.libspark.asreflect.TypeFactory;
    import org.libspark.asreflect.impls.BasicType;
    
    /**
     * type要素を処理し、Typeオブジェクトを生成します。
     *
     * @author yossy
     */
    public class BasicTypeHandler implements ElementHandler
    {
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return 'type';
        }
        
        /**
         * @private
         */
        public function handleStartElement(context:ParseContext, element:XML):void
        {
            var className:String = element.@name;
            var name:String = className;
            var packageName:String = '';
            if (name.indexOf('::') != -1) {
                var names:Array = name.split('::', 2);
                packageName = names[0];
                name = names[1];
            }
            var nativeClass:Class = ASReflect.getClassFromName(className);
            var superClassName:String = getQualifiedSuperclassName(nativeClass);
						var superClass : Class = superClassName != null ? ASReflect.getClassFromName(superClassName) : null;
						var typeFactory:TypeFactory = TypeFactory(context.getValue('typeFactory'));
            var superType:Type = superClass && typeFactory ? typeFactory.create(superClass) : null;
            var isInterface:Boolean = nativeClass != Object && superClass == null;
            var type:Type = new BasicType(name, packageName, nativeClass, superClass, superType, isInterface);
            
            context.push(context.getValue('declaringClass'));
            context.setValue('declaringClass', nativeClass);
            context.push(context.getValue('type'));
            context.setValue('type', type);
            context.push(context.getValue('isStatic'));
            context.setValue('isStatic', true);
            context.push(type);
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
        }
        
        /**
         * @private
         */
        public function handleEndElement(context:ParseContext):Object
        {
            var type:Type = Type(context.pop());
            
            context.setValue('isStatic', context.pop());
            context.setValue('type', context.pop());
            context.setValue('declaringClass', context.pop());
            
            return type;
        }
    }
}