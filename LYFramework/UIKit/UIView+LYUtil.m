//
//  UIView+LYUtil.m
//  LYFrameworkDemo
//
//  Created by 林伟池 on 2018/4/15.
//  Copyright © 2018年 林伟池. All rights reserved.
//

#import "UIView+LYUtil.h"

@implementation UIView (LYUtil)

- (void)applyRoundCorneWithrRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath *cornerMaskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *cornerMaskLayer = [[CAShapeLayer alloc] init];
    cornerMaskLayer.frame = self.bounds;
    cornerMaskLayer.path = cornerMaskPath.CGPath;
    self.layer.mask = cornerMaskLayer;
}

@end
