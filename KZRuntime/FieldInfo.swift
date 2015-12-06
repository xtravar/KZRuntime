//
//  KZVariableInfo.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 7/9/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

import UIKit
import KZTypeReflection

@objc(KZFieldInfo)
public class FieldInfo : StorageMemberInfo {
    public var fieldType: Any.Type { return self.storageType }
    
    public let offset: Int

    internal init(runtime: KZRuntime, reflectedType: Any.Type, attributes: [Attribute], name: String, offset: Int, fieldType: Any.Type) {
        self.offset = offset
        super.init(runtime: runtime, reflectedType: reflectedType, attributes: attributes, name: name, storageType: fieldType)
    }
    
    public override func get(target: AnyObject, returnValuePointer: UnsafeMutablePointer<Void>) {
        self.get(unsafeAddressOf(target), returnValuePointer: returnValuePointer)
    }
    
    public override func set(target: AnyObject, valuePointer: UnsafePointer<Void>) {
        self.set(UnsafeMutablePointer<Void>(unsafeAddressOf(target)), valuePointer: valuePointer)
    }
    
    public override func get(target: UnsafePointer<Void>, returnValuePointer: UnsafeMutablePointer<Void>) {
        let typeInfo = self.runtime.registerType(self.fieldType)
        let fieldOffset = UnsafeMutablePointer<Int8>(target).advancedBy(self.offset)
        memcpy(returnValuePointer, fieldOffset, typeInfo.stride)
    }
    
    public override func set(target: UnsafeMutablePointer<Void>, valuePointer: UnsafePointer<Void>) {
        let typeInfo = self.runtime.registerType(self.fieldType)
        let fieldOffset = UnsafeMutablePointer<Int8>(target).advancedBy(self.offset)
        memcpy(fieldOffset, valuePointer, typeInfo.stride)
    }
}


