//
//  MGHotADCell.m
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "MGHotADCell.h"
#import "MGHotAD.h"
#import "XRCarouselView/XRCarouselView.h"

@interface MGHotADCell ()<XRCarouselViewDelegate>
/** 图片数组 */
@property (nonatomic,strong) NSMutableArray *imageUrls;
@property (nonatomic,weak) XRCarouselView *carouselView;
@end

@implementation MGHotADCell

- (NSMutableArray *)imageUrls {
    if (_imageUrls == nil) {
        _imageUrls = [NSMutableArray array];;
    }
    return _imageUrls;
}

- (XRCarouselView *)carouselView{
    if (_carouselView == nil) {
        XRCarouselView *carouselView = [XRCarouselView carouselViewWithImageArray:nil describeArray:nil];
        carouselView.time = 1.8;
        carouselView.delegate = self;
        carouselView.frame = self.contentView.bounds;
        carouselView.backgroundColor = [UIColor clearColor];
        _carouselView = carouselView;
        [self.contentView addSubview:carouselView];
    }
    return _carouselView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self carouselView];
    }
    return self;
}

/**
 *  重写数组
 *
 *  @param topADs 广告数据
 */
- (void)setTopADs:(NSArray *)topADs
{
    [self.imageUrls removeAllObjects];
    _topADs = topADs;
    for (MGHotAD *topAD in topADs) {
        [self.imageUrls addObject:topAD.imageUrl];
    }
    self.carouselView.imageArray = self.imageUrls;
}

#pragma mark - XRCarouselViewDelegate
- (void)carouselView:(XRCarouselView *)carouselView clickImageAtIndex:(NSInteger)index
{
    if (self.imageClickBlock) {
        self.imageClickBlock(self.topADs[index]);
    }
}


@end
