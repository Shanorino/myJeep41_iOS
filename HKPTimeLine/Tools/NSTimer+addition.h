//
//  NSTimer+addition.h
//  HKPTimeLine
//
//  Created by jokerking on 16/11/24.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (addition)
- (void)pause;
- (void)resume;
- (void)resumeWithTimeInterval:(NSTimeInterval)time;
@end
