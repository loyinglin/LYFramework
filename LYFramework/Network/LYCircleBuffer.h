//
//  KSCircleBuffer.h
//  QQKSong
//
//  Created by loyinglin on 2018/1/29.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYCircleBuffer : NSObject

- (instancetype)initWithBufferSize:(uint32_t)size;

- (uint32_t)writeWithBuffer:(char *)buffer size:(uint32_t)size;

- (uint32_t)readWithBuffer:(char *)buffer size:(uint32_t)size;

- (uint32_t)justOutputWithBuffer:(char *)buffer size:(uint32_t)size;

- (uint32_t)getLeftSize;

- (uint32_t)getReadySize;

@end
