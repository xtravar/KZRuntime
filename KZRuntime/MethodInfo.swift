//
//  KZMethodInfo.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 7/9/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

public struct MethodInfo {
    public let address: UnsafePointer<Void>
    public let name: String
    public let returnType: Any.Type
    public let parameters: [ParameterInfo]
}

public class DynamicMethodInfo {
    public let selector : Selector
    public let returnType : Any.Type
    public let parameters: [ParameterInfo]
    
    public init(selector: Selector, returnType: Any.Type, parameters: [ParameterInfo]) {
        self.selector = selector
        self.returnType = returnType
        self.parameters = parameters
    }
    
    //TODO: invoke
}

public struct ParameterInfo {
    public let name: String
    public let type: Any.Type
    public let position: Int
    public let isInOut: Bool
}

public extension MethodInfo {
    public func invoke<R: AnyObject, A0: AnyObject>(arg0: A0) -> R {
        typealias methodType = (@convention(c) (AnyObject) -> AnyObject)
        let fn = unsafeBitCast(self.address, methodType.self)
        return fn(arg0) as! R
    }
    
    public func invoke<R: AnyObject>(arg0: AnyClass) -> R {
        typealias methodType = (@convention(swift) (AnyClass) -> AnyObject)
        let fn = unsafeBitCast(self.address, methodType.self)
        return fn(arg0) as! R
    }
    
    public func invoke<A0: AnyObject>(arg0: A0) -> Void {
        typealias methodType = (@convention(c) (AnyObject) -> Void)
        let fn = unsafeBitCast(self.address, methodType.self)
        return fn(arg0)
    }
}