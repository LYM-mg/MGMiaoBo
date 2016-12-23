//
//  NSSafeObject.h
//  MGMiaoBo
//
//  Created by ming on 16/9/11.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

/// justForText
@interface NSSafeObject : NSObject

- (instancetype)initWithObject:(id)object;
- (instancetype)initWithObject:(id)object withSelector:(SEL)selector;
- (void)excute;

@end