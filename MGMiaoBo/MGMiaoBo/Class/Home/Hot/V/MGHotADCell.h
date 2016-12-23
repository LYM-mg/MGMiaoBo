//
//  MGHotADCell.h
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGHotAD;
@interface MGHotADCell : UITableViewCell
/** 顶部AD数组 */
@property (nonatomic, strong) NSArray<MGHotAD*> *topADs;
/** 点击图片的block */
@property (nonatomic, copy) void (^imageClickBlock)(MGHotAD *topAD);
@end
