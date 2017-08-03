//
//  UIImage+gifUtil.m
//  LYFrameworkDemo
//
//  Created by 林伟池 on 2017/5/16.
//  Copyright © 2017年 林伟池. All rights reserved.
//

#import "UIImage+gifUtil.h"
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <ImageIO/ImageIO.h>

@implementation UIImage (gifUtil)

/*GIF播放参考代码，暂未处理
通过ImageIO提供的接口进行解码
frame（帧）：一个gif可以简单认为是多张image组成的动画，一帧就是其中一张图片image
frameCount（帧数）： 就是一个gif有多少帧
loopCount（播放次数）：有些gif播放到一定次数就停止了，如果为0就代表gif一直循环播放
delayTime（延迟时间）：每一帧播放的时间，也就是说这帧显示到delayTime就转到下一帧
所以gif播放主要就是把每一帧image解析出来，然后每一帧显示它对应的delaytime，然后再显示下一张。
*/
-(void)decodeWithData:(NSData *)data
{
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef) data, NULL);
    if (src)
    {
        //获取gif的帧数
        NSUInteger frameCount = CGImageSourceGetCount(src);
        //获取GfiImage的基本数据
        NSDictionary *gifProperties = (NSDictionary *) CFBridgingRelease(CGImageSourceCopyProperties(src, NULL));
        if(gifProperties)
        {
            //由GfiImage的基本数据获取gif数据
            NSDictionary *gifDictionary =[gifProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary];
            //获取gif的播放次数
            NSUInteger loopCount = [[gifDictionary objectForKey:(NSString*)kCGImagePropertyGIFLoopCount] integerValue];
            for (NSUInteger i = 0; i < frameCount; i++)
            {
                //得到每一帧的CGImage
                CGImageRef img = CGImageSourceCreateImageAtIndex(src, (size_t) i, NULL);
                if (img)
                {
                    //把CGImage转化为UIImage
                    UIImage *frameImage = [UIImage imageWithCGImage:img];
                    //获取每一帧的图片信息
                    NSDictionary *frameProperties = (NSDictionary *) CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, (size_t) i, NULL));
                    if (frameProperties)
                    {
                        //由每一帧的图片信息获取gif信息
                        NSDictionary *frameDictionary = [frameProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary];
                        //取出每一帧的delaytime
                        CGFloat delayTime = [[frameDictionary objectForKey:(NSString*)kCGImagePropertyGIFDelayTime] floatValue];
                        
                        //TODO 这里可以实现边解码边回调播放或者把每一帧image和delayTime存储起来
                        CFRelease((__bridge CFTypeRef)(frameProperties));
                    }
                    CGImageRelease(img);
                }
            }
            CFRelease((__bridge CFTypeRef)(gifProperties));
        }
        CFRelease(src);
    }
}
@end
