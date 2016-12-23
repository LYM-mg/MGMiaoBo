//
//  AppDelegate.m
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "AppDelegate.h"
#import "MGLoginViewController.h"
#import "Reachability.h"
#import "MGTopWindow.h"

@interface AppDelegate ()
{
    Reachability *_reacha;
    NetworkStatuses _preStatus;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [[MGLoginViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    
    [self checkNetworkStates];
    
    return YES;
}

// 实时监控网络状态
- (void)checkNetworkStates {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange) name:kReachabilityChangedNotification object:nil];
    _reacha = [Reachability reachabilityWithHostName:@"http://www.jianshu.com/collection/105dc167b43b"];
    [_reacha startNotifier];
}

// 实时监控网络状态的改变
- (void)networkChange
{
    NSString *tips;
    NetworkStatuses currentStatus = [MGNetworkTool getNetworkStates];
    if (currentStatus == _preStatus) {
        return;
    }
    _preStatus = currentStatus;
    switch (currentStatus) {
        case NetworkStatusNone:
            tips = @"当前没有网络，请检查你的网络";
            break;
        case NetworkStatus2G:
            tips = @"切换到了2G模式，请注意你的流量";
            break;
        case NetworkStatus3G:
            tips = @"切换到了3G模式，请注意你的流量";
            break;
        case NetworkStatus4G:
            tips = @"切换到了4G模式，请注意你的流量";
            break;
        case NetworkStatusWIFI:
            tips = @"";
            break;
        default:
            break;
    }
    // 提示
    if (tips.length) {
        [[[UIAlertView alloc] initWithTitle:@"喵播" message:tips delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
    }
}


#pragma mark - 应用开始聚焦
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // 给状态栏添加一个按钮可以进行点击, 可以让屏幕上的scrollView滚到最顶部
    [MGTopWindow show];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
