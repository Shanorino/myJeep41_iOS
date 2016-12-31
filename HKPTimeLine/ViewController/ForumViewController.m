//
//  ForumViewController.m
//  HKPTimeLine
//
//  Created by jokerking on 16/12/27.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "ForumViewController.h"
#import "YHRefreshTableView.h"


@interface ForumViewController() <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) YHRefreshTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation ForumViewController

#pragma mark - Lazy Load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backToListView:)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    [self requestDataLoadNew];
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
    
    self.tableView = [[YHRefreshTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
    return [[[_dataArray objectAtIndex:section] objectForKey:@"subforum"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if([_dataArray count] == 0){
        return  @"";
    }
    return [[_dataArray objectAtIndex:section] objectForKey:@"groupname"];
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
    cell.textLabel.text = [[[[_dataArray objectAtIndex: indexPath.section] objectForKey:@"subforum"] objectAtIndex:indexPath.row] objectForKey:@"forumname"];
    cell.detailTextLabel.text = [[[[_dataArray objectAtIndex: indexPath.section] objectForKey:@"subforum"] objectAtIndex:indexPath.row] objectForKey:@"forumname"];
    [cell.imageView setImage:[UIImage imageNamed:@"forumicon.png"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([_dataArray count] == 0){
        return  0;
    }
    return [_dataArray count];//返回标题数组中元素的个数来确定分区的个数
}

#pragma mark - 网络请求
- (void)requestDataLoadNew{
    YHRefreshType refreshType;
    refreshType = YHRefreshType_LoadNew;
    [self.tableView setNoMoreData:NO];
    [self.tableView loadBegin:refreshType];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        id data = [self requestDataFromServer];
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
- (id) requestDataFromServer {
    // 请求数据
    NSString *jsonData = [self postSyn:[NSString stringWithFormat:@"http://www.myjeep41.com/forum_init.php"]];
    
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
    [self requestDataLoadNew];
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
