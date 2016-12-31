//
//  NSTimer+addition.m
//  HKPTimeLine
//
//  Created by jokerking on 16/11/24.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "NSTimer+addition.h"

@implementation NSTimer (addition)

- (void)pause {
    if (!self.isValid) return;
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resume {
    if (!self.isValid) return;
    [self setFireDate:[NSDate date]];
}

- (void)resumeWithTimeInterval:(NSTimeInterval)time {
    if (!self.isValid) return;
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:time]];
}
@end
