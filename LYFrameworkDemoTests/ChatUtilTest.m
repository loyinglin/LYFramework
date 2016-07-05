//
//  ChatUtilTest.m
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/7/4.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ChatUtil.h"

@interface ChatUtilTest : XCTestCase

@end

@implementation ChatUtilTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCTAssertTrue([[ChatUtil shareInstance] vaildateWeixinID:@"lin449944"]);
    XCTAssertTrue([[ChatUtil shareInstance] validateEmail:@"loying@foxmail.com"]);
    XCTAssertTrue([[ChatUtil shareInstance] validateMobile:@"18390222889"]);
    XCTAssertTrue([[ChatUtil shareInstance] validateNickname:@"落影"]);
    XCTAssertTrue([[ChatUtil shareInstance] validateNickname:@"abcfe"]);
    XCTAssertTrue([[ChatUtil shareInstance] validatePassword:@"qwerty"]);
    XCTAssertTrue([[ChatUtil shareInstance] validateUserName:@"loyinglin"]);
    XCTAssertTrue([[ChatUtil shareInstance] validateIdentityCard:@"445281199308320023"]);
    
    XCTAssertFalse([[ChatUtil shareInstance] vaildateWeixinID:@"abc"]);
    XCTAssertFalse([[ChatUtil shareInstance] validateEmail:@"loy#ing@foxmail.com"]);
    XCTAssertFalse([[ChatUtil shareInstance] validateMobile:@"11839022889"]);
    XCTAssertFalse([[ChatUtil shareInstance] validateNickname:@"#落影"]);
    XCTAssertFalse([[ChatUtil shareInstance] validatePassword:@"werty"]);
    XCTAssertFalse([[ChatUtil shareInstance] validateUserName:@"loyin#glin"]);
    XCTAssertFalse([[ChatUtil shareInstance] validateIdentityCard:@"a45281199308320023"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
