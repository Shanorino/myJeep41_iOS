//
//  MPReplyToolBarView.h
//  kissfire
//
//  Created by Plum on 16/2/3.
//  Copyright © 2016年 manpaoTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPBaseViewController.h"
#import "PlaceholderTextView.h"
#import "CONST.h"
@interface MPReplyToolBarView : UIView<UITextViewDelegate>
{
    UIImage *chooseImg;

}

@property (nonatomic,weak) UIButton *addImgBtn;
@property (nonatomic,weak) UIButton *attendBtn;

@property (weak,nonatomic) UIView *bgView;


@property (weak,nonatomic) UIImageView *imgView;
@property (weak,nonatomic)  PlaceholderTextView *textView;

@property (strong,nonatomic)  MPBaseViewController *selfVc;
- (void)deleteImage;
- (void)PostEnable;
@end
