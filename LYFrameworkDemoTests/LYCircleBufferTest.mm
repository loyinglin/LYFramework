//
//  LYCircleBufferTest.m
//  LYFrameworkDemoTests
//
//  Created by loyinglin on 2018/2/7.
//  Copyright © 2018年 林伟池. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LYCircleBuffer.h"
#import <algorithm>
#import <deque>
using namespace std;

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

char s[1000];
#define bufferSize (10)
char testStr[bufferSize];

/**
 用双端队列来模拟环形缓冲区进行测试
 
 */
- (void)testBuffer {
    for (int i = 0; i < bufferSize; ++i) {
        testStr[i] = 'a' + arc4random_uniform(10);
    }
    deque<char> queue;
    LYCircleBuffer *circleBuffer = [[LYCircleBuffer alloc] initWithBufferSize:bufferSize];
    
    for (int i = 0; i < 100; ++i) {
        int type = arc4random_uniform(2);
        if (type == 0) { // read
            puts("--------------read----------------");
            [circleBuffer justOutputWithBuffer:s size:[circleBuffer getLeftSize]];
            printf("totalStr: ");
            for (int j = 0; j < [circleBuffer getLeftSize]; ++j) {
                putchar(s[j]);
            }
            printf("    with size: %d\n", [circleBuffer getLeftSize]);
            int readSize = arc4random_uniform(bufferSize / 2) + 1;
            char dequeStr[bufferSize];
            int dequeSize = [self readStrFromDeque:queue buffer:dequeStr size:readSize];
            
            char circleStr[bufferSize];
            int circleSize = [circleBuffer readWithBuffer:circleStr size:readSize];
            XCTAssert(circleSize == dequeSize);
            printf("readSize: %d\n", circleSize);
            printf("readStr: ");
            for (int j = 0; j < circleSize; ++j) {
                XCTAssert(dequeStr[j] == circleStr[j]);
                putchar(dequeStr[j]);
            }
            puts("");
            
            [circleBuffer justOutputWithBuffer:s size:[circleBuffer getLeftSize]];
            printf("totalStr: ");
            for (int j = 0; j < [circleBuffer getLeftSize]; ++j) {
                putchar(s[j]);
            }
            printf("    with size: %d\n", [circleBuffer getLeftSize]);
            
        }
        else {
            puts("--------------write----------------");
            [circleBuffer justOutputWithBuffer:s size:[circleBuffer getLeftSize]];
            printf("totalStr: ");
            for (int j = 0; j < [circleBuffer getLeftSize]; ++j) {
                putchar(s[j]);
            }
            printf("    with size: %d\n", [circleBuffer getLeftSize]);
            int writeSize = arc4random_uniform(bufferSize / 2) + 1;
            int dequeSize = [self writeStrFromDeque:queue buffer:testStr size:writeSize];
            int circleSize = [circleBuffer writeWithBuffer:testStr size:writeSize];
            
            printf("writeStr: ");
            for (int j = 0; j < circleSize; ++j) {
                putchar(testStr[j]);
            }
            puts("");
            XCTAssert(circleSize == dequeSize);
            
            [circleBuffer justOutputWithBuffer:s size:[circleBuffer getLeftSize]];
            printf("totalStr: ");
            for (int j = 0; j < [circleBuffer getLeftSize]; ++j) {
                putchar(s[j]);
            }
            printf("    with size: %d\n", [circleBuffer getLeftSize]);
        }
    }
    
    
}

- (uint32_t)readStrFromDeque:(deque<char> &)queue buffer:(char *)buffer size:(uint32_t)size {
    uint32_t ret = 0;
    ret = min(size, (uint32_t)queue.size());
    for (int i = 0; i < ret; ++i) {
        buffer[i] = queue.back();
        queue.pop_back();
    }
    return ret;
}

- (uint32_t)writeStrFromDeque:(deque<char> &)queue buffer:(char *)buffer size:(uint32_t)size {
    uint32_t ret = 0;
    ret = min(size, bufferSize - (uint32_t)queue.size());
    for (int i = 0; i < ret; ++i) {
        queue.push_front(buffer[i]);
    }
    return ret;
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
