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

package org.libspark.asreflect.impls
{
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedSuperclassName;
    
    import org.libspark.asreflect.ASReflect;
    import org.libspark.asreflect.Method;
    import org.libspark.asreflect.Parameter;
    import org.libspark.asreflect.Property;
    import org.libspark.asreflect.Type;
    import org.libspark.asreflect.errors.ASReflectError;
    import org.libspark.asreflect.errors.NotFoundError;
    
    /**
     * クラスの型情報を実装します。
     *
     * @author yossy
     */
    public class BasicType extends MetadataAwareSupport implements Type
    {
        public function BasicType(name:String = null, packageName:String = null, nativeClass:Class = null,
                                  superClass:Class = null, superType:Type = null, isInterface:Boolean = false)
        {
            _name = name;
            _packageName = packageName;
            _nativeClass = nativeClass;
            _superClass = superClass;
            _superType = superType;
            _isInterface = isInterface;
        }
        
        private var _name:String;
        private var _packageName:String;
        private var _nativeClass:Class;
        private var _superClass:Class;
        private var _superClasses:Array = [];
        private var _superType:Type;
        private var _isInterface:Boolean;
        private var _interfaces:Array = [];
        private var _parameters:Array = [];
        private var _declaredProperties:Array = [];
        private var _declaredPropertyMap:Dictionary = new Dictionary();
        private var _declaredMethods:Array = [];
        private var _declaredMethodMap:Dictionary = new Dictionary();
        private var _properties:Array;
        private var _propertyMap:Dictionary;
        private var _methods:Array;
        private var _methodMap:Dictionary;
        
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return _name;
        }
        
        /**
         * @private
         */
        public function set name(value:String):void
        {
            _name = value;
        }
        
        /**
         * @inheritDoc
         */
        public function get packageName():String
        {
            return _packageName;
        }
        
        /**
         * @private
         */
        public function set packageName(value:String):void
        {
            _packageName = value;
        }
        
        /**
         * @inheritDoc
         */
        public function get qualifiedName():String
        {
            return _packageName ? _packageName + '::' + name : name;
        }
        
        /**
         * @inheritDoc
         */
        public function get nativeClass():Class
        {
            return _nativeClass;
        }
        
        /**
         * @private
         */
        public function set nativeClass(value:Class):void
        {
            _nativeClass = value;
        }
        
        /**
         * @inheritDoc
         */
        public function get superClass():Class
        {
            return _superClass;
        }
        
        /**
         * @private
         */
        public function set superClass(value:Class):void
        {
            _superClass = value;
        }
        
        /**
         * @inheritDoc
         */
        public function get superClasses():Array
        {
            return _superClasses.slice();
        }
        
        /**
         * このクラスのスーパークラスを追加します。
         * @param superClass スーパークラス
         */
        public function addSuperClass(superClass:Class):void
        {
            _superClasses.push(superClass);
        }
        
        /**
         * このクラスのスーパークラスの型を設定します。
         */
        public function get superType():Type
        {
            return _superType;
        }
        
        /**
         * @private
         */
        public function set superType(value:Type):void
        {
            _properties = null;
            _propertyMap = null;
            _methods = null;
            _methodMap = null;
            
            _superType = value;
        }
        
        /**
         * @inheritDoc
         */
        public function get isInterface():Boolean
        {
            return _isInterface;
        }
        
        /**
         * @private
         */
        public function set isInterface(value:Boolean):void
        {
            _isInterface = value;
        }
        
        /**
         * インターフェイスを追加します。
         * @param interfaceClass インターフェイス
         */
        public function addInterface(interfaceClass:Class):void
        {
            _interfaces.push(interfaceClass);
        }
        
        /**
         * @inheritDoc
         */
        public function get interfaces():Array
        {
            return _interfaces.slice();
        }
        
        /**
         * このクラスによって定義されたプロパティを追加します。
         * @param method プロパティ
         */
        public function addProperty(property:Property):void
        {
            _declaredProperties.push(property);
            _declaredPropertyMap[property.name] = property;
        }
        
        /**
         * このクラスによって定義されたメソッドを追加します。
         * @param method メソッド
         */
        public function addMethod(method:Method):void
        {
            _declaredMethods.push(method);
            //TB: Handles things like methods named "hasOwnProperty", which is already declared on declaredMethodMap
            if (_declaredMethodMap[method.name] == null)
            {
              _declaredMethodMap[method.name] = method;
            }
        }
        
        /**
         * @inheritDoc
         */
        public function get declaredProperties():Array
        {
            return _declaredProperties.slice().sortOn("name");
        }
        
        /**
         * @inheritDoc
         */
        public function get declaredMethods():Array
        {
            return _declaredMethods.slice();
        }
        
        /**
         * @inheritDoc
         */
        public function get properties():Array
        {
            if (!_properties) {
                reflectProperties();
            }
            return _properties.slice();
        }
        
        /**
         * @inheritDoc
         */
        public function get methods():Array
        {
            if (!_methods) {
                reflectMethods();
            }
            return _methods.slice();
        }
        
        /**
         * コンストラクタの引数を追加します。
         * @param parameter 引数
         */
        public function addParameter(parameter:Parameter):void
        {
            _parameters.push(parameter);
        }
        
        /**
         * @inheritDoc
         */
        public function get parameters():Array
        {
            return _parameters.slice();
        }
        
        /**
         * @inheritDoc
         */
        public function isSubclassOf(type:Class):Boolean
        {
            return type == _nativeClass || _superClasses.indexOf(type) != -1;
        }
        
        /**
         * @inheritDoc
         */
        public function isImplements(type:Class):Boolean
        {
            return type == _nativeClass || _interfaces.indexOf(type) != -1;
        }
        
        /**
         * @inheritDoc
         */
        public function isAssignableFrom(type:Class):Boolean
        {
            if (type == _nativeClass) {
                return true;
            }
            
            var nc:Class = _nativeClass;
            
            if (_isInterface) {
                for each (var impl:Class in ASReflect.getType(type).interfaces) {
                    if (impl == nc) {
                        return true;
                    }
                }
            }
            else {
                try {
                    var typeName:String;
                    while (typeName = getQualifiedSuperclassName(type)) {
                        type = ASReflect.getClassFromName(typeName);
                        if (type == nc) {
                            return true;
                        }
                    }
                }
                catch (e:Error) {
                }
            }
            return false;
        }
        
        /**
         * @inheritDoc
         */
        public function isInstance(object:Object):Boolean
        {
            return object is _nativeClass;
        }
        
        /**
         * @inheritDoc
         */
        public function newInstance(parameters:Array):Object
        {
            switch (parameters.length) {
                case 0:
                    return new _nativeClass();
                case 1:
                    return new _nativeClass(parameters[0]);
                case 2:
                    return new _nativeClass(parameters[0], parameters[1]);
                case 3:
                    return new _nativeClass(parameters[0], parameters[1], parameters[2]);
                case 4:
                    return new _nativeClass(parameters[0], parameters[1], parameters[2],
                                            parameters[3]);
                case 5:
                    return new _nativeClass(parameters[0], parameters[1], parameters[2],
                                            parameters[3], parameters[4]);
                case 6:
                    return new _nativeClass(parameters[0], parameters[1], parameters[2],
                                            parameters[3], parameters[4], parameters[5]);
                case 7:
                    return new _nativeClass(parameters[0], parameters[1], parameters[2],
                                            parameters[3], parameters[4], parameters[5],
                                            parameters[6]);
                case 8:
                    return new _nativeClass(parameters[0], parameters[1], parameters[2],
                                            parameters[3], parameters[4], parameters[5],
                                            parameters[6], parameters[7]);
                case 9:
                    return new _nativeClass(parameters[0], parameters[1], parameters[2],
                                            parameters[3], parameters[4], parameters[5],
                                            parameters[6], parameters[7], parameters[8]);
                case 10:
                    return new _nativeClass(parameters[0], parameters[1], parameters[2],
                                            parameters[3], parameters[4], parameters[5],
                                            parameters[6], parameters[7], parameters[8],
                                            parameters[9]);
                case 11:
                    return new _nativeClass(parameters[0], parameters[1], parameters[2],
                                            parameters[3], parameters[4], parameters[5],
                                            parameters[6], parameters[7], parameters[8],
                                            parameters[9], parameters[10]);
                case 12:
                    return new _nativeClass(parameters[0], parameters[1], parameters[2],
                                            parameters[3], parameters[4], parameters[5],
                                            parameters[6], parameters[7], parameters[8],
                                            parameters[9], parameters[10], parameters[11]);
            }
            
            throw new ASReflectError('Too many parameters.');
        }
        
        /**
         * @inheritDoc
         */
        public function getDeclaredProperty(name:String):Property
        {
            if (!hasDeclaredProperty(name)) {
                throw new NotFoundError();
            }
            return _declaredPropertyMap[name];
        }
        
        /**
         * @inheritDoc
         */
        public function hasDeclaredProperty(name:String):Boolean
        {
            return _declaredPropertyMap[name] != null;
        }
        
        /**
         * @inheritDoc
         */
        public function getDeclaredMethod(name:String):Method
        {
            if (!hasDeclaredMethod(name)) {
                throw new NotFoundError();
            }
            return _declaredMethodMap[name];
        }
        
        /**
         * @inheritDoc
         */
        public function hasDeclaredMethod(name:String):Boolean
        {
            return _declaredMethodMap[name] != null;
        }
        
        /**
         * @inheritDoc
         */
        public function getProperty(name:String):Property
        {
            if (!_propertyMap) {
                reflectProperties();
            }
            
            var property:Property = _propertyMap[name];
            
            if (!property) {
                throw new NotFoundError();
            }
            
            return property;
        }
        
        /**
         * @inheritDoc
         */
        public function hasProperty(name:String):Boolean
        {
            if (!_propertyMap) {
                reflectProperties();
            }
            return _propertyMap[name] != null;
        }
        
        /**
         * @inheritDoc
         */
        public function getMethod(name:String):Method
        {
            if (!_methodMap) {
                reflectMethods();
            }
            
            var method:Method = _methodMap[name];
            
            if (!method) {
                throw new NotFoundError();
            }
            
            return method;
        }
        
        /**
         * @inheritDoc
         */
        public function hasMethod(name:String):Boolean
        {
            if (!_methodMap) {
                reflectMethods();
            }
            return _methodMap[name] != null;
        }
        
        private function reflectProperties():void
        {
            var properties:Array = declaredProperties;
            
            if (_superType) {
                var superProperties:Array = _superType.properties;
                var len:uint = superProperties.length;
                var offset:uint = properties.length;
                properties.length += len;
                for (var i:uint = 0; i < len; ++i) {
                    properties[offset + i] = superProperties[i];
                }
            }
            
            var propertyMap:Dictionary = new Dictionary();
            
            for each (var property:Property in properties) {
                propertyMap[property.name] = property;
            }
            
            _properties = properties;
						_properties.sortOn("name");
            _propertyMap = propertyMap;
        }
        
        private function reflectMethods():void
        {
            var methods:Array = declaredMethods;
            var methodMap:Dictionary = new Dictionary();
            
            for each (var method:Method in methods) {
                methodMap[method.name] = method;
            }
            
            if (_superType) {
                var superMethods:Array = _superType.methods;
                var superMethodsLen:uint = superMethods.length;
                var offset:uint = methods.length;
                var numAdded:uint = 0;
                methods.length += superMethodsLen;
                for (var i:uint = 0; i < superMethodsLen; ++i) {
                    var superMethod:Method = superMethods[i];
                    if (!methodMap[superMethod.name]) {
                        methods[offset + numAdded] = superMethod;
                        methodMap[superMethod.name] = superMethod;
                        ++numAdded;
                    }
                }
                if (numAdded < superMethodsLen) {
                    methods.length -= (superMethodsLen - numAdded);
                }
            }
            
            _methods = methods;
            _methodMap = methodMap;
        }
    }
}