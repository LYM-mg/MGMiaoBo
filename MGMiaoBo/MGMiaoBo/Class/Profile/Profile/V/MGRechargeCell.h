//
//  MGRechargeCell.h
//  MGMiaoBo
//
//  Created by ming on 16/9/22.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGRechargeCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** <#注释#> */
@property (nonatomic,strong) NSDictionary *dict;
@end
