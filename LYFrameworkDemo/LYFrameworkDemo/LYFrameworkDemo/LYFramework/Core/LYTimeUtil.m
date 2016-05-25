//
//  LYTimeUtil.m
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/5/23.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "LYTimeUtil.h"
#import <mach/mach_time.h>

@implementation LYTimeUtil


+ (instancetype)instance {
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}

- (double)getLYAbsoluteTimeIntervalSinceNow:(uint64_t)time {
    uint64_t end = mach_absolute_time();
    mach_timebase_info_data_t timebaseInfo;
    (void) mach_timebase_info(&timebaseInfo);
    uint64_t elapsedNano = (end - time) * timebaseInfo.numer / timebaseInfo.denom;
    double elapsedSeconds = (double)elapsedNano / 1000000000.0;
    return elapsedSeconds;
}

- (uint64_t)getLYAbsoluteNowTime {
    return mach_absolute_time();
}

@end
