/*
    @header MGUserView.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/11.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
    Copyright © 2016年 ming. All rights reserved.
 */


#import "MGUserView.h"
#import "MGUser.h"
#import "UIImage+Extension.h"
#import <SDWebImageDownloader.h>

@interface MGUserView ()
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *careNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansNumLabel;
@property (weak, nonatomic) IBOutlet UIView *userView;
@end

@implementation MGUserView

+ (instancetype)userView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.careNumLabel.text = [NSString stringWithFormat:@"%d", arc4random_uniform(5000) + 500];
    self.fansNumLabel.text = [NSString stringWithFormat:@"%d", arc4random_uniform(30000) + 500];
    self.userView.layer.cornerRadius = 10;
    self.userView.layer.masksToBounds = YES;
}

- (void)setUser:(MGUser *)user {
    _user = user;
    self.nickNameLabel.text = user.nickname;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:user.photo] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.coverView.image = [UIImage circleImage:image borderColor:[UIColor whiteColor] borderWidth:1];
        });
    }];
}

#pragma mark - 操作
- (IBAction)care:(UIButton *)sender {
    [sender setTitle:@"关注成功" forState:UIControlStateNormal];
}

- (IBAction)tipoffs {
    [self showInfo:@"举报成功"];
}

- (IBAction)close {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
