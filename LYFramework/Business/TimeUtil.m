//
//  TimeUtil.m
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/7/6.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "TimeUtil.h"
#import <mach/mach_time.h>

@implementation TimeUtil


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



#pragma mark - get

- (double)getBlockExecuteTime:(MeasureBlock)block {
    double ret = 0.0;
    if (block) {
        uint64_t start = mach_absolute_time();
        block();
        uint64_t end = mach_absolute_time();
        
        mach_timebase_info_data_t timebaseInfo;
        (void) mach_timebase_info(&timebaseInfo);
        uint64_t elapsedNano = (end - start) * timebaseInfo.numer / timebaseInfo.denom;
        ret = (double)elapsedNano / 1000000000.0;
    }
    
    return ret;
}



#pragma mark - message

@end
