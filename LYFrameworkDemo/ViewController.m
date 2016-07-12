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
#import "UIImage+LYUtil.h"
#import "UIViewController+YingYingImagePickerController.h"

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
//            UIView* view = [[UIImageView alloc] initWithImage:[(UIImage *)note.object lyChangeSizeWithMaxSize:CGSizeMake(640, 640)]];
            imageView.image = note.object;
        }
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"加载" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(100, 100, 100, 100)];
    [button addTarget:self action:@selector(lyModalChoosePicker) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
