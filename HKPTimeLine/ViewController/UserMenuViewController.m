//
//  UserMenuViewController.m
//  HKPTimeLine
//
//  Created by jokerking on 16/12/27.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "UserMenuViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "ForumViewController.h"
#import "AboutUsViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface UserMenuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation UserMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    if([self isLoggedin])
        [_dataArray addObject:NSLocalizedString(@"Menu_Logout", nil)];
    else
        [_dataArray addObject:NSLocalizedString(@"Menu_Login", nil)];
    [_dataArray addObject:NSLocalizedString(@"Menu_Forum", nil)];
    [_dataArray addObject:NSLocalizedString(@"Menu_About", nil)];
    
    [self initUI];
    
    
}

- (void) initUI {
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
    
    // 
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//判断是否已登陆
- (BOOL)isLoggedin {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *savedid = [NSString stringWithFormat:@"%@",appDelegate.globaluserid];
    //NSString *savedname=[NSString stringWithFormat:@"%@",appDelegate.globalusername];
    if(savedid.length>0 && ![savedid isEqual:@"(null)"])
        return true;
    else
        return false;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    // 从缓存队列中取出复用的cell
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // 如果队列中cell为空，即无复用的cell，则对其进行初始化
    if (cell==nil) {
        // 初始化
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        // 定义其辅助样式
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [_dataArray objectAtIndex: indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *view = nil;
    switch (indexPath.row) {
        case 0:
        {
            if([self isLoggedin]){
                //Do Log Out
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                [defaults removeObjectForKey:@"saveduserid"];
                [defaults removeObjectForKey:@"savedusername"];
                [defaults synchronize];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.globaluserid = nil;
                appDelegate.globalusername = nil;
                [self viewDidLoad];
            }
            else
                view = [[LoginViewController alloc] init];
            break;
        }
        case 1:
            view = [[ForumViewController alloc] init];
            break;
        case 2:
            view = [[AboutUsViewController alloc] init];
            break;
            
        default:
            break;
    }
    if(view!=nil){
        //当我们push成功之后，关闭我们的抽屉
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    	//拿到我们的LitterLCenterViewController，让它去push
        //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.mm_drawerController.centerViewController];
        UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:view animated:NO];
        
    }
    else{
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
        NSLog(@"Logged out,data cleared");
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [self viewDidLoad];
    NSLog(@"从登陆返回刷新抽屉菜单");
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
