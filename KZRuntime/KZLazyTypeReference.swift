//
//  LazyMetatypeReference.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 11/3/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

import UIKit

@objc(KZLazyTypeReference)
/**
This is an Objective-C representation of a type.

If the type is primitive, typeEncoding is set with @encoding

If the type is a non-collection, classReference is set.

If the type is a collection, classReference and genericParameters are set.
*/

public class LazyTypeReference: NSObject {
    // struct, int, etc
    public var typeEncoding: [String]?
    
    // eg NSNumber, NSDictionary, NSSet
    public var classReference: AnyClass?
    // one of the following must be set, but not both
    public var genericParameters: [LazyTypeReference]?
    
}
