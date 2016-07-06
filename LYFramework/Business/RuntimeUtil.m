//
//  RuntimeUtil.m
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/7/6.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "RuntimeUtil.h"
#import <objc/runtime.h>

@implementation RuntimeUtil


#pragma mark - init

+ (instancetype)shareInstance {
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}


#pragma mark - update
- (void)swizzleInstanceMethodWithClass:(Class)className OriginSEL:(SEL)origin NewSEL:(SEL)newSEL
{
    Method origMethod = class_getInstanceMethod(className, origin);
    Method newMethod = class_getInstanceMethod(className, newSEL);
    if(class_addMethod(className, origin, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(className, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}


#pragma mark - get




#pragma mark - message

@end
