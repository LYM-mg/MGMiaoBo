//
//  MGAnchorCell.h
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MGUser;

@interface MGAnchorCell : UICollectionViewCell

/** 主播 */
@property(nonatomic, strong) MGUser *user;

@end
