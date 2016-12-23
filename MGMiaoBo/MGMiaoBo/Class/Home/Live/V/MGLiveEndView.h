/*
    @header MGLiveEndView.h
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/11.
 
    Copyright © 2016年 ming. All rights reserved.
 */

#import <UIKit/UIKit.h>

@interface MGLiveEndView : UIView

/** 查看其它房间的回调 */
@property (nonatomic,strong) void (^lookOtherRoomBtnBlock)();

/** 查看其它房间的回调 */
@property (nonatomic,strong) void (^quitRoomBtnBlock)();


+ (instancetype)liveEndView;
@end
