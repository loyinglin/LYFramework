//
//  ViewController.m
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/5/23.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "ViewController.h"
#import "NSDictionary+LYDictToObject.h"
#import "CVUtil.h"
#import "RuntimeUtil.h"
#import "TimeUtil.h"
#import "LYRACDefine.h"

@interface ViewController ()

@end

@implementation ViewController

+ (void)load {
    [[RuntimeUtil shareInstance] swizzleInstanceMethodWithClass:[self class] OriginSEL:@selector(selector) NewSEL:@selector(selectorNew)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSDictionary* dict = @{@"abc":@"abc"};
    [dict objectForClass:[NSNumber class]];
    
    UIImage *image = [UIImage imageNamed:@"abc"];
    CVPixelBufferRef buffer = [[CVUtil shareInstance] getPixelBufferFromCGImage:image.CGImage];
    image = [[CVUtil shareInstance] getImageFromPixelBuffer:buffer];
    
    if (buffer) { //不加内存泄露
        CFRelease(buffer);
    }
    
    [self.view addSubview:[[UIImageView alloc] initWithImage:image]];
    
    @weakify(self);
    [[TimeUtil shareInstance] getBlockExecuteTime:^{
        @strongify(self);
        [self selector];
    }];
    
    [self selector];
}

- (void)selector {
    NSLog(@"selector");
}

- (void)selectorNew {
    NSLog(@"selectorNew");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
