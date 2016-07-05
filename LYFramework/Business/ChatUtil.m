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
/**
 *  获取过滤后的字符串
 *
 *  @param srcString 被过滤的字符串
 *
 *  @return 过滤后的字符串
 */
- (NSString *)getFilterStringWithSrc:(NSString *)srcString {
    if (srcString) {
        for (NSString* filterString in self.mFilterArray) {
            NSString* tmpString = [filterString stringByReplacingOccurrencesOfString:@"." withString:@"*" options:NSRegularExpressionSearch | NSCaseInsensitiveSearch range:NSMakeRange(0, filterString.length)];
            srcString = [srcString stringByReplacingOccurrencesOfString:filterString withString:tmpString];
        }
    }
    return srcString;
}

#pragma mark - valid
/**
 *  判断是否微信号
 *
 *  @param weixin 字符串
 *
 *  @return 是否微信号
 */
- (BOOL)vaildateWeixinID:(NSString *)weixin {
    BOOL ret = NO;
    if (weixin) {
        NSString *weixinRegex = @"^[a-zA-Z0-9_]{5,}$";
        NSPredicate *weixinlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", weixinRegex];
        ret = [weixinlTest evaluateWithObject:weixin];
        
    }
    return ret;
}

/**
 *  判断是否邮箱格式是否为*@*.*
 *
 *  @param email 字符串
 *
 *  @return 是否为邮箱
 */
- (BOOL)validateEmail:(NSString *)email {
    BOOL ret = NO;
    if (email) {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        ret = [emailTest evaluateWithObject:email];
    }
    
    return ret;
}

/**
 *  判断是否为11位手机号
 *
 *  @param mobile 字符串
 *
 *  @return 是否为11位字符串
 */
- (BOOL)validateMobile:(NSString *)mobile {
    BOOL ret = NO;
    if (mobile) {
        //手机号以13， 15，18开头，八个 \d 数字字符
        // \d 表示0-9的数字，这么写是简略写法 [0-9] 也表示0-9
        NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        ret = [phoneTest evaluateWithObject:mobile];
    }
    
    return ret;
}

/**
 *  判断是否为6到20位的昵称，只能包括字母和数字
 *
 *  @param name 字符串
 *
 *  @return 是否为合适的昵称
 */
- (BOOL)validateUserName:(NSString *)name {
    BOOL ret = NO;
    if (name) {
        NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
        NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
        ret = [userNamePredicate evaluateWithObject:name];
    }
    return ret;
}

/**
 *  是否为6到20位的密码，只能包括字母和数字
 *
 *  @param passWord 字符串
 *
 *  @return 是否为合适的密码
 */
- (BOOL)validatePassword:(NSString *)passWord {
    BOOL ret = NO;
    if (passWord) {
        NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
        ret = [passWordPredicate evaluateWithObject:passWord];
    }
    
    return ret;
}

/**
 *  是否为2到8位的昵称，只能包括字母、数字和中文
 *
 *  @param nickname 字符串
 *
 *  @return 是否为合适的昵称
 */
- (BOOL)validateNickname:(NSString *)nickname {
    BOOL ret = NO;
    if (nickname) {
        NSString *nicknameRegex = @"^[\u4e00-\u9fa5A-Za-z0-9]{2,8}$";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
        ret =[passWordPredicate evaluateWithObject:nickname];
    }
    return ret;
}

/**
 *  是否为身份证
 *
 *  @param identityCard 字符串
 *
 *  @return 是否为身份证
 */
- (BOOL)validateIdentityCard:(NSString *)identityCard {
    BOOL ret = NO;
    if (identityCard) {
        NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        ret = [identityCardPredicate evaluateWithObject:identityCard];
    }
    
    return ret;
}
#pragma mark - message




@end
