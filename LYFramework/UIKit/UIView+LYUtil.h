//
//  UIView+LYUtil.h
//  LYFrameworkDemo
//
//  Created by 林伟池 on 2018/4/15.
//  Copyright © 2018年 林伟池. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LYUtil)


/**
 特定位置的圆角

 @param radius 弧度
 @param corners 特定位置
 */
- (void)applyRoundCorneWithrRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners;

@end
