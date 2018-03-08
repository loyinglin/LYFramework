//
//  KSCircleBuffer.h
//  LYFrameworkDemo
//
//  Created by loyinglin on 2018/3/8.
//  Copyright © 2018年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSCircleBuffer : NSObject

- (instancetype)initWithBufferSize:(uint32_t)size;

- (uint32_t)writeWithBuffer:(char *)buffer size:(uint32_t)size;

- (uint32_t)readWithBuffer:(char *)buffer size:(uint32_t)size;

//- (uint32_t)justOutputWithBuffer:(char *)buffer size:(uint32_t)size;

- (uint32_t)getLeftSize;

- (uint32_t)getReadySize;

@end
