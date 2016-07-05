//
//  ChatUtil.h
//  qianchuo
//
//  Created by 林伟池 on 16/5/24.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatUtil : NSObject



#pragma mark - init
+ (instancetype)shareInstance;


#pragma mark - update



#pragma mark - get

- (NSString *)getFilterStringWithSrc:(NSString *)srcString;

- (BOOL)vaildateWeixinID:(NSString *)weixin;

- (BOOL)validateEmail:(NSString *)email;

- (BOOL)validateMobile:(NSString *)mobile;

- (BOOL)validateUserName:(NSString *)name;

- (BOOL)validatePassword:(NSString *)passWord;

- (BOOL)validateNickname:(NSString *)nickname;

- (BOOL)validateIdentityCard:(NSString *)identityCard;
#pragma mark - message


@end
