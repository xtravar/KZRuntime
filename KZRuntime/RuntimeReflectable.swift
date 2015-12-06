//
//  RuntimeReflectable.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 11/8/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

@objc(KZRuntimeReflectable)
public protocol ObjCRuntimeReflectable : NSObjectProtocol {
    optional static var runtimeAttributes: [Attribute] { get }
    
    optional static func attributesForProperty(property: String) -> [Attribute]?
    optional static func attributesForField(field: String) -> [Attribute]?
    
    // only required for Objective-C code
    optional static func genericParametersForProperty(propertyName: String) -> [LazyTypeReference]?
    optional static func genericParametersForField(fieldName: String) -> [LazyTypeReference]?
}