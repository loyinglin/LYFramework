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
#import "TextUtil.h"
#import "FileUtil.h"
#import "UIImage+LYUtil.h"
#import "UIViewController+YingYingImagePickerController.h"
#import "UIView+LYSnapshot.h"
#import "AroundModalAddressController.h"

@interface ViewController ()

@end

typedef void(^TestBlock)();

@implementation ViewController {
    int a;
    NSString *b;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    a = 0;
    b = @"0";
    __block int c = 0;
    NSLog(@"%p %p %p", &a, &b, &c);
    TestBlock block = ^() {
        a = 100;
        b = @"100";
        c = 100;
        
        NSLog(@"%p %p %p", &a, &b, &c);
    };
    block();
    NSLog(@"%d %@ %d", a, b, c);
    
    UIImage *image = [UIImage imageNamed:@"abc.png"];
    [self.view addSubview:[[UIImageView alloc] initWithImage:[image lyRenderBlackToRedColor]]];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
