//
//  TypeInfo_SwiftInvocation.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 11/8/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

#if SWIFT_INVOCATION
import SwiftFFI
    
internal protocol _TypeInfo {
    func getStackType(var ignoreFloats: Bool) -> FFIType
}

internal extension _TypeInfo {
    var stackType: FFIType { return getStackType(false) }
}
#endif
