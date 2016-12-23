//
//  MGLiveFlowLayout.m
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "MGLiveFlowLayout.h"

@implementation MGLiveFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.itemSize = self.collectionView.bounds.size;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}
@end


