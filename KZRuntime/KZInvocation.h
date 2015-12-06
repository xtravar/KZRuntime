//
//  KZInvocation.h
//  KZRuntime
//
//  Created by Mike Kasianowicz on 7/31/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
__nullable id KZInvokeGetter(id target, SEL selector);
void KZInvokeSetter(id target, SEL selector, __nullable id value);

id KZGetMethodSignature(id target, SEL selector);

void KZInvokeGetterStruct(id target, SEL selector, id methodSignature, void *value);
void KZInvokeSetterStruct(id target, SEL selector, id methodSignature, void *value);
NS_ASSUME_NONNULL_END
