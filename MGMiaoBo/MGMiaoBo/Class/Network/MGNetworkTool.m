//
//  MGNetworkTool.m
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "MGNetworkTool.h"

@implementation MGNetworkTool

static MGNetworkTool *_manager;

+ (instancetype)shareNetworkTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [MGNetworkTool manager];
        _manager.requestSerializer.timeoutInterval = 8.0;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    });
    return _manager;
}

// 判断网络类型
+ (NetworkStatuses)getNetworkStates {
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NetworkStatuses status = NetworkStatusNone;
    
    for (id child in subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            // 获取到状态栏码
            int networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            
            switch (networkType) {
                case 0:
                    // 无网模式
                    status = NetworkStatusNone;
                    break;
                case 1:
                    // 2G模式
                    status = NetworkStatus2G;
                    break;
                case 2:
                    // 3G模式
                    status = NetworkStatus3G;
                    break;
                case 3:
                    // 4G模式
                    status = NetworkStatus4G;
                    break;
                case 5:
                    // WIFI模式
                    status = NetworkStatusWIFI;
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    // 返回网络类型
    return status;
}

@end
