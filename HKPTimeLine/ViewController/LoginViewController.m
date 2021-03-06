//
//  LoginViewController.m
//  HKPTimeLine
//
//  Created by jokerking on 17/1/8.
//  Copyright © 2017年 YHSoft. All rights reserved.
//

#import "LoginViewController.h"
#import "WSLoginView.h"
#import "AppDelegate.h"

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
    loginView.titleLabel.text = NSLocalizedString(@"Login", nil);
    [self.view addSubview:loginView];
    [loginView setClickBlock:^(NSString *textField1Text, NSString *textField2Text) {
        [self loginCheck:textField1Text password:textField2Text];
        
    }];
}


#pragma mark -   登陆验证
- (void)loginCheck:(NSString*)name password:(NSString*)password {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        id data = [self requestDataFromServer:name password:password];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新
            if(data==nil){
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login", nil) message:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Login_Wrong_Pass", nil)] delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
                [alertV show];
            }
            else{
                //本次用户作为全局变量
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.globaluserid = [data[0] objectForKey:@"userid"];
                appDelegate.globalusername = [data[0] objectForKey:@"displayname"];
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login", nil) message:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Login_Success", nil)] delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
                [alertV show];
                //记住我
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:appDelegate.globaluserid forKey:@"saveduserid"];
                [defaults setObject:appDelegate.globalusername forKey:@"savedusername"];
                //关闭登陆view 并刷新边栏
                [self.navigationController popViewControllerAnimated:true];
            }
        });
    });
}

#pragma mark - 请求数据 解析JSON
- (id) requestDataFromServer:(NSString*)username password:(NSString*)password {
    // 请求数据
    NSString *jsonData = [self postSyn:[NSString stringWithFormat:@"http://www.myjeep41.com/login_authentication.php"] usn:username psw:password];
    
    //解析
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[jsonData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    id val=[dict objectForKey:@"result"];
    if(error)
    {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    else
        return val;
}
//同步post
-(NSString *)postSyn:(NSString *)urlStr usn:(NSString *)username psw:(NSString *)password{
    NSLog(@"post_begin");
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:urlStr]]; //设置地址
    [request setHTTPMethod:@"POST"]; //设置发送方式
    [request setTimeoutInterval: 20]; //设置连接超时
    //设置请求体
    NSString *param=[NSString stringWithFormat:@"username=%@&password=%@",username,password];
    //把拼接后的字符串转换为data，设置请求体
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
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
