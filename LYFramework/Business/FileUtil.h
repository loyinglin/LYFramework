//
//  FileUtil.h
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/11/8.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject


#pragma mark - init
+ (instancetype)shareInstance;

#pragma mark - update

- (NSString *)docPath;		// 文档目录，需要ITUNES同步备份的数据存这里
- (NSString *)libPrefPath;	// 配置目录，配置文件存这里
- (NSString *)libCachePath;	// 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
- (NSString *)tmpPath;		// 缓存目录，APP退出后，系统可能会删除这里的内容
- (NSString *) resPath:(NSString *)file;      // 资源目录



#pragma mark - get

/**
 目录，不存在就创建

 @param path 目录路径
 @return 返回是否成功
 */
- (BOOL)touch:(NSString *)path;


/**
 文件

 @param file 文件路径
 @return 返回是否成功
 */
- (BOOL)touchFile:(NSString *)file;

/**
 * 创建目录
 * api parameters 说明
 * aPath 目录路径
 */
- (void)createDirectoryAtPath:(NSString *)aPath;

/**
 * 返回目下所有给定后缀的文件的方法
 * api parameters 说明
 *
 * direString 目录绝对路径
 * fileType 文件后缀名
 * operation (预留,暂时没用)
 */
- (NSMutableArray *)allFilesAtPath:(NSString *)direString type:(NSString*)fileType operation:(int)operation;


/**
 * 返回目录文件的size,单位字节
 * api parameters 说明
 *
 * filePath 目录路径
 * diskMode 是否是磁盘占用的size
 */
- (uint64_t)sizeAtPath:(NSString *)filePath diskMode:(BOOL)diskMode;

// 判断bundle里面是否存在该文件
- (BOOL)judgeFileExistsInBundle:(NSString *)string;


#pragma mark - message


@end
