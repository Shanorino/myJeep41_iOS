//
//  MPBaseViewController.h
//  猫果
//
//  Created by manpao on 14-10-13.
//  Copyright (c) 2014年 manpaoTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPBaseViewController : UIViewController

/**
 *  全屏 截图
 */

-(UIImage *)screenShot;

- (UIButton *)rl_BarBtnWithImageName:(NSString *)imgName;
- (UIButton *)rl_BarBtnWithTitle:(NSString *)titleStr;
@end
