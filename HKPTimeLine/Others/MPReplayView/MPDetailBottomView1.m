//
//  MPDetailBottomView1.m
//  KissFire
//
//  Created by Plum on 15/7/6.
//  Copyright (c) 2015年 manpaoTech. All rights reserved.
//

#import "MPDetailBottomView1.h"
#import "CONST.h"
@interface MPDetailBottomView1 ()

@end

@implementation MPDetailBottomView1

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        CGFloat height = frame.size.height;
        
        self.backgroundColor = [UIColor whiteColor];
       
        
        UIImageView *lineLabel = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, 1)];
        lineLabel.backgroundColor = Line_COLOR;
        [self addSubview:lineLabel];
        
        CGFloat leftViewL = 10;
        CGFloat leftViewH = height;

        CGFloat leftViewW = 200;

        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftViewL, 0, leftViewW, leftViewH)];
        nameLabel.text = NSLocalizedString(@"Forum_Reply_Hint", nil);
        nameLabel.font = [UIFont fontWithName:MPFONTNAME size:16];
        nameLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:nameLabel];
        
    }
    return self;
}

@end
