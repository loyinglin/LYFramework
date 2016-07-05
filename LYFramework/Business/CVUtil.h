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



#pragma mark - get

- (UIImage *)getImageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef;

- (CVPixelBufferRef)getPixelBufferFromCGImage:(CGImageRef)image;


#pragma mark - message

@end
