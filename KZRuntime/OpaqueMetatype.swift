//
//  OpaqueMetatype.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 10/29/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

import Foundation

public struct OpaqueMetatype : Equatable, Hashable, CustomStringConvertible, CustomDebugStringConvertible {
    public let type: Any.Type
    
    public init(_ type: Any.Type) {
        self.type = type
    }
    
    public init(pointer: UnsafePointer<Void>) {
        self.type = unsafeBitCast(pointer, Any.Type.self)
    }
    
    public var pointerValue: UnsafePointer<Void> {
        return unsafeBitCast(type, UnsafePointer<Void>.self)
    }
    
    public var hashValue: Int {
        return self.pointerValue.hashValue
    }
    
    public var description: String {
        var retval = String()
        _stdlib_getDemangledMetatypeNameImpl(self.type, qualified: true, &retval)
        return retval
    }
    
    public var debugDescription: String {
        return self.description
    }
    
    public func debugQuickLookObject() -> AnyObject? {
        return self.debugDescription
    }
}


public func ==(lhs: OpaqueMetatype, rhs: OpaqueMetatype) -> Bool {
    return lhs.type == rhs.type
}


extension OpaqueMetatype : _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = NSValue

    public static func _isBridgedToObjectiveC () -> Bool {
        return  true
    }

    public static func _getObjectiveCType () -> Any.Type {
        return  _ObjectiveCType.self
    }

    public func _bridgeToObjectiveC() -> _ObjectiveCType {
        return NSValue(pointer: self.pointerValue)
    }

    public static func _forceBridgeFromObjectiveC(source: _ObjectiveCType, inout result: OpaqueMetatype?) {
        result = OpaqueMetatype(pointer: source.pointerValue)
    }

    public static func _conditionallyBridgeFromObjectiveC (source: _ObjectiveCType, inout result: OpaqueMetatype?) -> Bool {
        _forceBridgeFromObjectiveC (source, result: &result)
        return  true
    }
}
