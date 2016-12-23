//
//  NSObject+FileManager.h
//  04-BaiSi
//
//  Created by ming on 13/12/21.
//  Copyright © 2013年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FileManager)
/** 类方法获取文件的大小 有回调 */
+ (void)getFileSizeWithFileName:(NSString *)path completion:(void(^)(NSInteger totalSize))completionBlock;
/** 对象方法获取文件的大小 有回调 */
- (void)getFileSizeWithFileName:(NSString *)path completion:(void(^)(NSInteger totalSize))completionBlock;

/** 类方法获取caches路径 */
+ (NSString *)cachesPath;
/** 对象方法获取caches路径 */
- (NSString *)cachesPath;

/** 类方法移除caches 有回调 */
+ (void)removeCachesWithCompletion:(void(^)())completionBlock;
/** 对象方法移除caches 有回调 */
- (void)removeCachesWithCompletion:(void(^)())completionBlock;

@end
