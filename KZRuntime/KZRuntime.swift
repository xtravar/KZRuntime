//
//  KZRuntime.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 7/9/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

// Notes:
// ObjC Runtime
// * properties are only exported to Obj-C if the object is @objc or : NSObject
// * properties are only exported if their types are supported
// * unsupported types are: 
//      * nillable primitives (IMO, these should wrap to NSNumber)
//      * swift structs (why? C structs are fine)
// * The Any.Type of C structs is 'C.Name' - eg C.CGRect

import KZTypeReflection
#if SWIFT_INVOCATION
import SwiftFFI
#endif

public class KZRuntime : NSObject {
    public static var sharedRuntime = KZRuntime()
    
    public var typeInfos = [OpaqueMetatype : TypeInfo]()
    
    public var testArray = [Int]()

    public override init() {
#if !SWIFT_INTROSPECTION
    preconditionFailure("Runtime without SWIFT_INTROSPECTION flag not supported yet")
#endif
    }
    
    public func registerClass<T: AnyObject>(type: T.Type) -> ClassInfo {
        SwiftTypeRegistry.registerType(type)
        let metatype = OpaqueMetatype(type)
        return registerType(metatype) as! ClassInfo
    }
    
    public func registerEnum<T: RawRepresentable>(type: T.Type) -> Void {
        SwiftTypeRegistry.registerType(type)
    }
    
    
    public func registerType(type: Any.Type) -> TypeInfo {
        let metatype = OpaqueMetatype(type)
        
        return registerType(metatype)
    }
    
    private func registerType(metatype: OpaqueMetatype) -> TypeInfo {
        if let typeInfo = typeInfos[metatype] {
            return typeInfo
        }
        let type = metatype.type
        
        let metadata = swiftMetadataForType(type)
        
        var retval: TypeInfo
        
        if let clsMetadata = metadata as? SwiftClassMetadata {
            retval = ClassInfo(runtime: self, reflectedType: type, metadata: clsMetadata)
        } else if let objCClassMetadata = metadata as? SwiftObjCClassMetadata {
            retval = ClassInfo(runtime: self, reflectedType: type, metadata: objCClassMetadata)
        } else if let structMetadata = metadata as? SwiftStructMetadata {
            retval = StructInfo(runtime: self, type: type, metadata: structMetadata)
        } else if let enumMetadata = metadata as? SwiftEnumMetadata {
            return registerEnum(type, enumMetadata: enumMetadata)
        } else {
            preconditionFailure("cannot register type \(type)")
        }
        
        typeInfos[metatype] = retval
        return retval

    }
    
    private func registerEnum(type: Any.Type, enumMetadata: SwiftEnumMetadata) -> TypeInfo {
        if enumMetadata.mangledName == "Sq" || enumMetadata.mangledName == "SQ" {
            //let subType = registerType(enumMetadata.genericArguments[0])
            return StructInfo(runtime: self, type: type, enumMetadata: enumMetadata)
            /*
            if let structSubType = subType as? StructInfo {
                
                if structSubType.fullName == "Swift.Array" {
                    return subType
                }
                return StructInfo(runtime: self, type: type, enumMetadata: enumMetadata)
            } else {
                return subType
            }
            */
            
        } else {
            preconditionFailure()
        }
    }
}