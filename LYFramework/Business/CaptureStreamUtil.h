//
//  CaptureStreamUtil.h
//  qianchuo
//
//  Created by 林伟池 on 16/9/19.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface CaptureStreamUtil : NSObject

@property (nonatomic , strong) UIView* mCaptureView;
@property (nonatomic , assign) BOOL mIsCaptureStream;

#pragma mark - init
+ (instancetype)shareInstance;


#pragma mark - update

- (void)startCapture;
- (void)stopCapture;


#pragma mark - get

- (void)appendAudioSample:(CMSampleBufferRef)sampleBuffer;
- (void)appendVideoSample:(CMSampleBufferRef)sampleBuffer;


#pragma mark - message

@end
