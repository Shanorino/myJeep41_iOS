//
//  JeepArticleDetailViewViewController.m
//  HKPTimeLine
//
//  Created by jokerking on 16/11/24.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "JeepArticleDetailViewViewController.h"
#import "WYWebProgressLayer.h"

@interface JeepArticleDetailViewViewController ()<UIWebViewDelegate>{
    UIWebView *webView;
    YHWorkGroup *article;
    WYWebProgressLayer *_progressLayer;
}

@end

@implementation JeepArticleDetailViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backToListView:)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    [self initUI];
}

-(void) backToListView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(id) initWithModel:(YHWorkGroup *)model{
    if(self = [super init]){
        article = model;
    }
    return self;
}

- (void) initUI{
    
    self.title =  @"myJeep41";
    
    //设置导航栏背景颜色
    UIColor * color = [UIColor colorWithRed:241.f green:122.f / 255 blue:10.f / 255 alpha:1];
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.translucent = NO;
    _progressLayer = [WYWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 10);
    
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    webView = [[UIWebView alloc] initWithFrame: self.view.bounds ];
    webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.jokerface.top/AppJeepServer/show/%@/%@",article.publishTime,article.userInfo.uid]]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebViewDelegate
/// 网页开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_progressLayer startLoad];
}

/// 网页完成加载
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_progressLayer finishedLoad];
}

/// 网页加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
}
#pragma mark 禁止webview中的链接点击
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    if(navigationType==UIWebViewNavigationTypeLinkClicked)//判断是否是点击链接
    {
        return NO;
    }
    else{return YES;}
}
- (void)dealloc {
    
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    NSLog(@"i am dealloc");
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
