//
//  RuntimeUtil.h
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/7/6.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeUtil : NSObject


#pragma mark - init
+ (instancetype)shareInstance;

#pragma mark - update

/**
 * abc
 * @code
 * + (void)load {
 *      [[RuntimeUtil shareInstance] swizzleInstanceMethodWithClass:[self class] OriginSEL:@selector(selector) NewSEL:@selector(selectorNew)];
 * }
 * @endcode
 */
- (void)swizzleInstanceMethodWithClass:(Class)className OriginSEL:(SEL)origin NewSEL:(SEL)newSEL;

#pragma mark - get




#pragma mark - message

@end
