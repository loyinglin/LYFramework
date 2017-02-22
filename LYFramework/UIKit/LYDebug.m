//
//  LYDebug.m
//  Supermark
//
//  Created by 林伟池 on 15/9/17.
//  Copyright (c) 2015年 林伟池. All rights reserved.
//

#import "LYDebug.h"
#import <execinfo.h>

void LYDebug(const char *fileName, int lineNumber, NSString *fmt, ...)
{
    va_list args;
    
    va_start(args, fmt);
    
    static NSDateFormatter *debugFormatter = nil;
    
    if (debugFormatter == nil) {
        debugFormatter = [[NSDateFormatter alloc] init];
        [debugFormatter setDateFormat:@"yyyyMMdd.HH:mm:ss"];
    }
    
    NSString *msg = [[NSString alloc] initWithFormat:fmt arguments:args];
    
    NSString        *filePath = [[NSString alloc] initWithUTF8String:fileName];
    NSString        *timestamp = [debugFormatter stringFromDate:[NSDate date]];
    NSDictionary    *info = [[NSBundle mainBundle] infoDictionary];
    NSString        *appName = [info objectForKey:(NSString *)kCFBundleNameKey];
    fprintf(stdout, "%s %s[%s:%d] %s\n", [timestamp UTF8String], [appName UTF8String], [[filePath lastPathComponent] UTF8String], lineNumber, [msg UTF8String]);
    
    va_end(args);
}


void redirectNSlogToDocumentFolder() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MMddHHmmss"];
    NSString *formattedDate = [dateformatter stringFromDate:currentDate];
    
    NSString *fileName = [NSString stringWithFormat:@"ly%@.log", formattedDate];
    NSString *logFilePath =
    [documentDirectory stringByAppendingPathComponent:fileName];
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",
            stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",
            stderr);
}


NSArray* lyGetBacktrace() {
    //指针列表
    void* callstack[128];
    //backtrace用来获取当前线程的调用堆栈，获取的信息存放在这里的callstack中
    //128用来指定当前的buffer中可以保存多少个void*元素
    //返回值是实际获取的指针个数
    int frames = backtrace(callstack, 128);
    //backtrace_symbols将从backtrace函数获取的信息转化为一个字符串数组
    //返回一个指向字符串数组的指针
    //每个字符串包含了一个相对于callstack中对应元素的可打印信息，包括函数名、偏移地址、实际返回地址
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0; i < frames; i++) {
        
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}
