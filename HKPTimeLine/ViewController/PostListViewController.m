//
//  PostListViewController.m
//  HKPTimeLine
//
//  Created by jokerking on 17/1/8.
//  Copyright © 2017年 YHSoft. All rights reserved.
//

#import "PostListViewController.h"
#import "YHRefreshTableView.h"
#import "PostDetailViewController.h"
#import "UIViewController+MMDrawerController.h"


@interface PostListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) YHRefreshTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end


@implementation PostListViewController

- (NSMutableArray *) dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backToListView:)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    [self requestDataLoadNew:_forumId];
    // Do any additional setup after loading the view.
}
-(void) backToListView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) initUI{
    self.title = @"Forum";
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
    
    self.tableView = [[YHRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-52) style:UITableViewStylePlain];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGBCOLOR(244, 244, 244);
    self.tableView.separatorStyle = UITableViewStyleGrouped;
    [self.view addSubview:self.tableView];
    
    [self.tableView setEnableLoadNew:YES];
    [self.tableView setEnableLoadMore:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([_dataArray count] == 0){
        return  0;
    }
    return [_dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    // 从缓存队列中取出复用的cell
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // 如果队列中cell为空，即无复用的cell，则对其进行初始化
    if (cell==nil) {
        // 初始化
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] ;
        // 定义其辅助样式
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [[_dataArray objectAtIndex: indexPath.row] objectForKey:@"topicname"];
    
    NSString *author = [[_dataArray objectAtIndex: indexPath.row] objectForKey:@"displayname"];
    NSString *click = [[_dataArray objectAtIndex: indexPath.row] objectForKey:@"topicopened"];
    NSString *repeat = [[_dataArray objectAtIndex: indexPath.row] objectForKey:@"postcount"];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@:%@  %@:%@  %@:%@",NSLocalizedString(@"Forum_List_Author", nil),author,NSLocalizedString(@"Forum_List_Views", nil),click,NSLocalizedString(@"Forum_List_Replies", nil),repeat];
    
    [cell.imageView setImage:[UIImage imageNamed:@"forumicon.png"]];
    return cell;
}

#pragma mark - UITableViewDelegate
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //UIViewController *view = nil;
    NSString* topicid=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"topicid"];
    
    PostDetailViewController *view = [[PostDetailViewController alloc] init];
    view.topicId = topicid;
    //拿到我们的LitterLCenterViewController，让它去push
    UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
    [nav pushViewController:view animated:NO];
    
}
#pragma mark - 网络请求
- (void)requestDataLoadNew:(NSString *)forumid{
    YHRefreshType refreshType;
    refreshType = YHRefreshType_LoadNew;
    [self.tableView setNoMoreData:NO];
    [self.tableView loadBegin:refreshType];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        id data = [self requestDataFromServer: forumid];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray: data];
            [self.tableView loadFinish:refreshType];
            [self.tableView reloadData];
        });
    });
}
#pragma mark - 请求数据 解析JSON
- (id) requestDataFromServer:(NSString *) forumId {
    // 请求数据
    NSString *jsonData = [self postSyn:[NSString stringWithFormat:@"http://www.myjeep41.com/postlist_init.php?forumid=%@",forumId]];
    
    //解析
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[jsonData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    
    return [dict objectForKey:@"result"];
}

//同步post
-(NSString *)postSyn:(NSString *)urlStr {
    NSLog(@"post_begin");
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:urlStr]]; //设置地址
    [request setHTTPMethod:@"GET"]; //设置发送方式
    [request setTimeoutInterval: 20]; //设置连接超时
    //发起连接，接受响应
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init] ;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&urlResponse
                                                             error:&error];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]; //返回数据，转码
    NSLog(@"post_end");
    return responseString;
}

#pragma mark - YHRefreshTableViewDelegate
- (void)refreshTableViewLoadNew:(YHRefreshTableView*)view{
    [self requestDataLoadNew:_forumId];
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
