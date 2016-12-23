//
//  MGTopWindow.m
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "MGTopWindow.h"

@implementation MGTopWindow

static UIButton *btn_;

+ (void)show
{
    btn_.hidden = NO;
}

+ (void)hide
{
    btn_.hidden = YES;
}

+ (void)initialize
{
    UIButton *btn = [[UIButton alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    [btn addTarget:self action:@selector(windowClick) forControlEvents:UIControlEventTouchUpInside];
    [[self statusBarView] addSubview:btn];
    btn.hidden = YES;
    btn_ = btn;
}

/**
 获取当前状态栏的方法
 */
+ (UIView *)statusBarView
{
    UIView *statusBar = nil;
    NSData *data = [NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9];
    NSString *key = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    id object = [UIApplication sharedApplication];
    if ([object respondsToSelector:NSSelectorFromString(key)])
        statusBar = [object valueForKey:key];
    return statusBar;
}

/**
 * 监听窗口点击
 */
+ (void)windowClick
{
    NSLog(@"点击了最顶部...");
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self seekAllScrollViewInView:window];
}

+ (void)seekAllScrollViewInView:(UIView *)view
{
    // 递归 这样就可以获得所有的View
    for (UIView *subView in view.subviews) {
        [self seekAllScrollViewInView:subView];
    }
    
    // 是否是ScrollView    不是，直接返回
    if (![view isKindOfClass:[UIScrollView class]]) return;
    UIScrollView *scrollView = (UIScrollView *)view;
    
    // 判断ScrollView是否跟窗口有重叠  没有重叠，直接返回
    if(![scrollView intersectsOtherView:nil]) return;
    
    // 是ScrollView滚动到最前面（包括内边距）
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
    /// 这样也可以滚动到最前面（指的是内容）
    //    CGPoint offset = scrollView.contentOffset;
    //    offset.y = -scrollView.contentInset.top;
    //    scrollView.contentOffset = offset;
    //    [scrollView setContentOffset:offset animated:YES];
}

@end
