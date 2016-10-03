//
//  CaptureStreamUtil.m
//  qianchuo
//
//  Created by 林伟池 on 16/9/19.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "CaptureStreamUtil.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface CaptureStreamUtil ()

@property (strong, nonatomic) AVAssetWriter *mWriter;
@property (strong, nonatomic) AVAssetWriterInput *mVideoWriterInput;
@property (strong, nonatomic) AVAssetWriterInput *mAudioWriterInput;
@property (strong, nonatomic) AVAssetWriterInputPixelBufferAdaptor *mVideoWriterAdaptor;
@end


@implementation CaptureStreamUtil {
    dispatch_queue_t mWriterQueue;
    BOOL mIsStart;
    CMTime mTimeStamp;
}


#pragma mark - init

+ (instancetype)shareInstance {
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
     
    });
    return test;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        mWriterQueue = dispatch_queue_create("com.qianchuo.aulive.capture.writer", DISPATCH_QUEUE_SERIAL);

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureStreamApplicationDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureStreamApplicationWillEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

#pragma mark - update

- (void)startCapture {
    
    dispatch_async(mWriterQueue, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *moviePath = [[paths lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",@"CaptrueStream"]];
        [[NSFileManager defaultManager] removeItemAtPath:moviePath error:nil];
        NSError *vError = nil;
        self.mWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:moviePath] fileType:AVFileTypeQuickTimeMovie error:&vError];
        
        //Video
        NSDictionary *outputSettings = @{AVVideoCodecKey : AVVideoCodecH264, AVVideoWidthKey : @([UIScreen mainScreen].bounds.size.width), AVVideoHeightKey : @([UIScreen mainScreen].bounds.size.height)};
        self.mVideoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:outputSettings];
        self.mVideoWriterInput.expectsMediaDataInRealTime = YES;
        
        NSDictionary *sourcePixelBufferAttributes = @{(NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32ARGB)};
        self.mVideoWriterAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:self.mVideoWriterInput
                                                                                                    sourcePixelBufferAttributes:sourcePixelBufferAttributes];
        NSParameterAssert(self.mWriter);
        NSParameterAssert([self.mWriter canAddInput:self.mVideoWriterInput]);
        [self.mWriter addInput:self.mVideoWriterInput];
        
        
        NSDictionary *vOutputSettings = nil;
//        
        AudioChannelLayout acl;
        bzero( &acl, sizeof(acl));
        acl.mChannelLayoutTag = kAudioChannelLayoutTag_Mono;
        
        vOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                               [ NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                               [ NSNumber numberWithInt: 1 ], AVNumberOfChannelsKey,
                               [ NSNumber numberWithFloat: [AVAudioSession sharedInstance].sampleRate], AVSampleRateKey,
                               [ NSData dataWithBytes: &acl length: sizeof( acl ) ], AVChannelLayoutKey,
                               //[ NSNumber numberWithInt:AVAudioQualityLow], AVEncoderAudioQualityKey,
                               [ NSNumber numberWithInt: 96000], AVEncoderBitRatePerChannelKey,
                               nil];

        self.mAudioWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:vOutputSettings];
        self.mAudioWriterInput.expectsMediaDataInRealTime = NO;
        [self.mWriter addInput:self.mAudioWriterInput];

        [self.mWriter startWriting];
    });
    
    
}



- (void)cleanup {
    self.mWriter = nil;
    self.mVideoWriterInput = nil;
    self.mVideoWriterAdaptor = nil;
    self.mAudioWriterInput = nil;
    mIsStart = NO;
}

- (void)stopCapture {
    dispatch_async(mWriterQueue, ^ {
        if (self.mWriter.status != AVAssetWriterStatusCompleted && self.mWriter.status != AVAssetWriterStatusUnknown) {
            [self.mVideoWriterInput markAsFinished];
            [self.mAudioWriterInput markAsFinished];
        }
        [self.mWriter finishWritingWithCompletionHandler:^ {
            ALAssetsLibrary *vAL = [[ALAssetsLibrary alloc] init];
            [vAL writeVideoAtPathToSavedPhotosAlbum:[self.mWriter outputURL] completionBlock:^(NSURL *assetURL, NSError *error) {
                [[NSFileManager defaultManager] removeItemAtURL:[self.mWriter outputURL] error:nil];
                [self cleanup];
                NSString *message = @"success";
                if (error) {
                    message = [error description];
                }
                
//                UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"保存视频" message:message cancelButtonTitle:@"确定" didDismissBlock:nil otherButtonTitles:nil, nil];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [alertView show];
//                });
                NSLog(@"save %@", error);
            }];
        }];
    });
}


- (void)appendVideoSample:(CMSampleBufferRef)sampleBuffer {
    if (!self.mWriter || !sampleBuffer || !mIsStart) {
        return ;
    }
    CFRetain(sampleBuffer);
    dispatch_async(mWriterQueue, ^ {
        if (self.mVideoWriterInput.readyForMoreMediaData && self.mWriter.status == AVAssetWriterStatusWriting) {
            CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            if (pixelBuffer) {
                NSLog(@"video time %lf", CMTimeGetSeconds(mTimeStamp));
                if(![self.mVideoWriterAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:mTimeStamp]) {
                    NSLog(@"%s -> appendPixelBuffer faild", __FUNCTION__);
                }
            }
        }
        CFRelease(sampleBuffer);
    });
}

- (void)appendAudioSample:(CMSampleBufferRef)sampleBuffer {
    if (!self.mWriter || !sampleBuffer) {
        return ;
    }
    CFRetain(sampleBuffer);
    dispatch_async(mWriterQueue, ^ {
        mTimeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        NSLog(@"audio time %lf", CMTimeGetSeconds(mTimeStamp));
        if (!mIsStart) {
            [self.mWriter startSessionAtSourceTime:mTimeStamp];
            mIsStart = YES;
        }
//        if (self.mVideoWriterInput.readyForMoreMediaData) {
            if (sampleBuffer) {
                if ([self.mWriter status] == AVAssetWriterStatusWriting
                    && [self.mAudioWriterInput isReadyForMoreMediaData]
                    && mIsStart) {
                    if (![self.mAudioWriterInput appendSampleBuffer:sampleBuffer]) {
                        NSLog(@"%s -> ", __FUNCTION__);
                    }
                }
                else {
                    NSLog(@"error audio with status %d and isReady: %d", self.mWriter.status, [self.mAudioWriterInput isReadyForMoreMediaData]);
                }
            }
//        }
//        else {
//            NSLog(@"no ready video");
//        }
        
        CFRelease(sampleBuffer);
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - get

- (void)captureStreamApplicationDidEnterBackground:(id)sender {
    if (mIsStart) {
        [self stopCapture];
    }
}


- (void)captureStreamApplicationWillEnterForeground:(id)sender {
}





#pragma mark - message

@end
