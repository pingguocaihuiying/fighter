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

@interface FTManagerAccountViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation FTManagerAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //添加监听器，监听login
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showWeiXinNameAndHeader) name:WXLoginResultNoti object:nil];
    
    [self initSubviews];
}


- (void) viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
    
}

- (void) initSubviews {
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 35, 35);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回pre"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FTTableViewCell5" bundle:nil] forCellReuseIdentifier:@"cellId"];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor colorWithHex:0x505050];
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

- (void) showWeiXinNameAndHeader {
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NetWorking *net = [[NetWorking alloc]init];
    [net updateUserWithValue:localUser.wxopenId Key:@"openId" option:^(NSDictionary *dict) {
        NSLog(@"dict:%@",dict);
        if (dict != nil) {
            
            bool status = [dict[@"status"] boolValue];
            NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            
            if (status == true) {
                
                [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                NSDictionary *userDataDic = dict[@"data"];
                NSDictionary *userDic = userDataDic[@"user"];
                
                FTUserBean *user = [FTUserBean new];
                [user setValuesForKeysWithDictionary:userDic];
                
                //将用户信息保存在本地
                NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
                [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"loginUser"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self.tableView reloadData];
                FTWeixinInfoVC *wxVC = [[FTWeixinInfoVC alloc]init];
                //    wxVC.headerUrl = localUser.wxHeaderPic;
                //    wxVC.username = localUser.wxName;
                wxVC.title = @"绑定微信";
                [self.navigationController pushViewController:wxVC animated:YES];
            }else {
                NSLog(@"message : %@", [dict[@"message"] class]);
                [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
            }
        }else {
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@" 微信登录失败"];
            
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
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"微信账号：";
        
        if (localUser.openId.length > 0) { //微信登录
            cell.remarkLabel.text = localUser.username;
        }else if (localUser.wxopenId.length > 0) { //手机登录
            cell.remarkLabel.text = localUser.wxName;
        }else {
            cell.remarkLabel.text = @"未绑定";
        }
        
    }if (indexPath.row == 1) {
        cell.titleLabel.text = @"手机绑定：";
        if (localUser.tel.length > 0) {
            cell.remarkLabel.text = localUser.tel;
        }else {
            cell.remarkLabel.text = @"未绑定";
        }
    }if (indexPath.row == 2) {
        if(localUser.openId.length > 0){
            cell.titleLabel.text = @"设置密码：";
        }else {
        
            cell.titleLabel.text = @"更改密码：";
        }
       
    }
    
    return cell;
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    if (indexPath.row == 0) {
        
        if(localUser.wxopenId.length >0) {
            FTWeixinInfoVC *wxVC = [[FTWeixinInfoVC alloc]init];
            wxVC.title = @"绑定微信";
            [self.navigationController pushViewController:wxVC animated:YES];
            
        }else {//手机登录未绑定微信, 用微信登录绑定微信
            
            NetWorking *net = [[NetWorking alloc]init];
            [net weixinRequest];
            
        }
        
    }else  if (indexPath.row == 1) {
        FTPhoneViewController * changePhoneVC = [[FTPhoneViewController alloc]init];
        changePhoneVC.title = @"更改绑定手机";
        [self.navigationController pushViewController:changePhoneVC animated:YES];
    }
    else  if (indexPath.row == 2) {
        
        NetWorking *net= [[NetWorking alloc]init];
        [net isBindingPhoneNum:^(NSDictionary *dict) {
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
