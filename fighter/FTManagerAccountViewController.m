//
//  FTManagerAccountViewController.m
//  fighter
//
//  Created by kang on 16/5/9.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTManagerAccountViewController.h"
#import "FTTableViewCell5.h"
#import "FTPhoneViewController.h"
#import "FTOldPasswordVC.h"
#import "FTWeixinInfoVC.h"
#import "NetWorking.h"
#import "UIWindow+MBProgressHUD.h"
#import "FTInputNewPhoneViewController.h"

@interface FTManagerAccountViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation FTManagerAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //注册通知，接收登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bandingWeixinCallBack:) name:WeiXinNameAndHeader object:nil];
    
    [self initSubviews];
}


- (void) viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
    
}

- (void) initSubviews {
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 22, 22);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回pre"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FTTableViewCell5" bundle:nil] forCellReuseIdentifier:@"cellId"];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = Cell_Space_Color;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //关闭scrollView默认留白
    self.automaticallyAdjustsScrollViewInsets = false;
    
}




#pragma mark - response

- (void) backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showLoginedViewData {
    [self.tableView reloadData];
    
}

// 绑定微信响应
- (void) bandingWeixinCallBack:(NSNotification *)noti {
    
//    NSString *wxOpenId = [[NSUserDefaults standardUserDefaults]objectForKey:@"wxopenId"];
//    NSString *wxName = [[NSUserDefaults standardUserDefaults]objectForKey:@"wxName"];
//    NSString *wxHeaderPic = [[NSUserDefaults standardUserDefaults]objectForKey:@"wxHeaderPic"];
    NSDictionary *userDict = noti.userInfo;
    NSString *wxOpenId = userDict[@"openid"];
    NSString *wxHeaderPic = userDict[@"headimgurl"];
    NSString *wxName = userDict[@"nickname"];
    NSString *unionId = userDict[@"unionid"];
    
    [NetWorking bindingWeixin:userDict  option:^(NSDictionary *dict) {
        NSLog(@"dict:%@",dict);
        if (dict != nil) {
            
            bool status = [dict[@"status"] boolValue];
            NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            
            if (status == true) {
                
                [[UIApplication sharedApplication].keyWindow showMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                FTUserBean *loginUser = [FTUserBean loginUser];
                //更新本地数据
                loginUser.openId = wxOpenId;
                loginUser.wxopenId = wxOpenId;
                loginUser.wxHeaderPic = wxHeaderPic;
                loginUser.wxName = wxName;
                loginUser.unionId = unionId;
                
                NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:loginUser];
                [[NSUserDefaults standardUserDefaults]setObject:userData forKey:LoginUser];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self.tableView reloadData];
                FTWeixinInfoVC *wxVC = [[FTWeixinInfoVC alloc]init];
                wxVC.title = @"绑定微信";
                [self.navigationController pushViewController:wxVC animated:YES];
                
            }else {
                NSLog(@"message : %@", [dict[@"message"] class]);
                [[UIApplication sharedApplication].keyWindow showMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }else {
            [[UIApplication sharedApplication].keyWindow showMessage:@" 绑定微信失败"];
        }
    }];
}


#pragma mark - tableView datasouce and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 46 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"cell for row");
    FTTableViewCell5 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    
    //从本地读取存储的用户信息
    FTUserBean *localUser = [FTUserBean loginUser];
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"微信账号：";
        if (localUser.openId.length > 0) { //微信登录
            if (localUser.wxName.length > 0) {
                cell.remarkLabel.text = localUser.wxName;
            }else {
                cell.remarkLabel.text = localUser.username;
            }
        }else {
            cell.remarkLabel.text = @"未绑定";
        }
        
    }if (indexPath.row == 1) {
        
        if (localUser.tel.length > 0) {
            cell.titleLabel.text = @"绑定手机";//更换手机 暂时不用
            cell.remarkLabel.text = localUser.tel;
        }else {
            cell.titleLabel.text = @"绑定手机：";
            cell.remarkLabel.text = @"未绑定";
        }
    }if (indexPath.row == 2) {
        
        cell.titleLabel.text = @"更改密码：";
    }
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //从本地读取存储的用户信息
    FTUserBean *localUser = [FTUserBean loginUser];
    
    if (indexPath.row == 0) {
        
        if(localUser.openId.length >0) {
            FTWeixinInfoVC *wxVC = [[FTWeixinInfoVC alloc]init];
            wxVC.title = @"绑定微信";
            [self.navigationController pushViewController:wxVC animated:YES];
            
        }else {//手机登录未绑定微信, 用微信登录绑定微信
            [WXSingleton shareInstance].wxRequestType = WXRequestTypeNameAndHeader;
            [NetWorking weixinRequest];
            
        }
        
    }else  if (indexPath.row == 1) {
        
        if(localUser.tel.length > 0) {
            
            /**********    暂时屏蔽    *************/
//            FTPhoneViewController * changePhoneVC = [[FTPhoneViewController alloc]init];
//            changePhoneVC.title = @"更改绑定手机";
//            [self.navigationController pushViewController:changePhoneVC animated:YES];
        }else {
            FTInputNewPhoneViewController *inputNewPhoneVC = [[FTInputNewPhoneViewController alloc]init];
            inputNewPhoneVC.title = @"绑定手机";
            inputNewPhoneVC.type = @"bindphone";
            [self.navigationController pushViewController:inputNewPhoneVC animated:YES];
            
        }
        
    }
    else  if (indexPath.row == 2) {
        
        [NetWorking isBindingPhoneNum:^(NSDictionary *dict) {
            NSLog(@"dict:%@",dict);
            if (dict != nil) {
                
                NSString *data = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                
                
                if ([data isEqualToString:@"用户已绑定手机"]) {
                    
                    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                    FTOldPasswordVC *oldPasswordVC = [[FTOldPasswordVC alloc]init];
                    oldPasswordVC.title = @"旧密码";
                    [self.navigationController pushViewController:oldPasswordVC animated:YES];
                }else {
                
                    NSLog(@"message : %@", [dict[@"message"] class]);
                    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                }
                
            }else {
                [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"网络错误"];
                
            }
        }];
    }
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
