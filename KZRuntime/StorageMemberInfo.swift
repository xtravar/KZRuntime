//
//  StorageMemberInfo.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 11/4/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

import UIKit

@objc(KZStorageMemberInfo)
public class StorageMemberInfo: RuntimeObject {
    public let name: String
    public let storageType: Any.Type
    
    internal init(
        runtime: KZRuntime,
        reflectedType: Any.Type,
        attributes: [Attribute],
        name: String,
        storageType: Any.Type) {
        self.name = name
        self.storageType = storageType
            super.init(runtime: runtime, reflectedType: reflectedType, attributes: attributes)
    }
    
    public func get(target: AnyObject, returnValuePointer: UnsafeMutablePointer<Void>) {
        preconditionFailure("method not implemented")
    }
    
    public func set(target: AnyObject, valuePointer: UnsafePointer<Void>) {
        preconditionFailure("method not implemented")
    }
    
    @objc(getFromStruct:returnValuePointer:)
    public func get(target: UnsafePointer<Void>, returnValuePointer: UnsafeMutablePointer<Void>) {
        preconditionFailure("method not implemented")
    }
    
    
    @objc(setInStruct:valuePointer:)
    public func set(target: UnsafeMutablePointer<Void>, valuePointer: UnsafePointer<Void>) {
        preconditionFailure("method not implemented")
    }
}


extension StorageMemberInfo {
    public func get<V>(target: AnyObject) -> V {
        let sizeofV = sizeof(V.self)
        let sizeofInt = sizeof(Int.self)
        
        let wordCount = sizeofV / sizeofInt + (sizeofV % sizeofInt != 0 ? 1 : 0)
        
        let retPointer = UnsafeMutablePointer<V>(calloc(wordCount, sizeofInt))
        
        self.get(target, returnValuePointer: retPointer)
        
        let retval: V = retPointer.memory
        free(retPointer)
        
        return retval
    }
    
    public func set<V>(target: AnyObject, var value: V) {
        self.set(target, valuePointer: &value)
    }
    
    
    public func get<V>(target: UnsafePointer<Void>) -> V {
        let sizeofV = strideof(V.self)
        
        let retPointer = UnsafeMutablePointer<V>(calloc(sizeofV, 1))
        
        self.get(target, returnValuePointer: retPointer)
        
        let retval: V = retPointer.memory
        free(retPointer)
        
        return retval
    }
    
    public func set<V>(target: UnsafeMutablePointer<Void>, var value: V) {
        self.set(target, valuePointer: &value)
    }
}