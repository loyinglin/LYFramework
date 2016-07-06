//
//  LYDefine.m
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/7/6.
//  Copyright © 2016年 林伟池. All rights rLYerved.
//

#import "LYDefine.h"



uint32_t LYRandomNumber(uint32_t min, uint32_t max)
{
    if (min > max) {
        uint32_t t = min; min = max; max = t;
    }
    return arc4random_uniform(max - min + 1) + min;
}

NSData *LYRandomDataOfLength(NSUInteger length)
{
    NSMutableData *data = [NSMutableData dataWithLength:length];
    int rLYult = SecRandomCopyBytes(NULL, (size_t)length, data.mutableBytes);
    if (0 != rLYult) {
        printf("%s: Unable to generate random data.\n", __PRETTY_FUNCTION__);
    }
    return data;
}

UIColor *LYRandomColor(void)
{
    return [UIColor colorWithRed:(CGFloat)arc4random()/UINT_MAX
                           green:(CGFloat)arc4random()/UINT_MAX
                            blue:(CGFloat)arc4random()/UINT_MAX
                           alpha:1.];
}

NSString *LYRandomStringOfLength(NSUInteger length)
{
    NSData *data = LYRandomDataOfLength(length);
    NSString *string = [data base64EncodedStringWithOptions:0];
    // Remove "+/-"
    string = [[string componentsSeparatedByCharactersInSet:
               [NSCharacterSet characterSetWithCharactersInString:@"+/="]]
              componentsJoinedByString:@""];
    // base64后的字符串长度是原串长度的大约135.1%， 去掉特殊字符后再检查字符串长度
    if (string.length == length) {
        return string;
    } else if (string.length > length) {
        return [string substringToIndex:length];
    } else {
        NSMutableString *rLYult = string.mutableCopy;
        for (NSUInteger i = string.length; i < length; i++) {
            NSUInteger loc = LYRandomNumber(0, (uint32_t)string.length);
            [rLYult appendFormat:@"%c", [string characterAtIndex:loc]];
        }
        return rLYult;
    }
}

NSString *LYUUID(void)
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFBridgingRelease(theUUID);
    return CFBridgingRelease(string);
}

