//
//  LYDebug.h
//  Supermark
//
//  Created by 林伟池 on 15/9/17.
//  Copyright (c) 2015年 林伟池. All rights reserved.
//


#ifdef DEBUG 
#define LYLog(format...) LYDebug(__FILE__,__LINE__,format)

#else
#define LYLog(format...)  
#endif

#import <Foundation/Foundation.h>

void LYDebug(const char *fileName, int lineNumber, NSString *fmt, ...);


/**
 *  在 Supporting Files 中的 info.plist 中打开 Application supports iTunes file sharing
 *  把应用打包安装到手机中
 *  将手机断开 iTunes 连接后再重新连接 iTunes（必要步骤），打开应用，找到应用，在右边的“应用名称”的文稿中找到以“ly”开头的 log 文件。
 *  滚动到最下面，点击“存储到...”按钮将 Log 存储到桌面，双击打开就能看到 Log 信息了。
 */
void redirectNSlogToDocumentFolder();



NSArray* lyGetBacktrace();



