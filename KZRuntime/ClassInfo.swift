//
//  KZClassInfo.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 7/9/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

import KZTypeReflection
#if SWIFT_INVOCATION
import SwiftFFI
#endif

public protocol RuntimeCreatable {
    init()
}

@objc(KZClassInfo)
public class ClassInfo : TypeInfo {
    public let reflectedClass: AnyClass
    public let superClass: AnyClass!
    
    internal override init(
        runtime: KZRuntime,
        reflectedType: Any.Type,
        attributes: [Attribute],
        genericArguments: [Any.Type],
        name: String,
        fullName: String,
        mangledName: String,
        size: Int,
        alignment: Int,
        stride: Int,
        constructors: [MethodInfo],
        methods: [MethodInfo],
        fields: [FieldInfo],
        properties: [PropertyInfo]
        ) {
        self.reflectedClass = reflectedType as! AnyClass
        self.superClass = class_getSuperclass(reflectedClass)
    
            super.init(runtime: runtime, reflectedType: reflectedType, attributes: attributes, genericArguments: genericArguments, name: name, fullName: fullName, mangledName: mangledName, size: size, alignment: alignment, stride: stride, constructors: constructors, methods: methods, fields: fields, properties: properties)
        
    }
    
    public override func fieldNamed(name: String, lookToSuper: Bool = true) -> FieldInfo! {
        if let retval = super.fieldNamed(name, lookToSuper: false) {
            return retval
        }
        
        if !lookToSuper {
            return nil
        }
        
        return self.runtime.registerType(self.superClass).fieldNamed(name, lookToSuper: true)
    }
    
    public override func propertyNamed(name: String, lookToSuper: Bool = true) -> PropertyInfo! {

        if let retval = super.propertyNamed(name, lookToSuper: false) {
            return retval
        }
        
        if !lookToSuper {
            return nil
        }
        
        if self.superClass == NSObject.self {
            return nil
        }
        if self.superClass == nil {
            return nil
        }
        return self.runtime.registerType(self.superClass).propertyNamed(name, lookToSuper: true)
    }
}


public extension ClassInfo {
#if SWIFT_INVOCATION
    public func newInstance() -> AnyObject {
        if let nsobj = self.reflectedClass as? NSObject.Type {
            return nsobj.init()
        }
        
        guard let index = constructors.indexOf({ (mi: MethodInfo) -> Bool in
            mi.parameters.count == 0
        }) else {
            preconditionFailure("no empty constructor found")
        }
        
        let constructor = constructors[index];
        
        let invoker = FFIFunctionInvocation(address: constructor.address)
        var type: AnyClass = self.reflectedType as! AnyClass
        var retval: AnyObject? = nil
        invoker.addArg(&type, type: FFIType.PointerType)
        invoker.invoke(&retval, returnType: FFIType.PointerType)
        return retval!
    }
#else
    public func newInstance() -> AnyObject {
        if let type = self.reflectedClass as? RuntimeCreatable.Type {
            return type.init() as! AnyObject
        }
        
        if let type = self.reflectedClass as? NSObject.Type {
            return type.init()
        }
        
        preconditionFailure("Only NSObject subclasses are supported without SWIFT_INVOCATION compilation flag")
    }
#endif
}

