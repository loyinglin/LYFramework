//
//  TimeUtil.h
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/7/6.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MeasureBlock)(void);

@interface TimeUtil : NSObject

#pragma mark - init
+ (instancetype)shareInstance;


#pragma mark - update



#pragma mark - get

- (double)getBlockExecuteTime:(MeasureBlock)block;



#pragma mark - message

@end
