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

@implementation ViewController

+ (void)load {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *path = [[FileUtil shareInstance] appPath];
//    NSLog(@"PATH %@", path);
    NSLog(@"%lx ", 0x100438bd0 - 0x100080000);
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
