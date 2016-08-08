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

- (void)lyConvertBGRAtoRGBA:(unsigned char *)data withSize:(size_t)sizeOfData;

#pragma mark - get

- (UIImage *)lyGetImageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef;

- (CVPixelBufferRef)lyGetPixelBufferFromCGImage:(CGImageRef)image;

- (CVPixelBufferRef)lyGetPixelBufferFaster:(CGImageRef)image;
#pragma mark - message

@end
