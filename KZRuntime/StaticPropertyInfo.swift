//
//  StaticPropertyInfo.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 11/8/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

import Foundation
#if SWIFT_INTROSPECTION
import KZTypeReflection
#if SWIFT_INVOCATION
import SwiftFFI
#endif

@objc(KZStaticPropertyInfo)
public class StaticPropertyInfo : PropertyInfo {
    public let getter: UnsafePointer<Void>
    public let setter: UnsafePointer<Void>
    
    internal init(runtime: KZRuntime, attributes: [Attribute], reflectedType: Any.Type, name: String, propertyType: Any.Type, getter: UnsafePointer<Void>, setter: UnsafePointer<Void>) {
        
        self.getter = getter
        self.setter = setter
        
        super.init(runtime: runtime, reflectedType: reflectedType, attributes: attributes, name: name, propertyType: propertyType);
    }
    
    public override func get(target: AnyObject, returnValuePointer: UnsafeMutablePointer<Void>) {
#if SWIFT_INVOCATION
        let inv = FFIFunctionInvocation(address: self.getter)
        let returnType: FFIType
        let typeInfo = runtime.registerType(self.propertyType)
        returnType = (typeInfo as! _TypeInfo).stackType
        var atarget = target
        inv.addArg(&atarget, type: FFIType.PointerType)
        
        inv.invoke(returnValuePointer, returnType: returnType)
#else
        preconditionFailure("Cannot use native invocation when compiled without SWIFT_INVOCATION flag")
#endif
    }
    
    public override func set(target: AnyObject, valuePointer: UnsafePointer<Void>) {
#if SWIFT_INVOCATION
        let inv = FFIFunctionInvocation(address: self.setter)
        
        let typeInfo = self.runtime.registerType(self.propertyType)
        // can we fix this hack at the ABI level...? it tries to pass on the stack, when in reality we want it passed in re
        if typeInfo.stride > sizeof(Int.self) * 3 {
            var aValuePointer = valuePointer
            inv.addArg(&aValuePointer, type: FFIType.PointerType)
        } else {
            inv.addArg(UnsafeMutablePointer<Void>(valuePointer), type: (typeInfo as! _TypeInfo).stackType)
        }
    
        var aTarget = target;
        inv.addArg(&aTarget, type: FFIType.PointerType)
        var retval: Void
        inv.invoke(&retval, returnType: FFIType.VoidType)
#else
        preconditionFailure("Cannot use native invocation when compiled without SWIFT_INVOCATION flag")
#endif
    }
}

#endif

