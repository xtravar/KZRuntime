//
//  DynamicPropertyInfo.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 10/30/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

import Foundation

@objc(KZDynamicPropertyInfo)
public class DynamicPropertyInfo : PropertyInfo {
    public let getter: Selector!
    public let setter: Selector!
    
    private var getSignature: AnyObject!
    private var setSignature: AnyObject!
    
    //TODO: use direct implementations everywhere
    typealias CSetterImp = (@convention(c) (AnyObject, Selector, NSDecimal)->Void)
    typealias CGetterImp = (@convention(c) (AnyObject, Selector)->NSDecimal)
    
    internal init(runtime: KZRuntime, attributes: [Attribute], reflectedType: Any.Type, name: String, propertyType: Any.Type, getter: Selector!, setter: Selector?) {
        self.getter = getter
        self.setter = setter
        
        super.init(runtime: runtime, reflectedType: reflectedType, attributes: attributes, name: name, propertyType: propertyType);
    }
    
    override public func get(target: AnyObject, returnValuePointer: UnsafeMutablePointer<Void>) {
        if self.storageType == NSDecimal.self {
            let meth = class_getInstanceMethod(target.dynamicType, self.getter);
            let f = unsafeBitCast(method_getImplementation(meth), CGetterImp.self)
            let decimal = UnsafeMutablePointer<NSDecimal>(returnValuePointer)
            decimal.memory = f(target, self.setter)
            return;
        }
        
        if getSignature == nil {
            getSignature = KZGetMethodSignature(target, getter)
        }
        KZInvokeGetterStruct(target, getter, getSignature, returnValuePointer)
    }
    
    override public func set(target: AnyObject, valuePointer: UnsafePointer<Void>) {
        if self.storageType == NSDecimal.self {
            let meth = class_getInstanceMethod(target.dynamicType, self.setter);
            let f = unsafeBitCast(method_getImplementation(meth), CSetterImp.self)
            let decimal = UnsafePointer<NSDecimal>(valuePointer)
            f(target, self.setter, decimal.memory)
            return;
        }
        
        if setSignature == nil {
            setSignature = KZGetMethodSignature(target, setter);
        }
        KZInvokeSetterStruct(target, setter, setSignature, UnsafeMutablePointer<Void>(valuePointer))
    }

    public func get(target: AnyObject) -> AnyObject? {
        return KZInvokeGetter(target, self.getter)
    }
    
    public func set(target: AnyObject, object: AnyObject?) {
        KZInvokeSetter(target, self.setter, object)
    }
}