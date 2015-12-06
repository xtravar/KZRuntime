//
//  ConvertingDynamicPropertyInfo.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 11/8/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//
#if SWIFT_INTROSPECTION
import KZTypeReflection
    
@objc(KZConvertingDynamicPropertyInfo)
public class ConvertingDynamicPropertyInfo : PropertyInfo {
    public let dynamicProperty: DynamicPropertyInfo
    
    internal init(runtime: KZRuntime, reflectedType: Any.Type, attributes: [Attribute], name: String, propertyType: Any.Type, dynamicProperty: DynamicPropertyInfo) {
        self.dynamicProperty = dynamicProperty
        
        super.init(runtime: runtime, reflectedType: reflectedType, attributes: attributes, name: name, propertyType: propertyType)
    }

    override public func get(target: AnyObject, returnValuePointer: UnsafeMutablePointer<Void>) {
        #if true
        let value = dynamicProperty.get(target)
        if value != nil {
            _ = Unmanaged<AnyObject>.passRetained(value!)
        }
        SwiftTypeRegistry.sharedRegistry.bridgeFromObjectiveC(self.propertyType, input: value, outputPointer: returnValuePointer)
        return
        #endif
        
        #if false
        var opaquePointer = COpaquePointer()
        super.get(target, returnValuePointer: &opaquePointer)
        if opaquePointer == nil {
            SwiftTypeRegistry.sharedRegistry.bridgeFromObjectiveC(self.propertyType, input: nil, outputPointer: returnValuePointer)
            return
        }
        let retval = Unmanaged<NSObject>.fromOpaque(opaquePointer).takeUnretainedValue()
        SwiftTypeRegistry.sharedRegistry.bridgeFromObjectiveC(self.propertyType, input: retval, outputPointer: returnValuePointer)
        #endif
    }
    
    override public func set(target: AnyObject, valuePointer: UnsafePointer<Void>) {
        let pointerPointer = UnsafeMutablePointer<UnsafeMutablePointer<Void>>(valuePointer)
        var value: AnyObject?
        if pointerPointer.memory == nil {
            value = nil
        } else {
            value = SwiftTypeRegistry.sharedRegistry.bridgeToObjectiveC(self.propertyType, inputPointer: valuePointer)
        }
        dynamicProperty.set(target, object: value)
    }
}

#endif
