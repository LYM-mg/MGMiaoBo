//
//  MGBaseSettingViewController.h
//  MGMiaoBo
//
//  Created by ming on 16/9/12.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSettingCell.h"
#import "MGGroupItem.h"
#import "MGSettingItem.h"
#import "MGSwitchItem.h"
#import "MGArrowItem.h"

#import "MGAboutMiaoboController.h"
#import "HomeWebVC.h"
#import "NSObject+FileManager.h"
#import "SVProgressHUD.h"


@interface MGBaseSettingViewController : UITableViewController

/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *groups;

/** 缓存尺寸*/
@property(nonatomic ,assign) NSInteger total;

@end
