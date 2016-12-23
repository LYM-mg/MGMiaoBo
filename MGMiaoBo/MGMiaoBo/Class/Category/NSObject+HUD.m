//
//  NSObject+HUD.m
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "NSObject+HUD.h"

@implementation NSObject (HUD)
/**
 *  弹框提示
 *
 *  @param info 要提醒的内容
 */
- (void)showInfo:(NSString *)info
{
    // 只有是控制器的话才会弹框
    if ([self isKindOfClass:[UIViewController class]] || [self isKindOfClass:[UIView class]]) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:info message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:cancelAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVc animated:YES completion:nil];
    }
}
@end
