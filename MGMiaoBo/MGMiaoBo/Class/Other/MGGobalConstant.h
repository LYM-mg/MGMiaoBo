//
//  MGGobalConstant.h
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGGobalConstant : NSObject
#pragma mark - 颜色
// 颜色相关
#define MGRGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define MGRGBColor(r,g,b) MGRGBAColor(r,g,b,1.0)
#define MGRandomRGBColor MGRGBColor(arc4random_uniform(255),arc4random_uniform(255),arc4random_uniform(255))
#define KeyColor MGRGBColor(216, 41, 116)


#pragma mark - frame
// 首页的选择器的宽度
#define HomeSeleted_Item_W 60
#define DefaultMargin       10
#define MGScreen_Width [UIScreen mainScreen].bounds.size.width
#define MGScreen_Height [UIScreen mainScreen].bounds.size.height

UIKIT_EXTERN CGFloat const MGNavHeight;
UIKIT_EXTERN CGFloat const MGTabBarHeight;

#pragma mark - 通知
/** 去看热门直播按钮被点击的通知 */
UIKIT_EXTERN NSString *const kMGToSeeHotZoneNotification;
/** 直播用户被点击的通知 */
UIKIT_EXTERN NSString *const kMGUserClickNotication;
/** 喵粮按钮被点击的通知 */
UIKIT_EXTERN NSString *const kMGGiftViewClickNotication;
@end
