//
//  FileUtil.m
//  LYFrameworkDemo
//
//  Created by 林伟池 on 16/11/8.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "FileUtil.h"
#import <sys/stat.h>


@interface FileUtil ()
{
    NSString *	_appPath;
    NSString *	_docPath;
    NSString *	_libPrefPath;
    NSString *	_libCachePath;
    NSString *	_tmpPath;
}

@end

@implementation FileUtil

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

- (NSString *)appPath
{
    if ( nil == _appPath )
    {
        NSError * error = nil;
        NSArray * paths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:NSHomeDirectory() error:&error];
        
        for ( NSString * path in paths )
        {
            if ( [path hasSuffix:@".app"] )
            {
                _appPath = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), path];
                break;
            }
        }
    }
    
    return _appPath;
}

- (NSString *)docPath
{
    if ( nil == _docPath )
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _docPath = [paths objectAtIndex:0];
    }
    
    return _docPath;
}

- (NSString *)libPrefPath
{
    if ( nil == _libPrefPath )
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
        
        [self touch:path];
        
        _libPrefPath = path;
    }
    
    return _libPrefPath;
}

- (NSString *)libCachePath
{
    if ( nil == _libCachePath )
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
        
        [self touch:path];
        
        _libCachePath = path;
    }
    
    return _libCachePath;
}

- (NSString *)tmpPath
{
    if ( nil == _tmpPath )
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/tmp"];
        
        [self touch:path];
        
        _tmpPath = path;
    }
    
    return _tmpPath;
}

-(NSString *) resPath:(NSString *)file{
    NSString *str =[file stringByDeletingPathExtension];
    NSString *str2 = [file pathExtension];
    return [[NSBundle mainBundle] pathForResource:str ofType:str2];
}

- (BOOL)touch:(NSString *)path
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    
    return YES;
}

- (BOOL)touchFile:(NSString *)file
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:file] )
    {
        return [[NSFileManager defaultManager] createFileAtPath:file
                                                       contents:[NSData data]
                                                     attributes:nil];
    }
    
    return YES;
}

/***************************************************************/
- (void)createDirectoryAtPath:(NSString *)aPath{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:aPath isDirectory:NULL] )
    {
        BOOL ret = [[NSFileManager defaultManager] createDirectoryAtPath:aPath
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:nil];
        if ( NO == ret ) {
            return;
        }
    }
}

- (NSMutableArray *)allFilesAtPath:(NSString *)direString type:(NSString*)fileType operation:(int)operatio{
    NSMutableArray *pathArray = [NSMutableArray array];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *tempArray = [fileManager contentsOfDirectoryAtPath:direString error:nil];
    
    if (tempArray == nil) {
        return nil;
    }
    
    NSString* type = [NSString stringWithFormat:@".%@",fileType];
    for (NSString *fileName in tempArray) {
        BOOL flag = YES;
        NSString *fullPath = [direString stringByAppendingPathComponent:fileName];
        
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&flag]){
            if (!flag) {
                if ([fileName hasSuffix:type]) {
                    [pathArray addObject:fullPath];
                }
            }
            else {
                
            }
        }
    }
    
    return pathArray;
}

- (uint64_t)sizeAtPath:(NSString *)filePath diskMode:(BOOL)diskMode{
    uint64_t totalSize = 0;
    NSMutableArray *searchPaths = [NSMutableArray arrayWithObject:filePath];
    while ([searchPaths count] > 0)
    {
        NSString *fullPath = [NSString stringWithString:[searchPaths objectAtIndex:0]];
        [searchPaths removeObjectAtIndex:0];
        
        struct stat fileStat;
        if (lstat([fullPath fileSystemRepresentation], &fileStat) == 0)
        {
            if (fileStat.st_mode & S_IFDIR)
            {
                NSArray *childSubPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullPath error:nil];
                for (NSString *childItem in childSubPaths)
                {
                    NSString *childPath = [fullPath stringByAppendingPathComponent:childItem];
                    [searchPaths insertObject:childPath atIndex:0];
                }
            }
            else
            {
                if (diskMode)
                    totalSize += fileStat.st_blocks * 512;
                else
                    totalSize += fileStat.st_size;
            }
        }
    }
    
    return totalSize;
}

// 判断bundle里面是否存在该文件
- (BOOL)judgeFileExistsInBundle:(NSString *)string
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:string ofType:nil];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:filePath];
}


#pragma mark - get




#pragma mark - message

@end
