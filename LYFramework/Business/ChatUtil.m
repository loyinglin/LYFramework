//
//  ChatUtil.m
//  qianchuo
//
//  Created by 林伟池 on 16/5/24.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ChatUtil.h"

@interface ChatUtil()

@property (nonatomic , strong) NSArray* mFilterArray;

@end

@implementation ChatUtil


#pragma mark - init
+ (instancetype)shareInstance {
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _mFilterArray = [self loadFileData];
    }
    return self;
}

- (NSArray *) loadFileData
{
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"dirtywords.txt"];
    
    NSError* err=nil;
    NSString* mTxt=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    
    NSLog(@"dirty words:%@",mTxt);
    return [mTxt componentsSeparatedByString:@"，"];
}
#pragma mark - update



#pragma mark - get

- (NSString *)getFilterStringWithSrc:(NSString *)srcString {
    if (srcString) {
        for (NSString* filterString in self.mFilterArray) {
            NSString* tmpString = [filterString stringByReplacingRegex:@"." with:@"*" caseInsensitive:NO];
            srcString = [srcString stringByReplacing:filterString with:tmpString];
        }
    }
    return srcString;
}


#pragma mark - message




@end
