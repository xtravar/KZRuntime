//
//  TypeInfo.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 11/3/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

import KZTypeReflection

@objc(KZTypeInfo)
public class TypeInfo: RuntimeObject {
    public var genericArguments: [Any.Type]
    
    public let name: String
    public let fullName: String
    public let mangledName: String
    
    public let size: Int
    public let alignment: Int
    public let stride: Int
    
    public let constructors: [MethodInfo]
    public let methods: [MethodInfo]
    public let fields: [FieldInfo]
    public let properties: [PropertyInfo]
    
    
    private let constructorsByName: [String: MethodInfo]
    private let methodsByName: [String: MethodInfo]
    private let fieldsByName: [String: FieldInfo]
    private let propertiesByName: [String: PropertyInfo]
    
    public var isOptional: Bool { return self.mangledName == "SQ" || self.mangledName == "Sq" }
    
    internal init(
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
            self.genericArguments = genericArguments
        self.name = name
        self.fullName = fullName
        self.mangledName = mangledName
            
        self.size = size
        self.alignment = alignment
        self.stride = stride
            
        self.constructors = constructors
        self.methods = methods
        self.fields = fields
        self.properties = properties
            
        self.constructorsByName = constructors.toDictionary { $0.name }
        self.methodsByName = methods.toDictionary{ $0.name }
        self.fieldsByName = fields.toDictionary{ $0.name }
        self.propertiesByName = properties.toDictionary{ $0.name }
            
        super.init(runtime: runtime, reflectedType: reflectedType, attributes: attributes)
    }
    
    public func fieldNamed(name: String, lookToSuper: Bool = true) -> FieldInfo! {
        return self.fieldsByName[name]
    }
    
    public func propertyNamed(name: String, lookToSuper: Bool = true) -> PropertyInfo! {
        return self.propertiesByName[name]
    }
}

