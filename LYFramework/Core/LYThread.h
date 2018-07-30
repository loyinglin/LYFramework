//
//  LYThread.h
//  LYFrameworkDemo
//
//  Created by loyinglin on 2018/7/9.
//  Copyright © 2018年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ThreadBlock)(id param);

@interface LYThread : NSThread

@end
