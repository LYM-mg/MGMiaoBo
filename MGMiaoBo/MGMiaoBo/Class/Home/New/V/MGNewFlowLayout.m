//
//  MGNewFlowLayout.m
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "MGNewFlowLayout.h"

@implementation MGNewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    CGFloat margin = 2;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat wh = (MGScreen_Width - 2*margin) / 3.0;
    self.itemSize = CGSizeMake(wh , wh);
    self.minimumLineSpacing = margin;
    self.minimumInteritemSpacing = margin;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
}

@end
