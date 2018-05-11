//
//  CVUtil.h
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/7/5.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface CVUtil : NSObject


#pragma mark - init
+ (instancetype)shareInstance;


#pragma mark - update

- (void)lyCompressVideo:(NSString *)path;


/**
 BGRA格式转成RGBA格式

 @param data    BGRA格式的二进制数据
 @param size    数据长度
 */
- (void)lyConvertBGRAtoRGBA:(unsigned char *)data withSize:(size_t)size;

#pragma mark - get

- (UIImage *)lyGetImageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef;

- (CVPixelBufferRef)lyGetPixelBufferFromCGImage:(CGImageRef)image;

- (CVPixelBufferRef)lyGetPixelBufferFaster:(CGImageRef)image;
#pragma mark - message

@end
