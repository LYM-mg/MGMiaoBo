//
//  NSObject+FileManager.m
//  04-BaiSi
//
//  Created by ming on 13/13/21.
//  Copyright © 2013年 ming. All rights reserved.
//

#import "NSObject+FileManager.h"

@implementation NSObject (FileManager)

// 异步方法,不需要返回值
// 异步方法使用回调,block
// 获取文件尺寸
+ (void)getFileSizeWithFileName:(NSString *)path completion:(void(^)(NSInteger totalSize))completionBlock{
    // 在子线程中计算文件大小
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       // 1.文件总大小
       NSInteger totalSize = 0;
       
       // 2.创建文件管理者
       NSFileManager *fileManager = [NSFileManager defaultManager];
       
       // 3.判断文件存不存在以及是否是文件夹
       BOOL isDirectory = NO;
       BOOL isFileExist = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
        
       if (!isFileExist) return; // 文件不存在
        
       if (isDirectory) { // 是文件夹
            NSArray *subPaths = [fileManager subpathsAtPath:path];
            for (NSString *subPath in subPaths) {
                 NSString *filePath = [path stringByAppendingPathComponent:subPath];
                BOOL isDirectory = NO;
                BOOL isExistFile = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
                if (!isDirectory && isExistFile && ![filePath containsString:@"DS"]) {
                    totalSize += [fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
                }
            }
        }else{ // 不是文件夹
            totalSize = [fileManager attributesOfItemAtPath:path error:nil].fileSize ;
        }
        
        // 回到主线程
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(totalSize);
            }
        });
    });
}

- (void)getFileSizeWithFileName:(NSString *)path completion:(void (^)(NSInteger)) completionBlock{
    [NSObject getFileSizeWithFileName:path completion:completionBlock];
}

/** 获取路径 */
+ (NSString *)cachesPath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}
- (NSString *)cachesPath{
    return [NSObject cachesPath];
}

/** 删除caches */
+ (void)removeCachesWithCompletion:(void(^)())completionBlock{
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        // 创建文件管理者
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        // 删除文件
        NSString *path = self.cachesPath;
        
        BOOL isDirectory = NO;
        BOOL isfileExist = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
        if (!isfileExist) return ;
        if (isDirectory) {
            // 迭代器
            NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:path];
            for (NSString *subPath in enumerator) {
                NSString *filePath = [path stringByAppendingPathComponent:subPath];
                // 移除文件Or文件夹
                [fileManager removeItemAtPath:filePath error:nil];
            }
        }
        // 回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (completionBlock) {
                completionBlock();
            }
        }];
    }];
}

- (void)removeCachesWithCompletion:(void(^)())completionBlock{
    [NSObject removeCachesWithCompletion:completionBlock];
}


@end
