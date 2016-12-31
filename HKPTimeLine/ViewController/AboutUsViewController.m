//
//  AboutUsViewController.m
//  HKPTimeLine
//
//  Created by jokerking on 16/12/27.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backToListView:)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    [self initUI];
}

-(void) backToListView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) initUI{
    self.title = @"About";
    //设置导航栏背景颜色
    UIColor * color = [UIColor colorWithRed:241.f green:122.f / 255 blue:10.f / 255 alpha:1];
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.translucent = NO;
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor colorWithWhite:0.871 alpha:1.000];
    shadow.shadowOffset = CGSizeMake(0.5, 0.5);
    
    //设置导航栏标题颜色
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18],NSShadowAttributeName:shadow};
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    
    self.view.backgroundColor = RGBCOLOR(244, 244, 244);
    
    
    UIImageView *appImg = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"app_launch.png"]];
    appImg.frame = CGRectMake((self.view.bounds.size.width - appImg.bounds.size.width)/2,
                              100
                              , appImg.bounds.size.width, appImg.bounds.size.height);
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(0, appImg.frame.origin.y+appImg.bounds.size.height, self.view.bounds.size.width, 50)];
    version.text = @"myJeep41 v0.1";
    version.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:appImg];
    [self.view addSubview: version];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
