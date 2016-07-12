//
//  UIImage+LYUtil.m
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/7/12.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "UIImage+LYUtil.h"

@implementation UIImage (LYUtil)


- (UIImage *)lyChangeSizeWithMaxSize:(CGSize)maxSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize targetSize = sourceImage.size;
    if (maxSize.height <= 0 || maxSize.width <= 0) {
        return nil;
    }
    while (targetSize.width > maxSize.width || targetSize.height > maxSize.width) {
        targetSize.width = targetSize.width / 1.1;
        targetSize.height = targetSize.height / 1.1;
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    [sourceImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) {
        newImage = sourceImage;
        NSLog(@"LY could not scale image. Check size");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
