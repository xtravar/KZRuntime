//
//  ClassInfo_Initialization.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 11/8/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

import KZTypeReflection

private class SwiftProperty {
    var name: String = ""
    var type: Any.Type = Any.self
    var getter: UnsafePointer<Void> = nil
    var setter: UnsafePointer<Void> = nil
    
    var objCProperty: ObjCProperty?
}

internal extension ClassInfo {
    internal convenience init(runtime: KZRuntime, reflectedType: Any.Type, metadata: SwiftObjCClassMetadata) {
        SwiftTypeRegistry.registerTypeOpaque(reflectedType)
        let name = NSStringFromClass(metadata.type)
        
        if reflectedType is NSValue.Type {
            self.init(runtime: runtime, reflectedType: reflectedType, attributes: [], genericArguments: [], name: name, fullName: name, mangledName: name, size: metadata.size, alignment: metadata.alignment, stride: metadata.stride, constructors: [], methods: [], fields: [], properties: [])
            return
        }
        
        let objcClass = ObjCClass(type: reflectedType as! AnyClass)
        let fields = objcClass.fields.map {FieldInfo(runtime: runtime, reflectedType: reflectedType, attributes: [], name: $0.name, offset: $0.offset, fieldType: $0.type!)}
        let props = objcClass.properties.map {DynamicPropertyInfo(runtime: runtime, attributes: [], reflectedType: reflectedType, name: $0.name, propertyType: $0.propertyType, getter: $0.getter, setter: $0.setter)}
        
        self.init(runtime: runtime, reflectedType: reflectedType, attributes: [], genericArguments: [], name: name, fullName: name, mangledName: name, size: metadata.size, alignment: metadata.alignment, stride: metadata.stride, constructors: [], methods: [], fields: fields, properties: props)
        
        
    }
    
    internal convenience init(runtime: KZRuntime, reflectedType: Any.Type, metadata: SwiftClassMetadata) {
        SwiftTypeRegistry.registerTypeOpaque(reflectedType)
        let name = metadata.name
        var nameParts = name.componentsSeparatedByString(".")
        nameParts.removeFirst()
        
        var constructors: [MethodInfo] = []
        let methods: [MethodInfo] = []
        
        let swiftFields = metadata.fields
        
        var props = [String: SwiftProperty]()
        let swiftSymbols = metadata.symbols
        for symbol in swiftSymbols {
            if !symbol.name.hasPrefix("_TF") {
                continue
            }
            let dec = SwiftSymbolDecoderUnsafe(input: symbol.name)
            
            guard let decodedSymbol = dec.scanSymbol() else {
                continue
            }
            
            switch(decodedSymbol) {
            case .Getter(instanceType: let instanceType, name: let propName, type: let propType):
                guard instanceType == reflectedType else {
                    continue
                }
                if propName.containsString(" ") {
                    // this is a field :|
                    continue
                }
                if let prop = props[propName] {
                    prop.getter = symbol.value
                } else {
                    let prop = SwiftProperty()
                    prop.name = propName
                    prop.getter = symbol.value
                    prop.type = propType
                    props[propName] = prop
                }
                break
                
            case .Setter(instanceType: let instanceType, name: let propName, type: let propType):
                guard instanceType == reflectedType else {
                    continue
                }
                if propName.containsString(" ") {
                    // this is a field :|
                    continue
                }
                
                if let prop = props[propName] {
                    prop.setter = symbol.value
                } else {
                    let prop = SwiftProperty()
                    prop.name = propName
                    prop.setter = symbol.value
                    prop.type = propType
                    props[propName] = prop
                }
                break
                
            case .AllocatingConstructor(instanceType: let instanceType, parameters: let params):
                guard instanceType == reflectedType else {
                    continue
                }
                
                var c = 0
                let mi = MethodInfo(
                    address: symbol.value,
                    name: "init",
                    returnType: instanceType,
                    parameters: params.map { ParameterInfo(name: $0.name, type: $0.type, position: c++, isInOut: false) }
                )
                
                constructors.append(mi)
                break
                
            default:
                break
            }
        }
        
#if SWIFT_INVOCATION
    let properties: [PropertyInfo] = props.values.map {
    return StaticPropertyInfo(
        runtime: runtime,
        attributes: [],
        reflectedType: reflectedType,
        name: $0.name,
        propertyType: $0.type,
        getter: $0.getter,
        setter: $0.setter)
    }
#else
    let objcClass = ObjCClass(type: reflectedType as! AnyClass)
    objcClass.properties.forEach {
        var name = $0.name
        if name.hasSuffix("_runtime") {
            name = String(name.characters.dropLast(8))
        }
        if let prop = props[name] {
            prop.objCProperty = $0
        } else {
            preconditionFailure()
        }
    }
    
    let properties: [PropertyInfo] = props.values.map {
        if let objcProp = $0.objCProperty {
            let ocType = objcProp.propertyType
            var swiftType = $0.type
            
            // o_o
            if swiftType == Int.self {
                swiftType = sizeof(Int.self) == 8 ? Int64.self : Int32.self
            } else if swiftType == UInt.self {
                swiftType = sizeof(UInt.self) == 8 ? UInt64.self : UInt32.self
            }
            
            //print("\(ocType) and \(swiftType)")
            let dynamicProperty = DynamicPropertyInfo(
                runtime: runtime,
                attributes: [],
                reflectedType: reflectedType,
                name: $0.name,
                propertyType: ocType,
                getter: objcProp.getter,
                setter: objcProp.setter)
            
            if ocType == swiftType {
                return dynamicProperty
            }
            
            if let _ = ocType as? AnyClass {
                // print("Pairing property types \(ocType) and \(swiftType)")
                return ConvertingDynamicPropertyInfo(
                    runtime: runtime,
                    reflectedType: reflectedType,
                    attributes: [],
                    name: $0.name,
                    propertyType: $0.type,
                    dynamicProperty:dynamicProperty)
            } else if let enumType = swiftMetadataForType(swiftType) as? SwiftEnumMetadata {
                //TODO: check to make sure enum type is raw representable
                //let fields = enumType.fields
                return ConvertingDynamicPropertyInfo(
                    runtime: runtime,
                    reflectedType: reflectedType,
                    attributes: [],
                    name: $0.name,
                    propertyType: $0.type,
                    dynamicProperty:dynamicProperty)
            } else {
                preconditionFailure("Mismatch between \(ocType) and \(swiftType)")
            }
            
            
        } else {
            return StaticPropertyInfo(
                runtime: runtime,
                attributes: [],
                reflectedType: reflectedType,
                name: $0.name,
                propertyType: $0.type,
                getter: $0.getter,
                setter: $0.setter)
        }
    }
    
    
#endif
        self.init(
            runtime: runtime,
            reflectedType: reflectedType,
            attributes: [],
            genericArguments: metadata.genericArguments,
            name: nameParts.joinWithSeparator("."),
            fullName: name,
            mangledName: metadata.mangledName,
            size: metadata.size,
            alignment: metadata.alignment,
            stride: metadata.stride,
            constructors: constructors,
            methods: methods,
            fields: swiftFields.map{ return FieldInfo(runtime: runtime, reflectedType: reflectedType, attributes: [], name: $0.name, offset: $0.offset, fieldType: $0.type) },
            properties: properties
        )
        
    }
}
