//
//  MPOpenReplyViewController.h
//  kissfire
//
//  Created by Plum on 16/2/3.
//  Copyright © 2016年 manpaoTech. All rights reserved.
//

#import "MPBaseViewController.h"
#import "MPReplyToolBarView.h"

@interface MPOpenReplyViewController : MPBaseViewController


@property (strong,nonatomic) UIImage *bgImg;

@property (weak,nonatomic) UIImageView *bgView;

@property (weak,nonatomic) UIView *blackBgView;

@property (weak,nonatomic) MPReplyToolBarView *toolbar;


@end
