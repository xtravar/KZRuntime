//
//  KZAttributableObject.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 7/9/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//


@objc(KZRuntimeObject)
public class RuntimeObject: NSObject {
    public let runtime: KZRuntime
    public let reflectedType: Any.Type
    public let attributes: [Attribute]
    
    internal let attributesByType: [String: Attribute]
    
    internal init(runtime: KZRuntime, reflectedType: Any.Type, attributes: [Attribute]) {
        self.runtime = runtime
        self.reflectedType = reflectedType
        self.attributes = attributes
        self.attributesByType = attributes.toDictionary { NSStringFromClass($0.dynamicType) }
        
        super.init()
        attributes.forEach { $0.didApplyToObject(self) }
    }
}


