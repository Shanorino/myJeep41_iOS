//
//  WYWebProgressLayer.h
//  HKPTimeLine
//
//  Created by jokerking on 16/11/24.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface WYWebProgressLayer : CAShapeLayer
- (void)finishedLoad;
- (void)startLoad;
- (void)closeTimer;
@end
