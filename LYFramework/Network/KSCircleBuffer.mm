//
//  KSCircleBuffer.m
//  LYFrameworkDemo
//
//  Created by loyinglin on 2018/3/8.
//  Copyright © 2018年 林伟池. All rights reserved.
//

#import <deque>
#import <algorithm>
#import "KSCircleBuffer.h"
using namespace std;

@interface KSCircleBuffer ()

@property (nonatomic, strong) NSRecursiveLock *mLock;
@property (nonatomic, assign) uint32_t mBufferSize;

@end

#define defaultSize  (4096 + 1)
#define min(a, b) ((a) < (b) ? (a) : (b))

@implementation KSCircleBuffer
{
    deque<char>  queue;
}

- (instancetype)initWithBufferSize:(uint32_t)size {
    if (self = [super init]) {
        self.mLock = [[NSRecursiveLock alloc] init];
        self.mBufferSize = size;
    }
    return self;
}

- (uint32_t)writeWithBuffer:(char *)buffer size:(uint32_t)size {
    [self.mLock lock];
    uint32_t ret = 0;
    ret = min(size, self.mBufferSize - (uint32_t)queue.size());
    for (int i = 0; i < ret; ++i) {
        queue.push_front(buffer[i]);
    }
    [self.mLock unlock];
    return ret;
}

- (uint32_t)readWithBuffer:(char *)buffer size:(uint32_t)size {
    [self.mLock lock];
    uint32_t ret = 0;
    ret = min(size, (uint32_t)queue.size());
    for (int i = 0; i < ret; ++i) {
        buffer[i] = queue.back();
        queue.pop_back();
    }
    [self.mLock unlock];
    return ret;
}

- (uint32_t)getReadySize {
    [self.mLock lock];
    uint32_t size = (uint32_t)queue.size();
    [self.mLock unlock];
    return size;
}

- (uint32_t)getLeftSize {
    uint32_t size;
    [self.mLock lock];
    size = self.mBufferSize - [self getReadySize];
    [self.mLock unlock];
    return size;
}

- (void)dealloc {
}

@end
