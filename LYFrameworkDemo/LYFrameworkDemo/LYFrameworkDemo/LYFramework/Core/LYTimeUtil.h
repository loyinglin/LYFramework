//
//  LYTimeUtil.h
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/5/23.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYTimeUtil : NSObject

+ (instancetype)instance;

- (double)getLYAbsoluteTimeIntervalSinceNow:(uint64_t)time;

- (uint64_t)getLYNowAbsoluteTime;

@end
