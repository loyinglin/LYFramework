//
//  TimeUtilTest.m
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/7/6.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TimeUtil.h"

@interface TimeUtilTest : XCTestCase

@end

@implementation TimeUtilTest

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
    double time = [[TimeUtil shareInstance] getBlockExecuteTime:^{
        for (int i = 0; i < 10; ++i) {
            [NSThread sleepForTimeInterval:1];
        }
    }];
    XCTAssertTrue(time >= 10.0 && time <=11.0);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
