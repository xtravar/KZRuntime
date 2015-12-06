//
//  KZPropertyInfo.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 7/9/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//
import Foundation

@objc(KZPropertyInfo)
public class PropertyInfo : StorageMemberInfo {
    public var propertyType: Any.Type { return super.storageType }
    
    internal init(runtime: KZRuntime, reflectedType: Any.Type, attributes: [Attribute], name: String, propertyType: Any.Type) {
        super.init(runtime: runtime,
            reflectedType: reflectedType,
            attributes: attributes,
            name: name,
            storageType: propertyType)
    }
}
