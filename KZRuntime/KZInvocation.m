//
//  KZInvocation.m
//  KZRuntime
//
//  Created by Mike Kasianowicz on 7/31/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

#import "KZInvocation.h"

__nullable id KZInvokeGetter(id target, SEL selector) {
    //TODO: objc_msgSend faster?
    static NSMethodSignature *signature;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        signature = [target methodSignatureForSelector:selector];
    });
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:signature];
    inv.target = target;
    inv.selector = selector;
    [inv invoke];
    
    id retval = nil;
    [inv getReturnValue:&retval];
    return retval;
}

void KZInvokeSetter(id target, SEL selector, __nullable id value) {
    //TODO: objc_msgSend faster?
    static NSMethodSignature *signature;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        signature = [target methodSignatureForSelector:selector];
    });
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:signature];
    inv.target = target;
    inv.selector = selector;
    [inv setArgument:&value atIndex:2];
    [inv invoke];
}

id KZGetMethodSignature(id target, SEL selector) {
    return [target methodSignatureForSelector:selector];
}


void KZInvokeGetterStruct(id target, SEL selector, id methodSignature, void *value) {
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:methodSignature];
    inv.target = target;
    inv.selector = selector;
    [inv invoke];
    [inv getReturnValue:value];
}

void KZInvokeSetterStruct(id target, SEL selector, id methodSignature, void *value) {
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:methodSignature];
    inv.target = target;
    inv.selector = selector;
    [inv setArgument:value atIndex:2];
    [inv invoke];
}
