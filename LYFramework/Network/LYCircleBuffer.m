//
//  KSCircleBuffer.m
//  QQKSong
//
//  Created by loyinglin on 2018/1/29.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "LYCircleBuffer.h"


@interface LYCircleBuffer ()

@property (nonatomic, assign) uint32_t mReadPosition;  // 指向当前未读的内存
@property (nonatomic, assign) uint32_t mWritePosition; // 指向当前未写的内存
@property (nonatomic, assign) uint32_t mBufferSize;

@property (nonatomic, assign) char *mCircleBuffer;

@property (nonatomic, strong) NSRecursiveLock *mLock;

@end

#define defaultSize  (4096 + 1)
#define min(a, b) ((a) < (b) ? (a) : (b))

@implementation LYCircleBuffer

- (instancetype)initWithBufferSize:(uint32_t)size {
    if (self = [super init]) {
        self.mCircleBuffer = malloc(size);
        bzero(self.mCircleBuffer, size);
        self.mReadPosition = self.mWritePosition = 0;
        self.mBufferSize = size + 1; // +1 是因为self.mReadPosition = self.mWritePosition的时候，无法区分为空还是满的，故而+1，并且定义这种行为是为空
        if (self.mBufferSize <= 0) {
            self.mBufferSize = defaultSize; //
            NSAssert(size > 0, @"size empty");
        }
        self.mLock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (uint32_t)writeWithBuffer:(char *)buffer size:(uint32_t)size {
    [self.mLock lock];
    uint32_t validSize = min(size, [self getLeftSize]);
    if (validSize) {
        for (int i = 0; i < validSize; ++i) {
            self.mCircleBuffer[self.mWritePosition] = buffer[i];
            self.mWritePosition = (self.mWritePosition + 1) % self.mBufferSize;
        }
    }
    [self.mLock unlock];
    return validSize;
}

- (uint32_t)readWithBuffer:(char *)buffer size:(uint32_t)size {
    [self.mLock lock];
    uint32_t validSize = min(size, [self getReadySize]);
    if (validSize) {
        for (int i = 0; i < validSize; ++i) {
            buffer[i] = self.mCircleBuffer[self.mReadPosition];
            self.mReadPosition = (self.mReadPosition + 1) % self.mBufferSize;
        }
    }
    [self.mLock unlock];
    return validSize;
}

- (uint32_t)justOutputWithBuffer:(char *)buffer size:(uint32_t)size {
    [self.mLock lock];
    uint32_t validSize = min(size, [self getReadySize]);
    uint32_t temPos = self.mReadPosition;
    if (validSize) {
        for (int i = 0; i < validSize; ++i) {
            buffer[i] = self.mCircleBuffer[temPos];
            temPos = (temPos + 1) % self.mBufferSize;
        }
    }
    [self.mLock unlock];
    return validSize;
}


- (uint32_t)getReadySize {
    [self.mLock lock];
    int size = ((int)self.mWritePosition - self.mReadPosition + self.mBufferSize) % self.mBufferSize;
    
    [self.mLock unlock];
    return size;
}

- (uint32_t)getLeftSize {
    uint32_t size;
    [self.mLock lock];
    size = self.mBufferSize - 1 - [self getReadySize];;
    [self.mLock unlock];
    return size;
}

- (void)dealloc {
    if (self.mCircleBuffer) {
        free(self.mCircleBuffer);
    }
}

@end
