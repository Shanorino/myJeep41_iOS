//
//  MPBaseViewController.m
//  猫果
//
//  Created by manpao on 14-10-13.
//  Copyright (c) 2014年 manpaoTech. All rights reserved.
//

#import "MPBaseViewController.h"

#define base_navItemH 44

@interface MPBaseViewController ()

@end

@implementation MPBaseViewController

#pragma mark - 全屏 截图
/**
 *截图功能
 */
-(UIImage *)screenShot{
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(window.frame.size.width,window.frame.size.height), YES, 0);
    
    //设置截屏大小
    [[window layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  viewImage;
    
    
}
- (UIButton *)rl_BarBtnWithImageName:(NSString *)imgName
{
    UIButton *rightBarBtn = [self getButton];
    [rightBarBtn setImage:[UIImage imageNamed:imgName] forState:0];
    rightBarBtn.frame = CGRectMake(0,0, base_navItemH, base_navItemH);
    return rightBarBtn;
    
}

- (UIButton *)rl_BarBtnWithTitle:(NSString *)titleStr
{
    UIFont *titleFont = [UIFont systemFontOfSize:16];
    CGSize titleSize = [titleStr sizeWithFont:titleFont constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    
    UIButton *rightBarBtn = [self getButton];
    rightBarBtn.frame = CGRectMake(0, 0, titleSize.width, base_navItemH);
    [rightBarBtn setTitleColor:[UIColor blackColor] forState:0];
    [rightBarBtn setTitle:titleStr forState:0];
    [rightBarBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    rightBarBtn.titleLabel.font = titleFont;
    return rightBarBtn;
}
- (UIButton*)getButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    return button;
}
@end
