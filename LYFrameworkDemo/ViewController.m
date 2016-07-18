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
#import "UIImage+LYUtil.h"
#import "UIViewController+YingYingImagePickerController.h"
#import "UIView+LYSnapshot.h"

@interface ViewController ()

@end

@implementation ViewController

+ (void)load {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:imageView atIndex:0];
    
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_UI_IMAGE_PICKER_DONE object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        if ([note.object isKindOfClass:[UIImage class]]) {
            imageView.image = note.object;
        }
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"加载" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(100, 100, 100, 100)];
    [button addTarget:self action:@selector(lyModalChoosePicker) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    label.attributedText = [[TextUtil shareInstance] lyGetShadowWithString:@"bbb"];
    label.textColor = [UIColor whiteColor];
//    [self.view addSubview:label];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImage *image = [label lySnapshot];
        imageView.image = image;
    });
    
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)snapshot {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
