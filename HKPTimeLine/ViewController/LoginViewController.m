//
//  LoginViewController.m
//  HKPTimeLine
//
//  Created by jokerking on 17/1/8.
//  Copyright © 2017年 YHSoft. All rights reserved.
//

#import "LoginViewController.h"
#import "WSLoginView.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void) setupUI{
    WSLoginView *loginView = [[WSLoginView alloc] initWithFrame:self.view.bounds];
    loginView.titleLabel.text = @"Login";
    [self.view addSubview:loginView];
    [loginView setClickBlock:^(NSString *textField1Text, NSString *textField2Text) {
        
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"登陆按钮" message:[NSString stringWithFormat:@"%@,%@",textField1Text,textField2Text] delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
        [alertV show];
        
    }];
}


#pragma mark -   登陆验证
- (void)loginCheck:(NSString*)name password:(NSString*)password {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新
            
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
#pragma mark - 

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
