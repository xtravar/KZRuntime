//
//  StructInfo_SwiftInvocation.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 11/8/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

#if SWIFT_INVOCATION
import SwiftFFI
    
extension StructInfo : _TypeInfo {
    static var typeMap : [OpaqueMetatype: FFIType] = {
        var retval = [
            OpaqueMetatype(Int.self) : FFIType.IntType,
            OpaqueMetatype(UInt.self) : FFIType.UIntType,
            
            OpaqueMetatype(Void.self) : FFIType.VoidType,
            
            OpaqueMetatype(Int8.self) : FFIType.Int8Type,
            OpaqueMetatype(UInt8.self) : FFIType.UInt8Type,
            
            OpaqueMetatype(Int16.self) : FFIType.Int16Type,
            OpaqueMetatype(UInt16.self) : FFIType.UInt16Type,
            
            OpaqueMetatype(Int32.self) : FFIType.Int32Type,
            OpaqueMetatype(UInt32.self) : FFIType.UInt32Type,
            
            OpaqueMetatype(Int64.self) : FFIType.Int64Type,
            OpaqueMetatype(UInt64.self) : FFIType.UInt64Type,
            
            OpaqueMetatype(Float.self) : FFIType.FloatType,
            OpaqueMetatype(Double.self) : FFIType.DoubleType,
            
            OpaqueMetatype(Bool.self) : FFIType.UInt8Type,
        ]
        
        return retval
    }()
    
    
    public func getStackType(var ignoreFloats: Bool) -> FFIType {
        let metatype = OpaqueMetatype(self.reflectedType)
        if let type = StructInfo.typeMap[metatype] {
            if ignoreFloats && type == FFIType.DoubleType {
                return FFIType.UInt64Type
            }
            return type
        }
        
        
        if self.fullName == "Swift.Array" {
            return FFIType.PointerType
        }
        
        if self.fullName == "Swift.Dictionary" {
            return FFIType.PointerType
        }
        
        // this doesn't hurt ARM, but it doesn't help either
        #if arch(i386) || arch(x86_64)
            if self.fullName == "Swift.Optional" {
                ignoreFloats = true
            }
        #endif
        
        let builder = FFIStructBuilder()
        if self.fields.count == 1 {
            return (self.runtime.registerType(fields[0].fieldType) as! _TypeInfo).getStackType(ignoreFloats)
        }
        for field in self.fields {
            let fieldStackType = (self.runtime.registerType(field.fieldType) as! _TypeInfo).getStackType(ignoreFloats)
            builder.addField(fieldStackType)
        }
        let retval: FFIType
        retval = builder.createType(self.size, align: self.alignment)
        // we can't cache types because they might be nested in sub-types... 
        //  need to differentiate top-level requests
        //StructInfo.typeMap[metatype] = retval
        return retval
    }
}
#endif

