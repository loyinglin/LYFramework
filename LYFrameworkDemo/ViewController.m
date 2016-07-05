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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSDictionary* dict = @{@"abc":@"abc"};
    [dict objectForClass:[NSNumber class]];
    
    UIImage *image = [UIImage imageNamed:@"abc"];
    CVPixelBufferRef buffer = [[CVUtil shareInstance] getPixelBufferFromCGImage:image.CGImage];
    image = [[CVUtil shareInstance] getImageFromPixelBuffer:buffer];
    
    if (buffer) { //不加容易内存泄露
        CFRelease(buffer);
    }
    
    [self.view addSubview:[[UIImageView alloc] initWithImage:image]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
