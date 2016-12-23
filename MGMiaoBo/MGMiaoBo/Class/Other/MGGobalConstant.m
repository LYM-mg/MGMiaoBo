//
//  MGGobalConstant.m
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "MGGobalConstant.h"
#import <UIKit/UIKit.h>

@implementation MGGobalConstant

//CGFloat const MGScreen_width = [UIScreen mainScreen].bounds.size.width;
//CGFloat const MGScreen_height = [UIScreen mainScreen].bounds.size.height;
#pragma mark - frame
/**
 *  导航栏高度64
 */
CGFloat const MGNavHeight = 64;
/**
 *  TabBar高度48
 */
CGFloat const MGTabBarHeight = 48;


#pragma mark - 通知
/** 去看热门直播按钮被点击的通知 */
NSString *const kMGToSeeHotZoneNotification = @"kMGToSeeHotZoneNotification";
/** 直播用户被点击的通知 */
NSString *const kMGUserClickNotication = @"kMGUserClickNotication";
/** 喵粮按钮被点击的通知 */
NSString *const kMGGiftViewClickNotication = @"kMGGiftViewClickNotication";
@end
