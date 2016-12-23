//
//  MGNetworkTool.h
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger,NetworkStatuses){
    NetworkStatusNone, // 没有网络
    NetworkStatus2G, // 2G
    NetworkStatus3G, // 3G
    NetworkStatus4G, // 4G
    NetworkStatusWIFI // WIFI
};

@interface MGNetworkTool : AFHTTPSessionManager

+ (instancetype)shareNetworkTool;

/**
 *  获取网络类型
 */
+ (NetworkStatuses)getNetworkStates;

@end
