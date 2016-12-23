//
//  MGH264Encoder.h
//  MGMiaoBo
//
//  Created by ming on 16/9/23.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>

@interface MGH264Encoder : NSObject

// 初始化基本配置
- (void) initWithConfiguration;
- (void) initEncode:(int)width  height:(int)height;
- (void) encode:(CMSampleBufferRef)sampleBuffer;

@end
