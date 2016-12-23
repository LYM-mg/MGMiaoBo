//
//  MGSettingCell.h
//  MGMiaoBo
//
//  Created by ming on 16/9/12.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGSettingItem;
@interface MGSettingCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)cellStyle;

/** 类型 */
@property (nonatomic, strong) MGSettingItem *item;

@end
