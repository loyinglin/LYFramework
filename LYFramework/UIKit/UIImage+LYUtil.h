//
//  UIImage+LYUtil.h
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/7/12.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LYUtil)

#pragma mark - 静态方法

/**
 UIView截图

 @param view 需要截图的view
 @return 截图
 */
+ (UIImage *)lyImageWithCaptureView:(UIView *)view;

/**
 返回纯色图片

 @param color 对应颜色
 @return 描述
 */
+ (UIImage *)lyImageWithColor:(UIColor *)color;

#pragma mark - 实例方法

/**
 更改图片尺寸，保持原图比例，尽可能放大

 @param maxSize 最大尺寸
 @return 修改后的图像
 */
- (UIImage *)lyChangeSizeWithMaxSize:(CGSize)maxSize;


/**
 旋转图片

 @param degrees 角度
 @return 旋转后图片
 */
- (UIImage *)lyImageRotatedByDegrees:(CGFloat)degrees;

// 翻转
- (UIImage *)lyVerticalFlip;
- (UIImage *)lyHorizontalFlip;


/**
 圆形裁剪

 @param img 图像
 @param radius 半径
 @return 裁剪后的图像
 */
- (UIImage *)lyClipUIBezierPath:(UIImage *)img cornerRadius:(CGFloat)radius;


/**
 特殊形状裁剪

 @param img 图像
 @param radius 四个角的半径
 @return 裁剪后的图像
 */
- (UIImage *)lyClipCGContext:(UIImage *)img cornerRadius:(CGFloat)radius;


- (UIImage *)lyRenderBlackToRedColor;
@end
