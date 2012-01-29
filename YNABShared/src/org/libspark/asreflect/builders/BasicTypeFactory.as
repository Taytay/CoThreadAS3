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
    import org.libspark.asreflect.Type;
    import org.libspark.asreflect.TypeFactory;
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    
    /**
     * Typeのファクトリです。
     *
     * @author yossy
     */
    public class BasicTypeFactory implements TypeFactory
    {
        public function BasicTypeFactory()
        {
            parser = new XmlParser();
            parser.addElementHandler(new ArgHandler());
            parser.addElementHandler(new BasicMetadataHandler());
            parser.addElementHandler(new BasicVariableHandler());
            parser.addElementHandler(new BasicConstantHandler());
            parser.addElementHandler(new BasicAccessorHandler());
            parser.addElementHandler(new BasicParameterHandler());
            parser.addElementHandler(new BasicMethodHandler());
            parser.addElementHandler(new ExtendsClassHandler());
            parser.addElementHandler(new ImplementsInterfaceHandler());
            parser.addElementHandler(new BasicConstructorHandler());
            parser.addElementHandler(new BasicFactoryHandler());
            parser.addElementHandler(new BasicTypeHandler());
            cache = new Dictionary();
            context = new ParseContext();
            context.setValue('typeFactory', this);
        }
        
        private var parser:XmlParser;
        private var cache:Dictionary;
        private var context:ParseContext;
        
        /**
         * @inheritDoc
         */
        public function create(from:Class):Type
        {
            return cache[from] || createType(from);
        }
        
        protected function createType(from:Class):Type
        {
            var type:Type = Type(parser.parse(describeType(from), context));
            
            cache[from] = type;
            
            return type;
        }
    }
}