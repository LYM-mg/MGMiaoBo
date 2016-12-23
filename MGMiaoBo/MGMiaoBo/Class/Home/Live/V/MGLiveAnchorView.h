/*
    @header MGLiveAnchorView.h
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/11.
 
    Copyright © 2016年 ming. All rights reserved.
 */

#import <UIKit/UIKit.h>

@class MGUser,MGHotLive;
@interface MGLiveAnchorView : UIView

/** 主播 */
@property(nonatomic, strong) MGUser *user;
/** 直播 */
@property(nonatomic, strong) MGHotLive *live;
/** 点击开开关  */
@property(nonatomic, copy)void (^clickDeviceShow)(bool selected);

/** 点击GiftView  */
@property(nonatomic, copy)void (^clickGiftViewShow)();
/** 快速创建 */
+ (instancetype)liveAnchorView;

@end
