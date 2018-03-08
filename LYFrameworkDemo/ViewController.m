//
//  ViewController.m
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/5/23.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "ViewController.h"
#import "KSCircleBuffer.h"
#import "LYCircleBuffer.h"

@interface ViewController ()

@end

typedef void(^TestBlock)();

@implementation ViewController {
    int a;
    NSString *b;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testBuffer];
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
            lyReadStr[lySize] = 0;
            
            if (ksSize != lySize) {
                NSLog(@"%s \n %s", ksReadStr, lyReadStr);
            }
            BOOL right = YES;
            for (int i = 0; i < ksSize; ++i) {
                if (ksReadStr[i] != lyReadStr[i]) {
                    right = NO;
                    NSLog(@"wrong pos : %d ", i);
                }
            }
            if (!right) {
                NSLog(@"%s \n %s", ksReadStr, lyReadStr);
            }
        }
        else {
            puts("--------------write----------------");
            int pos = arc4random_uniform(100);
            int ksSize = [ksBuffer writeWithBuffer:writeStr + pos size:length];
            int lySize = [lyBuffer writeWithBuffer:writeStr + pos size:length];
            
            if (ksSize != lySize) {
                NSLog(@"%s \n %s", ksReadStr, lyReadStr);
            }
        }
        NSLog(@"leftSize :  %d", [ksBuffer getLeftSize]);
    }
    NSLog(@"ok");
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
