//
//  MGHotLive.m
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "MGHotLive.h"

@implementation MGHotLive

- (UIImage *)starImage
{
    if (self.starlevel) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"girl_star%ld_40x19", self.starlevel]];
    }
    return nil;
}

@end
