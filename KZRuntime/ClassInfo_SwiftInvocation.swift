//
//  ClassInfo_Unsafe.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 11/8/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

#if SWIFT_INVOCATION
import SwiftFFI
    
extension ClassInfo : _TypeInfo {
    internal func getStackType(ignoreFloats: Bool) -> FFIType {
        return FFIType.PointerType
    }
}

#endif


