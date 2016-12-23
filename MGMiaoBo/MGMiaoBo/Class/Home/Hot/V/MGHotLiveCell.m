//
//  MGHotLiveCell.m
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "MGHotLiveCell.h"
#import "MGHotLive.h"
#import <UIImageView+WebCache.h>

@interface MGHotLiveCell ()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/** 地区 */
@property (weak, nonatomic) IBOutlet UIButton    *locationBtn;
/** 直播名 */
@property (weak, nonatomic) IBOutlet UILabel     *nameLabel;
/** 星级 */
@property (weak, nonatomic) IBOutlet UIImageView *startView;
/** 观众 */
@property (weak, nonatomic) IBOutlet UILabel     *audienceLabel;
/** 大的预览图 */
@property (weak, nonatomic) IBOutlet UIImageView *bigPicView;
@end

@implementation MGHotLiveCell

- (void)setLive:(MGHotLive *)live
{
    _live = live;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:live.smallpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        image = [UIImage  circleImage:image borderColor:[UIColor purpleColor] borderWidth:1];
        self.headImageView.image = image;
    }];
    
    self.nameLabel.text = live.myname;
    // 如果没有地址, 给个默认的地址
    if (!live.gps.length) {
        live.gps = @"喵星";
    }
    [self.locationBtn setTitle:live.gps forState:UIControlStateNormal];
    [self.bigPicView sd_setImageWithURL:[NSURL URLWithString:live.bigpic] placeholderImage:[UIImage imageNamed:@"profile_user_414x414"]];
    self.startView.image  = live.starImage;
    self.startView.hidden = !live.starlevel;
    
    // 设置当前观众数量
    NSString *fullAudience = [NSString stringWithFormat:@"%ld人在看", live.allnum];
    NSRange range = [fullAudience rangeOfString:[NSString stringWithFormat:@"%ld", live.allnum]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:fullAudience];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range: range];
    [attr addAttribute:NSForegroundColorAttributeName value:KeyColor range:range];
    self.audienceLabel.attributedText = attr;
}



@end
