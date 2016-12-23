/*
    @header MGLiveEndView.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/11.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
    Copyright © 2016年 ming. All rights reserved.
 */


#import "MGLiveEndView.h"

@interface MGLiveEndView ()
/** 关注 */
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
/** 查看其它主播的房间 */
@property (weak, nonatomic) IBOutlet UIButton *lookOtherRoomBtn;
/** 退出房间 */
@property (weak, nonatomic) IBOutlet UIButton *quitRoomBtn;
/** 直播时长 */
@property (weak, nonatomic) IBOutlet UILabel *showTimeLabel;
/** 观看人数 */
@property (weak, nonatomic) IBOutlet UILabel *audienceNumber;

@end

@implementation MGLiveEndView

+ (instancetype)liveEndView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MGLiveEndView class]) owner:nil options:nil].lastObject;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self maskcornerRadius:self.followBtn];
    [self maskcornerRadius:self.lookOtherRoomBtn];
    [self maskcornerRadius:self.quitRoomBtn];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 1.1并日期格式化
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    // 3.指定时区
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    // 1.2拿到服务器返回的时间

    // 4.转换时间
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    
    NSDate *selfDate = [fmt dateFromString:@"2016-09-10 16:44:55"];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |
    NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *coms = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    self.showTimeLabel.text = [NSString stringWithFormat:@"%ld:%ld:%ld",(long)coms.hour,coms.minute,coms.second];
    self.audienceNumber.text = [NSString stringWithFormat:@"%d人",arc4random_uniform(20000)];
}

- (void)maskcornerRadius:(UIButton *)btn {
    btn.layer.cornerRadius = btn.height * 0.5;
    if (btn != self.lookOtherRoomBtn) {
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = KeyColor.CGColor;
    }
}

#pragma mark - 按钮点击操作
- (IBAction)followBtnClick:(UIButton *)sender {
    [sender setTitle:@"关注成功" forState:UIControlStateNormal];
}
- (IBAction)lookOtherRoomBtnClick {
    [self removeFromSuperview];
    if (self.lookOtherRoomBtnBlock) {
        self.lookOtherRoomBtnBlock();
    }
}
- (IBAction)quitRoomBtnClick {
    if (self.quitRoomBtnBlock) {
        self.quitRoomBtnBlock();
    }
}

@end
