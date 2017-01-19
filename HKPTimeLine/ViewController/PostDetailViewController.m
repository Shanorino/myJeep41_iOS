//
//  PostDetailViewController.m
//  HKPTimeLine
//
//  Created by jokerking on 17/1/8.
//  Copyright © 2017年 YHSoft. All rights reserved.
//

#import "PostDetailViewController.h"
#import "YHRefreshTableView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UIViewController+MMDrawerController.h"
#import "CellForTopic.h"
#import "CellForTopicFollow.h"
#import "MPDetailBottomView1.h"
#import "MPOpenReplyViewController.h"
#import "AppDelegate.h"
#define BOTTOMVIEWHEIGHT_MPHomeDetailVC 120

@interface PostDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) YHRefreshTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation PostDetailViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self requestDataLoadNew:_topicId];
    [self initFootView];
    // Do any additional setup after loading the view.
}

// init ui
- (void)setupUI{
    //self.title = @"Topic Title";  若标题太长反而丑，因此多余了
    
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
    

    self.tableView = [[YHRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-102) style:UITableViewStylePlain];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    [self.tableView setEnableLoadNew:YES];
    [self.tableView setEnableLoadMore:YES];
    
    self.tableView.backgroundColor = RGBCOLOR(244, 244, 244);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    [self.view addSubview: _tableView];
    [self.tableView registerClass:[CellForTopic class] forCellReuseIdentifier:NSStringFromClass([CellForTopic class])];
    [self.tableView registerClass:[CellForTopicFollow class] forCellReuseIdentifier:NSStringFromClass([CellForTopicFollow class])];
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
    
    UITableViewCell *cell;
    
    Class currentClass  = [CellForTopic class];
    NSDictionary *model  = self.dataArray[indexPath.row];
    
    if(indexPath.row == 0){
        cell  = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
        CellForTopic  *cell1 = nil;//楼主
        cell1 = (CellForTopic *)cell;
        cell1.indexPath = indexPath;
        cell1.model = model;
        return cell1;
    }
    else{
        currentClass = [CellForTopicFollow class];
        cell  = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
        CellForTopicFollow  *cell1 = nil;//跟帖
        cell1 = (CellForTopicFollow *)cell;
        cell1.indexPath = indexPath;
        cell1.model = model;
        return cell1;
    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //UIViewController *view = nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row < self.dataArray.count) {
        if(indexPath.row == 0){
            return [self.tableView fd_heightForCellWithIdentifier:@"CellForTopic" configuration:^(CellForTopic *cell) {
                [self configureOriCell:cell atIndexPath:indexPath];
                }];
        }
        else{
            return [self.tableView fd_heightForCellWithIdentifier:@"CellForTopicFollow" configuration:^(CellForTopicFollow *cell) {
                [self configureOriCell:cell atIndexPath:indexPath];
            }];
        }
    }
    else{
        return 20.0f;
    }
}

- (void)configureOriCell:(CellForTopic *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    if (indexPath.row < _dataArray.count) {
        cell.model = _dataArray[indexPath.row];
    }
    
}

- (void)configureOriFollowCell:(CellForTopicFollow *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    if (indexPath.row < _dataArray.count) {
        cell.model = _dataArray[indexPath.row];
    }
    
}


#pragma mark - 网络请求
- (void)requestDataLoadNew:(NSString *)topicId {
    YHRefreshType refreshType;
    refreshType = YHRefreshType_LoadNew;
    [self.tableView setNoMoreData:NO];
    [self.tableView loadBegin:refreshType];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        id data = [self requestDataFromServer:topicId];
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
- (id) requestDataFromServer:(NSString *) topicId {
    // 请求数据
    NSString *jsonData = [self postSyn:[NSString stringWithFormat:@"http://www.myjeep41.com/readpost_init.php?topicid=%@",topicId]];
    
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
    [self requestDataLoadNew:_topicId];
}

- (void)refreshTableViewLoadmore:(YHRefreshTableView*)view{
    [self requestDataLoadNew:_topicId];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - initFootView

- (void)initFootView
{
    MPDetailBottomView1 *bottomVi = [[MPDetailBottomView1 alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-BOTTOMVIEWHEIGHT_MPHomeDetailVC, self.view.frame.size.width, 60)];
    [self.view addSubview:bottomVi];
    
    UITapGestureRecognizer *tap33 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inReplyView)];
    [bottomVi addGestureRecognizer:tap33];
}
- (void)inReplyView{
    //若未登陆则提示先登陆再回复
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"--replyUsr--%@---%@-",appDelegate.globalusername,appDelegate.globaluserid);
    if(appDelegate.globalusername.length>0 && ![appDelegate.globalusername isEqual:@"null"])
    {
        MPOpenReplyViewController *vc = [[MPOpenReplyViewController alloc]init];
        vc.bgImg = [self screenShot];
        vc.topicid=_topicId;
        [self presentViewController:vc animated:NO completion:nil];
    }
    else
        [[[UIAlertView alloc] initWithTitle:@"登陆按钮" message:[NSString stringWithFormat:@"%@",@"Please Log In First"] delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil, nil] show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:TRUE];
    [self requestDataLoadNew:_topicId];
    //NSLog(@"从发帖框返回");
}
@end
