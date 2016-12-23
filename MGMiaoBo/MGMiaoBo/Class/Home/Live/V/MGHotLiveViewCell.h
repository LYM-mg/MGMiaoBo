//
//  MGHotLiveViewCell.h
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGHotLive;
@interface MGHotLiveViewCell : UICollectionViewCell

/** 直播 */
@property (nonatomic, strong) MGHotLive *live;
/** 相关的直播或者主播 */
@property (nonatomic, strong) MGHotLive *relateLive;
/** 父控制器 */
@property (nonatomic, weak) UIViewController *parentVc;
/** 点击关联主播 */
@property (nonatomic, copy) void (^clickRelatedLive)();

@end
