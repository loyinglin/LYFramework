//
//  LYCircleBufferTest.m
//  LYFrameworkDemoTests
//
//  Created by loyinglin on 2018/2/7.
//  Copyright © 2018年 林伟池. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LYCircleBuffer.h"
#import "KSCircleBuffer.h"

@interface LYCircleBufferTest : XCTestCase

@end

@implementation LYCircleBufferTest

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
}

#define bufferSize (4000)
char ksReadStr[bufferSize];
char lyReadStr[bufferSize];
char writeStr[bufferSize];

/**
 用双端队列来模拟环形缓冲区进行测试
 
 */
#define defaultCircleBuffer (512 * 2 * 10) // 512帧大概12ms，保留大概120ms的延迟

- (void)testBuffer {
    printf("testStr: ");
    for (int i = 0; i < bufferSize; ++i) {
        writeStr[i] = 'a' + i % 26;
    }
    printf("    with buffer size:%d\n", bufferSize);

    LYCircleBuffer *lyBuffer = [[LYCircleBuffer alloc] initWithBufferSize:defaultCircleBuffer];
    KSCircleBuffer *ksBuffer = [[KSCircleBuffer alloc] initWithBufferSize:defaultCircleBuffer];
    
    /*
     每次随机读写；
     读写的长度为随机长度（10~2058），随机字符
     保证每次读写的字符串一致
     */
    for (int i = 0; i < 100; ++i) {
        int type = arc4random_uniform(2);
        int length = arc4random_uniform(2048) + 10;
        if (type == 0) { // read
            puts("--------------read----------------");
            int ksSize = [ksBuffer readWithBuffer:ksReadStr size:length];
            int lySize = [lyBuffer readWithBuffer:lyReadStr size:length];
            ksReadStr[ksSize] = 0;
            lyReadStr[ksSize] = 0;
            
            XCTAssert(ksSize == lySize);
            for (int i = 0; i < ksSize; ++i) {
                XCTAssert(ksReadStr[i] == lyReadStr[i]);
            }
        }
        else {
            puts("--------------write----------------");
            int pos = arc4random_uniform(100);
            int ksSize = [ksBuffer writeWithBuffer:writeStr + pos size:length];
            int lySize = [lyBuffer writeWithBuffer:writeStr + pos size:length];
            
            XCTAssert(ksSize == lySize);
        }
    }
}


//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
