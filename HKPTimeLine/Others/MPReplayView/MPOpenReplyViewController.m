//
//  MPOpenReplyViewController.m
//  kissfire
//
//  Created by Plum on 16/2/3.
//  Copyright © 2016年 manpaoTech. All rights reserved.
//

#import "MPOpenReplyViewController.h"
#import "CONST.h"
#import "AppDelegate.h"


@interface MPOpenReplyViewController ()
{
    BOOL isfirst;
    
    double duration;
}

@end

@implementation MPOpenReplyViewController
#pragma mark -
- (void)initNotionCenter
{
     [MPNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)dealloc
{
    [MPNotificationCenter removeObserver:self];
}
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isfirst = YES;
    
    [self initView];
    
    [self initToolView];

    
    [self initNotionCenter];

    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isfirst) {
        isfirst = NO;
        [_toolbar.textView becomeFirstResponder];
    }

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isfirst == NO) {
        [_toolbar.textView becomeFirstResponder];
    }
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
}

#pragma mark -
- (void)initView
{
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    bgView.image = _bgImg;
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    UIView *blackBgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    blackBgView.userInteractionEnabled = YES;
    blackBgView.backgroundColor = [UIColor blackColor];
    blackBgView.alpha = 0.0;
    [self.view addSubview:blackBgView];
    self.blackBgView = blackBgView;
    
    UITapGestureRecognizer *tap33 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBtnClick)];
    [blackBgView addGestureRecognizer:tap33];
}

- (void)closeBtnClick
{
    
    [_toolbar.textView resignFirstResponder];
    double delayTime;
    if (duration>0.0) {
        delayTime = duration;
    }else{
        delayTime = 0.25;

    }
    [self performSelector:@selector(delayDismiss) withObject:nil afterDelay:delayTime];
    
    
}
- (void)delayDismiss
{
    [self dismissViewControllerAnimated:NO completion:nil];

}
#pragma mark -
- (void)initToolView
{
    
    MPReplyToolBarView *toolView = [[MPReplyToolBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    toolView.selfVc = self;
    [self.view addSubview:toolView];
    self.toolbar = toolView;
    
      [_toolbar.attendBtn addTarget:self action:@selector(sendReply) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - 监听方法
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    //    if (self.picking) return;
    /**
     notification.userInfo = @{
     // 键盘弹出\隐藏后的frame
     UIKeyboardFrameEndUserInfoKey = NSRect: {{0, 352}, {320, 216}},
     // 键盘弹出\隐藏所耗费的时间
     UIKeyboardAnimationDurationUserInfoKey = 0.25,
     // 键盘弹出\隐藏动画的执行节奏（先快后慢，匀速）
     UIKeyboardAnimationCurveUserInfoKey = 7
     }
     */
    
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        
        _blackBgView.alpha = 0.410;

        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.toolbar.top = self.view.height - self.toolbar.height;//这里的<span style="background-color: rgb(240, 240, 240);">self.toolbar就是我的输入框。</span>
            
        } else {
            self.toolbar.top = keyboardF.origin.y - self.toolbar.height;
        }
    } completion:^(BOOL finished) {
        
    }];
   
    

}

#pragma mark -
- (void)sendReply
{
    
    NSString *str = _toolbar.textView.text;
    NSString *message = [NSString stringWithFormat:@"%@",str];
    UIImage *img = _toolbar.imgView.image;
    
    NSLog(@"--replyStr-%@----",message);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"--replyUsr--%@---%@-",appDelegate.globalusername,appDelegate.globaluserid);
    NSLog(@"--replyTopicID--%@---",_topicid);
    //提交回复的三个参数 message, globaluserid, _topicid 用POST方法提交即可
    [self closeBtnClick];
}

@end
