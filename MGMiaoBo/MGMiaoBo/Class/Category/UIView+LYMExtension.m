//
//  UIView+LYMExtension.m
//  UIView+LYMExtension.h
//
//  Created by ming on 13/12/10.
//  Copyright © 2013年 ming. All rights reserved.
/**
    此类不仅封装了控件的Frame，还封装了快速从XIB创建View的方法(仅限于XIB中只有一个View的时候)
    此外，还封装了两个View是否有重叠的方法
 */

#import "UIView+LYMExtension.h"

@implementation UIView (LYMExtension)

#pragma mark - setter
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (void)setX:(CGFloat)x
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = x;
    self.frame = tempFrame;
}

- (void)setY:(CGFloat)y
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.y  = y;
    self.frame = tempFrame;
}

- (void)setWidth:(CGFloat)width
{
    CGRect tempFrame = self.frame;
    tempFrame.size.width = width;
    self.frame = tempFrame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect tempFrame = self.frame;
    tempFrame.size.height = height;
    self.frame = tempFrame;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark - getter
- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGSize)size
{
    return self.frame.size;
}

#pragma mark  方法
// 从Xib加载View(仅限于XIB中只有一个View的时候)
+ (instancetype)viewFromXib{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

/**
 *  判断两个View是否有重叠
 *  otherView：跟当前View比较的，如果为空，就代表是窗口控制器的View
 */
- (BOOL)intersectsOtherView:(UIView *)otherView{
    if (otherView == nil) {
        otherView = [UIApplication sharedApplication].keyWindow;
    }
    CGRect selfRect = [self convertRect:self.bounds toView:nil];
    CGRect otherRect = [otherView convertRect:otherView.bounds toView:nil];
    return CGRectIntersectsRect(selfRect, otherRect);
    
}

@end
