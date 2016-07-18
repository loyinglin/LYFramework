//
//  UIView+LYSnapshot.m
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/7/14.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "UIView+LYSnapshot.h"

@implementation UIView (LYSnapshot)

- (UIImage*)lySnapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    // Render our snapshot into the image context
//    BOOL flag = [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//    if (!flag) {
//        NSLog(@" the snapshot is missing image data for any view in the hierarchy.");
//    }
    
    // Grab the image from the context
    UIImage *complexViewImage = UIGraphicsGetImageFromCurrentImageContext();
    // Finish using the context
    UIGraphicsEndImageContext();
    
    
    return complexViewImage;
}


@end
