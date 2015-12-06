//
//  KZStructInfo.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 7/10/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

import UIKit
import KZTypeReflection
#if SWIFT_INVOCATION
import SwiftFFI
#endif

@objc(KZStructInfo)
public class StructInfo : TypeInfo {
}

public extension StructInfo {
    public func newInstance() -> UnsafePointer<Void> {
        
        /*
        guard let index = constructors.indexOf({ (mi: MethodInfo) -> Bool in
            mi.parameters.count == 0
        }) else {
            preconditionFailure()
        }
        
        let constructor = constructors[index];
        
        let invoker = FFIFunctionInvocation(address: constructor.address)
        var type: Any.Type = self.type
        var retval: AnyObject? = nil
        invoker.addArg(&type, type: FFIType.PointerType)
        invoker.invoke(&retval, returnType: FFIType.PointerType)
        return retval!*/
        return nil
    }
}


private class SwiftProperty {
    var name: String = ""
    var type: Any.Type = Any.self
    var getter: UnsafePointer<Void> = nil
    var setter: UnsafePointer<Void> = nil
    
}

internal extension StructInfo {
    // generate optional automatically
    convenience internal init(runtime: KZRuntime, type: Any.Type, enumMetadata metadata: SwiftEnumMetadata) {
        SwiftTypeRegistry.registerTypeOpaque(type)
        let name = metadata.name
        var nameParts = name.componentsSeparatedByString(".")
        nameParts.removeFirst()
        
        
        self.init(
            runtime: runtime,
            reflectedType: type,
            attributes: [],
            genericArguments: metadata.genericArguments,
            name: nameParts.joinWithSeparator("."),
            fullName: name,
            mangledName: metadata.mangledName,
            size: metadata.size,
            alignment: metadata.alignment,
            stride: metadata.stride,
            constructors: [],
            methods: [],
            fields: [
                FieldInfo(runtime: runtime, reflectedType: type, attributes: [], name: "Some", offset: 0, fieldType: metadata.genericArguments[0]),
                FieldInfo(runtime: runtime, reflectedType: type, attributes: [], name: "IsNull", offset: metadata.size - 1, fieldType: Bool.self)
            ],
            properties: [])
    }
    
    convenience internal init(runtime: KZRuntime, type: Any.Type, metadata: SwiftStructMetadata) {
        SwiftTypeRegistry.registerTypeOpaque(type)
        let name = metadata.name
        var nameParts = name.componentsSeparatedByString(".")
        nameParts.removeFirst()
        
        var constructors: [MethodInfo] = []
        //var methods: [MethodInfo] = []
        
        let swiftFields = metadata.fields
        
        var props = [String: SwiftProperty]()
        let swiftSymbols = metadata.symbols
        for symbol in swiftSymbols {
            let dec = SwiftSymbolDecoderUnsafe(input: symbol.name)
            guard let decodedSymbol = dec.scanSymbol() else {
                continue
            }
            
            switch(decodedSymbol) {
            case .Getter(instanceType: let instanceType, name: let propName, type: let propType):
                guard instanceType == type else {
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
                guard instanceType == type else {
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
                guard instanceType == type else {
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
        
        
        self.init(
            runtime: runtime,
            reflectedType: type,
            attributes: [],
            genericArguments: metadata.genericArguments,
            name: nameParts.joinWithSeparator("."),
            fullName: name,
            mangledName: metadata.mangledName,
            size: metadata.size,
            alignment: metadata.alignment,
            stride: metadata.stride,
            constructors: [],
            methods: [],
            fields: swiftFields.map{ return FieldInfo(runtime: runtime, reflectedType: type, attributes: [], name: $0.name, offset: $0.offset, fieldType: $0.type) },
            properties: [])
        
    }
}