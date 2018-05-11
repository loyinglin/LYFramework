//
//  CVUtil.m
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/7/5.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "CVUtil.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation CVUtil



#pragma mark - init


+ (instancetype)shareInstance {
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}

#pragma mark - update



#pragma mark - get


- (CVPixelBufferRef)lyGetPixelBufferFaster:(CGImageRef)image {
    CVPixelBufferRef pxbuffer = NULL;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil, nil];
    
    size_t width =  CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    size_t bytesPerRow = CGImageGetBytesPerRow(image);
    
    CFDataRef  dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(image));
    GLubyte  *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
    
    CVPixelBufferCreateWithBytes(kCFAllocatorDefault,width,height,kCVPixelFormatType_32ARGB,imageData,bytesPerRow,NULL,NULL,(__bridge CFDictionaryRef)options,&pxbuffer);
    
    CFRelease(dataFromImageDataProvider);
    
    return pxbuffer;
}

/**
 *  根据图像返回CVPixelBufferRef
 *  不要忘记Release！！！
 *  不要忘记Release！！！
 *  不要忘记Release！！！
 *
 *  @param image 图像
 *
 *  @return 像素缓存引用
 */
- (CVPixelBufferRef)lyGetPixelBufferFromCGImage:(CGImageRef)image {
    NSDictionary *options = @{
                              (NSString*)kCVPixelBufferCGImageCompatibilityKey : @YES,
                              (NSString*)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
                              (NSString*)kCVPixelBufferIOSurfacePropertiesKey: [NSDictionary dictionary]
                              };
    CVPixelBufferRef pxbuffer = NULL;
    
    CGFloat frameWidth = CGImageGetWidth(image);
    CGFloat frameHeight = CGImageGetHeight(image);
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameWidth,
                                          frameHeight,
                                          kCVPixelFormatType_32BGRA,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameWidth,
                                                 frameHeight,
                                                 8,
                                                 CVPixelBufferGetBytesPerRow(pxbuffer),
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0,
                                           0,
                                           frameWidth,
                                           frameHeight),
                       image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
    
}


/**
 *  根据CVPixelBufferRef返回图像
 *
 *  @param pixelBufferRef 像素缓存引用
 *
 *  @return UIImage对象
 */
- (UIImage *)lyGetImageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef {
    CVImageBufferRef imageBuffer =  pixelBufferRef;
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow, rgbColorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrderDefault, provider, NULL, true, kCGRenderingIntentDefault);
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(rgbColorSpace);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return image;
}

- (void)lyConvertBGRAtoRGBA:(unsigned char *)data withSize:(size_t)size {
    for (unsigned char *p = data; p + 2 < data + size; p += 4) {
        unsigned char r = *(p + 2);
        unsigned char b = *p;
        *p = r;
        *(p + 2) = b;
    }
}
 


- (void)lyCompressVideo:(NSString *)path
{
    //    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //    NSString *savePath=[cachePath stringByAppendingPathComponent:MOVIEPATH];
    //    NSURL *saveUrl=[NSURL fileURLWithPath:savePath];
    if (!path) {
        path = @"Documents/Movie6.mp4";
    }
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:path];
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    // 通过文件的 url 获取到这个文件的资源
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:movieURL options:nil];
    // 用 AVAssetExportSession 这个类来导出资源中的属性
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    // 压缩视频
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) { // 导出属性是否包含低分辨率
        // 通过资源（AVURLAsset）来定义 AVAssetExportSession，得到资源属性来重新打包资源 （AVURLAsset, 将某一些属性重新定义
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        // 设置导出文件的存放路径
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        NSDate    *date = [[NSDate alloc] init];
        NSString *outPutPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"output-%@.mp4",[formatter stringFromDate:date]]];
        exportSession.outputURL = [NSURL fileURLWithPath:outPutPath];
        
        //        exportSession.videoComposition;
        
        // 是否对网络进行优化
        exportSession.shouldOptimizeForNetworkUse = true;
        
        // 转换成MP4格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        // 开始导出,导出后执行完成的block
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            // 如果导出的状态为完成
            
            NSLog(@"state %ld", (long)exportSession.status);
            
            if ([exportSession status] == AVAssetExportSessionStatusFailed) {
                
                NSLog(@"压缩失败的--%@", exportSession.error);
                
            }
            
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新一下显示包的大小
                    NSLog(@"压缩的大小%@ 到 %@", [NSString stringWithFormat:@"%f MB", [self getFileSize:pathToMovie]], [NSString stringWithFormat:@"%f MB", [self getFileSize:outPutPath]]);
                    
                    
                    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outPutPath))
                    {
                        [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:outPutPath] completionBlock:^(NSURL *assetURL, NSError *error)
                         {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 
                                 if (error) {
                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存失败" message:nil
                                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                     [alert show];
                                 } else {
                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存成功" message:nil
                                                                                    delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                     [alert show];
                                     [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:nil];
                                     
                                     
                                 }
                             });
                         }];
                    }
                    
                });
            }
        }];
    } else {
        NSLog(@"faile ");
    }
}

- (CGFloat)getFileSize:(NSString *)path
{
    NSDictionary *outputFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSLog (@"file size: %f", (unsigned long long)[outputFileAttributes fileSize]/1024.00 /1024.00);
    return (CGFloat)[outputFileAttributes fileSize]/1024.00 /1024.00;
}


#pragma mark - message



#pragma mark ---- <加载视频录制>
- (void)requestAccessForVideo{
    __weak typeof(self) _self = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{

                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
}

#pragma mark ---- <加载音频录制>
- (void)requestAccessForAudio{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}

@end
