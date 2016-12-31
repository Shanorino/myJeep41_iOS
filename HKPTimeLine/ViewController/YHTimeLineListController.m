//
//  YHQAListController.m
//  github:  https://github.com/samuelandkevin
//
//  Created by samuelandkevin on 16/8/29.
//  Copyright © 2016年 HKP. All rights reserved.
//

#import "YHTimeLineListController.h"
#import "CellForWorkGroup.h"
#import "CellForWorkGroupRepost.h"
#import "YHRefreshTableView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "YHWorkGroup.h"
#import "YHUserInfoManager.h"
#import "YHUtils.h"
#import "YHSharePresentView.h"
#import "UIViewController+MMDrawerController.h"
#import <MMDrawerBarButtonItem.h>

@interface YHTimeLineListController ()<UITableViewDelegate,UITableViewDataSource,CellForWorkGroupDelegate,CellForWorkGroupRepostDelegate>{
    int _currentRequestPage; //当前请求页面
    BOOL _reCalculate;
}



@property (nonatomic,strong) YHRefreshTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation YHTimeLineListController


- (void)viewDidLoad{
    [self initUI];
    [self requestDataLoadNew:YES];
    self.navigationItem.leftBarButtonItem = [[MMDrawerBarButtonItem alloc]initWithTarget:self action:@selector(leftBtn)];
    //设置UserId 
    [YHUserInfoManager sharedInstance].userInfo.uid = @"1";
}
-(void)leftBtn{
    //这里的话是通过遍历循环拿到之前在AppDelegate中声明的那个MMDrawerController属性，然后判断是否为打开状态，如果是就关闭，否就是打开(初略解释，里面还有一些条件)
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (void)initUI{
    
    self.title = @"myJeep41";
    
    //设置导航栏背景颜色
    UIColor * color = [UIColor colorWithRed:0.f green:191.f / 255 blue:143.f / 255 alpha:1];
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.translucent = NO;
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor colorWithWhite:0.871 alpha:1.000];
    shadow.shadowOffset = CGSizeMake(0.5, 0.5);

    //设置导航栏标题颜色
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18],NSShadowAttributeName:shadow};
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    
    
    
    self.tableView = [[YHRefreshTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGBCOLOR(244, 244, 244);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    [self.tableView setEnableLoadNew:YES];
    [self.tableView setEnableLoadMore:YES];
    
    self.view.backgroundColor = RGBCOLOR(244, 244, 244);
    
    [self.tableView registerClass:[CellForWorkGroup class] forCellReuseIdentifier:NSStringFromClass([CellForWorkGroup class])];
    [self.tableView registerClass:[CellForWorkGroupRepost class] forCellReuseIdentifier:NSStringFromClass([CellForWorkGroupRepost class])];
}


#pragma mark - Lazy Load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    //原创cell
    Class currentClass  = [CellForWorkGroup class];
    YHWorkGroup *model  = self.dataArray[indexPath.row];
    
    //转发cell
    if (model.type == DynType_Forward) {
        currentClass = [CellForWorkGroupRepost class];//第一版没有转发,因此这样稍该一下
    }
    cell  = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    
    CellForWorkGroup  *cell1 = nil;//原创
    CellForWorkGroupRepost *cell2 = nil;//转发
    /*******原创Cell*******/
    if ([cell isMemberOfClass:[CellForWorkGroup class]]) {
        cell1 = (CellForWorkGroup *)cell;
        cell1.indexPath = indexPath;
        cell1.model = model;
        cell1.delegate = self;
        return cell1;
        
    }else{
        /*****转发cell******/
        cell2 = (CellForWorkGroupRepost *)cell;
        cell2.indexPath = indexPath;
        cell2.model = model;
        cell2.delegate = self;
        return cell2;
    }
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    if (indexPath.row < self.dataArray.count) {
        
        //原创cell
        Class currentClass  = [CellForWorkGroup class];
        YHWorkGroup *model  = self.dataArray[indexPath.row];
        
        //转发cell
        if (model.type == DynType_Forward) {
            currentClass = [CellForWorkGroupRepost class];//第一版没有转发,因此这样稍该一下
            return [self.tableView fd_heightForCellWithIdentifier:@"CellForWorkGroupRepost" configuration:^(CellForWorkGroupRepost *cell) {
                [self configureRepostCell:cell atIndexPath:indexPath];
            }];
        }
        else{
            return [self.tableView fd_heightForCellWithIdentifier:@"CellForWorkGroup" configuration:^(CellForWorkGroup *cell) {
                [self configureOriCell:cell atIndexPath:indexPath];
            }];
           
        }
    }
    else{
        return 44.0f;
    }
}

- (void)configureOriCell:(CellForWorkGroup *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    if (indexPath.row < _dataArray.count) {
        cell.model = _dataArray[indexPath.row];
    }
    
}

- (void)configureRepostCell:(CellForWorkGroupRepost *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    if (indexPath.row < _dataArray.count) {
        cell.model = _dataArray[indexPath.row];
    }
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YHWorkGroup * selModel = _dataArray[indexPath.row];
    
    [self.navigationController pushViewController:[[JeepArticleDetailViewViewController alloc] initWithModel:selModel] animated:YES];
}

#pragma mark - 网络请求
- (void)requestDataLoadNew:(BOOL)loadNew{
    YHRefreshType refreshType;
    if (loadNew) {
        _currentRequestPage = 0;
        refreshType = YHRefreshType_LoadNew;
        [self.tableView setNoMoreData:NO];
    }
    else{
        _currentRequestPage ++;
        refreshType = YHRefreshType_LoadMore;
    }

    [self.tableView loadBegin:refreshType];
   
//    int totalCount = 10;
//    for (int i=0; i<totalCount; i++) {
//        YHWorkGroup *model = [YHWorkGroup new];
//        [self randomModel:model totalCount:totalCount];
//        [self.dataArray addObject:model];
//    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        id data = [self requestDataFromServer:_currentRequestPage];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            if (loadNew) {
                [self.dataArray removeAllObjects];
            }
            [_dataArray addObjectsFromArray:data];
            [self.tableView loadFinish:refreshType];
            [self.tableView reloadData];
        });
    });    
}
#pragma mark - 请求数据 解析JSON
- (id) requestDataFromServer:(int) pageIndex {
    // 请求数据
    NSString *jsonData = [self postSyn:[NSString stringWithFormat:@"http://www.jokerface.top/AppJeepServer/blog/%d",pageIndex]];

    //解析
    NSError *error = nil;
    NSMutableArray *dict = [NSJSONSerialization JSONObjectWithData:[jsonData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    NSMutableArray * models = [NSMutableArray array];
    for(NSDictionary *art in dict){
        YHWorkGroup *model = [YHWorkGroup new];
        model.type = DynType_Original;
        model.userInfo = [YHUserInfo new];
        model.userInfo.avatarUrl = [NSURL URLWithString:[art objectForKey:@"brand"]];
        model.userInfo.userName = [art objectForKey:@"title"];
        model.userInfo.industry = [art objectForKey:@"comment"];
        model.msgContent = [art objectForKey:@"desc"];
        model.userInfo.uid = [art objectForKey:@"id"];
        model.publishTime = [art objectForKey:@"pageIndex"];
        [models addObject:model];
    }
    return models;
}


#pragma mark - 模拟产生数据源
- (void)randomModel:(YHWorkGroup *)model totalCount:(int)totalCount{
    
    //model.type = arc4random()%totalCount %2? DynType_Forward:DynType_Original;
    model.type = DynType_Original;
    if (model.type == DynType_Forward) {
        model.forwardModel = [YHWorkGroup new];
        [self creatOriModel:model.forwardModel totalCount:totalCount];
    }
    [self creatOriModel:model totalCount:totalCount];
    
}

- (void)creatOriModel:(YHWorkGroup *)model totalCount:(int)totalCount{
    YHUserInfo *userInfo = [YHUserInfo new];
    model.userInfo = userInfo;
  
    
    NSArray *avtarArray = @[
@"https://testapp.gtax.cn/images/2016/08/25/2241c4b32b8445da87532d6044888f3d.jpg",
@"https://testapp.gtax.cn/images/2016/08/25/ea6a22e8b4794b9ba63fd6ee587be4d1.jpg",
@"https://testapp.gtax.cn/images/2016/09/30/ad0d18a937b248f88d29c2f259c14b5e.jpg!m90x90.jpg",
@"https://testapp.gtax.cn/images/2016/08/25/5cd8aa1f1b1f4b2db25c51410f473e60.jpg",
@"http://testapp.gtax.cn/images/2016/11/14/8d4ee23d9f5243f98c79b9ce0c699bd9.png!m90x90.png",
@"https://testapp.gtax.cn/images/2016/08/25/5cd8aa1f1b1f4b2db25c51410f473e60.jpg"];
    int avtarIndex = arc4random() % avtarArray.count;
    if (avtarIndex < avtarArray.count) {
        model.userInfo.avatarUrl = [NSURL URLWithString:avtarArray[avtarIndex]];
    }
    
    
    CGFloat myIdLength = arc4random() % totalCount;
    int result = (int)myIdLength % 2;
    model.userInfo.uid = result ?   [YHUserInfoManager sharedInstance].userInfo.uid:@"2";
    
    CGFloat nLength = arc4random() % 3 + 1;
    NSMutableString *nStr = [NSMutableString new];
    for (int i = 0; i < nLength; i++) {
        [nStr appendString: @"测试名字"];
    }
    model.userInfo.userName = nStr;
    
    CGFloat iLength = arc4random() % 3 + 1;
    NSMutableString *iStr = [NSMutableString new];
    for (int i = 0; i < iLength; i++) {
        [iStr appendString: @"测试行业"];
    }
    model.userInfo.industry = iStr;
    
    
    CGFloat cLength = arc4random() % 8 + 1;
    NSMutableString *cStr = [NSMutableString new];
    for (int i = 0; i < cLength; i++) {
        [cStr appendString: @"测试公司"];
    }
    model.userInfo.company  = cStr;
    
    
    CGFloat jLength = arc4random() % 8 + 1;
    NSMutableString *jStr = [NSMutableString new];
    for (int i = 0; i < jLength; i++) {
        [jStr appendString: @"随机职位"];
    }
    model.userInfo.job = jStr;
    
    CGFloat qlength = arc4random() % totalCount + 5;
    NSMutableString *qStr = [[NSMutableString alloc] init];
    for (NSUInteger i = 0; i < qlength; ++i) {
        [qStr appendString:@"测试数据很长，测试数据很长."];
    }
    model.msgContent = qStr;
    model.publishTime = @"2013-04-17";
    
    
    CGFloat picLength = arc4random() % 9;

    //原图
    NSArray *oriPName = @[
@"https://testapp.gtax.cn/images/2016/08/25/2241c4b32b8445da87532d6044888f3d.jpg",
    
@"https://testapp.gtax.cn/images/2016/08/25/0abd8670e96e4357961fab47ba3a1652.jpg",
    
@"https://testapp.gtax.cn/images/2016/08/25/5cd8aa1f1b1f4b2db25c51410f473e60.jpg",
    
@"https://testapp.gtax.cn/images/2016/08/25/5e8b978854ef4a028d284f6ddc7512e0.jpg",
    
@"https://testapp.gtax.cn/images/2016/08/25/03c58da45900428796fafcb3d77b6fad.jpg",
    
@"https://testapp.gtax.cn/images/2016/08/25/dbee521788da494683ef336432028d48.jpg",
    
@"https://testapp.gtax.cn/images/2016/08/25/4cd95742b6744114ac8fa41a72f83257.jpg",
    
@"https://testapp.gtax.cn/images/2016/08/25/4d49888355a941cab921c9f1ad118721.jpg",
    
@"https://testapp.gtax.cn/images/2016/08/25/ea6a22e8b4794b9ba63fd6ee587be4d1.jpg"];
    
    NSMutableArray *oriPArr = [NSMutableArray new];
    for (NSString *pName in oriPName) {
        [oriPArr addObject:[NSURL URLWithString:pName]];
    }
    
    //小图
    NSArray *thumbPName = @[
                             @"https://testapp.gtax.cn/images/2016/08/25/2241c4b32b8445da87532d6044888f3d.jpg!t300x300.jpg",
                             
                             @"https://testapp.gtax.cn/images/2016/08/25/0abd8670e96e4357961fab47ba3a1652.jpg!t300x300.jpg",
                             
                             @"https://testapp.gtax.cn/images/2016/08/25/5cd8aa1f1b1f4b2db25c51410f473e60.jpg!t300x300.jpg",
                             
                             @"https://testapp.gtax.cn/images/2016/08/25/5e8b978854ef4a028d284f6ddc7512e0.jpg!t300x300.jpg",
                             
                             @"https://testapp.gtax.cn/images/2016/08/25/03c58da45900428796fafcb3d77b6fad.jpg!t300x300.jpg",
                             
                             @"https://testapp.gtax.cn/images/2016/08/25/dbee521788da494683ef336432028d48.jpg!t300x300.jpg",
                             
                             @"https://testapp.gtax.cn/images/2016/08/25/4cd95742b6744114ac8fa41a72f83257.jpg!t300x300.jpg",
                             
                             @"https://testapp.gtax.cn/images/2016/08/25/4d49888355a941cab921c9f1ad118721.jpg!t300x300.jpg",
                             
                             @"https://testapp.gtax.cn/images/2016/08/25/ea6a22e8b4794b9ba63fd6ee587be4d1.jpg!t300x300.jpg"];
    
    NSMutableArray *thumbPArr = [NSMutableArray new];
    for (NSString *pName in thumbPName) {
        [thumbPArr addObject:[NSURL URLWithString:pName]];
    }

    model.originalPicUrls = [oriPArr subarrayWithRange:NSMakeRange(0, picLength)];
    model.thumbnailPicUrls = [thumbPArr subarrayWithRange:NSMakeRange(0, picLength)];
    
    [self postSyn:@"http://www.jokerface.top/AppJeepServer/blog/0"];
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
    [self requestDataLoadNew:YES];
}

- (void)refreshTableViewLoadmore:(YHRefreshTableView*)view{
    [self requestDataLoadNew:NO];
}


#pragma mark - CellForWorkGroupDelegate
- (void)onAvatarInCell:(CellForWorkGroup *)cell{

}

- (void)onMoreInCell:(CellForWorkGroup *)cell{
    DDLog(@"查看详情");
    if (cell.indexPath.row < [self.dataArray count]) {
        YHWorkGroup *model = self.dataArray[cell.indexPath.row];
        model.isOpening = !model.isOpening;
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

}

- (void)onCommentInCell:(CellForWorkGroup *)cell{

}

- (void)onLikeInCell:(CellForWorkGroup *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        YHWorkGroup *model = self.dataArray[cell.indexPath.row];
        
        BOOL isLike = !model.isLike;
        
        model.isLike = isLike;
        if (isLike) {
            model.likeCount += 1;
            
        }else{
            model.likeCount -= 1;
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }

}

- (void)onShareInCell:(CellForWorkGroup *)cell{
    if (cell.indexPath.row < [self.dataArray count]){
        [self _shareWithCell:cell];
    }
}


- (void)onDeleteInCell:(CellForWorkGroup *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        [self _deleteDynAtIndexPath:cell.indexPath dynamicId:cell.model.dynamicId];
    }
}

#pragma mark - CellForWorkGroupRepostDelegate

- (void)onAvatarInRepostCell:(CellForWorkGroupRepost *)cell{

}


- (void)onTapRepostViewInCell:(CellForWorkGroupRepost *)cell{
}

- (void)onCommentInRepostCell:(CellForWorkGroupRepost *)cell{
}

- (void)onLikeInRepostCell:(CellForWorkGroupRepost *)cell{
    
    if (cell.indexPath.row < [self.dataArray count]) {
        YHWorkGroup *model = self.dataArray[cell.indexPath.row];
        
        BOOL isLike = !model.isLike;
        //更新本地数据源
        model.isLike = isLike;
        if (isLike) {
            model.likeCount += 1;
            
        }else{
            model.likeCount -= 1;
        }
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }

    
}

- (void)onShareInRepostCell:(CellForWorkGroupRepost *)cell{
    
    if (cell.indexPath.row < [self.dataArray count]){
        [self _shareWithCell:cell];
    }
}

- (void)onDeleteInRepostCell:(CellForWorkGroupRepost *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        [self _deleteDynAtIndexPath:cell.indexPath dynamicId:cell.model.dynamicId];
    }
}

- (void)onMoreInRespostCell:(CellForWorkGroupRepost *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        YHWorkGroup *model = self.dataArray[cell.indexPath.row];
        model.isOpening = !model.isOpening;
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - private
- (void)_deleteDynAtIndexPath:(NSIndexPath *)indexPath dynamicId:(NSString *)dynamicId{
    
    WeakSelf
    [YHUtils showAlertWithTitle:@"删除动态" message:@"您确定要删除此动态?" okTitle:@"确定" cancelTitle:@"取消" inViewController:self dismiss:^(BOOL resultYes) {
        
        if (resultYes)
        {

            DDLog(@"delete row is %ld",(long)indexPath.row);
                    
            [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
     
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
   
        }
    }];
    
}

- (void)_shareWithCell:(UITableViewCell *)cell{
    
    CellForWorkGroup *cellOri     = nil;
    CellForWorkGroupRepost *cellRepost = nil;
    BOOL isRepost = NO;
    if ([cell isKindOfClass:[CellForWorkGroup class]]) {
        cellOri = (CellForWorkGroup *)cell;
    }
    else if ([cell isKindOfClass:[CellForWorkGroupRepost class]]) {
        cellRepost = (CellForWorkGroupRepost *)cell;
        isRepost   = YES;
    }
    else
        return;
    
    
    YHWorkGroup *model = [YHWorkGroup new];
    if (isRepost) {
        model = cellRepost.model.forwardModel;
    }
    else{
        model = cellOri.model;
    }
    
    YHSharePresentView *shareView = [[YHSharePresentView alloc] init];
    shareView.shareType = ShareType_WorkGroup;
    [shareView show];
    [shareView dismissHandler:^(BOOL isCanceled, NSInteger index) {
        if (!isCanceled) {
            switch (index)
            {
                case 2:
                {
                    DDLog(@"动态");
                }
                    break;
                case 3:
                {

                }
                    break;
                    
                case 0:
                {
                    //朋友圈
                    DDLog(@"朋友圈");
                    
                }
                    break;
                case 1:
                {
                    //微信好友
                    DDLog(@"微信好友");
                   
                }
                    break;
                default:
                    break;
            }
            
        }
    }];
    
    
    
}


#pragma mark - UIScrollViewDelegate


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
