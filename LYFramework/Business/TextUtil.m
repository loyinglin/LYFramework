//
//  TextUtil.m
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/7/16.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "TextUtil.h"
#import <UIKit/UIKit.h>

@implementation TextUtil


#pragma mark - init

+ (instancetype)shareInstance {
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}

#pragma mark - update



#pragma mark - get

-(NSAttributedString *)lyGetShadowWithString:(NSString *)string {
    NSAttributedString *ret;
    if (string) {
        NSShadow *shadow = [NSShadow new];
        shadow.shadowOffset = CGSizeZero;
        shadow.shadowBlurRadius = 5.0f;
        shadow.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        ret = [[NSAttributedString alloc] initWithString:string
                                              attributes:@{NSShadowAttributeName: shadow,
                                                           NSForegroundColorAttributeName: [UIColor whiteColor]}];
    }
    return ret;
}


#pragma mark - message

@end
