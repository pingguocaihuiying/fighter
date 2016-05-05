//
//  UserCenterViewController.m
//  fighter
//
//  Created by kang on 16/5/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTUserCenterViewController.h"
#import "UIButton+WebCache.h"
#import "FTTableViewCell4.h"
#import "FTPropertySetingViewController.h"

@interface FTUserCenterViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation FTUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // Do any additional setup after loading the view from its nib.
    
    [self initSubviews];
}

- (void) initSubviews {
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 35, 35);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回pre"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    //设置按钮圆角
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    [self.avatarBtn.layer setMasksToBounds:YES];
    self.avatarBtn.layer.cornerRadius = 20.0;
    [self.avatarBtn  sd_setImageWithURL:[NSURL URLWithString:localUser.headpic]
                                            forState:UIControlStateNormal
                                    placeholderImage:[UIImage imageNamed:@"头像-空"]];
    
    
    //tableView 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor colorWithHex:0x505050];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - response 

- (void) backBtnAction:(id) sender {

    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45 ;
}

//-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return 0.5;
//}


//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UIView *header = [[UIView alloc]init];
//    header.backgroundColor = [UIColor colorWithHex:0x505050];
//    return header;
//}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets edgeInsets;
    if (indexPath.row == 5) {
         edgeInsets = UIEdgeInsetsMake(0, self.tableView.frame.size.width, 0, 0);
        
    }else {
        edgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:edgeInsets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:edgeInsets];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    FTTableViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
     FTTableViewCell4 *cell = [[[NSBundle mainBundle]loadNibNamed:@"FTTableViewCell4" owner:nil options:nil]firstObject];
    
//    if (cell) {
//        [cell.propertyContentLabel setTextColor:[UIColor colorWithHex:0xb4b4b4]];
//        
//        
////        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    
    if (indexPath.row == 0) {
        cell.UserPropertyLabel.text = @"姓名 ：";
        cell.propertyContentLabel.text = @"--";
        
    }else if (indexPath.row == 1) {
        cell.UserPropertyLabel.text = @"性别 ：";
        cell.propertyContentLabel.text = @"男";
        
    }else if (indexPath.row == 2) {
        cell.UserPropertyLabel.text = @"身高 ：";
        cell.propertyContentLabel.text = @"180cm";
        
    }else if (indexPath.row == 3) {
        cell.UserPropertyLabel.text = @"体重 ：";
        cell.propertyContentLabel.text = @"80kg";
       
    }else if (indexPath.row == 4) {
        cell.UserPropertyLabel.text = @"生日 ：";
        cell.propertyContentLabel.text = @"1990 - 12 - 10";
       
    }else if (indexPath.row == 5) {
        cell.UserPropertyLabel.text = @"所在地 ：";
        cell.propertyContentLabel.text = @"北京";
        
        
    }
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (localUser) {
        if (indexPath.row == 0) {
            if (localUser.username.length >0) {
                cell.propertyContentLabel.text = localUser.username;
            }
            
        }else if (indexPath.row == 1) {
            if (localUser.sex.length >0) {
                cell.propertyContentLabel.text = localUser.sex;
            }
        }else if (indexPath.row == 2) {
            if (localUser.height.length >0) {
                cell.propertyContentLabel.text = localUser.height;
            }
        }else if (indexPath.row == 3) {
            if (localUser.weight.length >0) {
                cell.propertyContentLabel.text = localUser.weight;
            }
            
        }else if (indexPath.row == 4) {
            if (localUser.birthday.length >0) {
                cell.propertyContentLabel.text = localUser.birthday;
            }
            
        }else if (indexPath.row == 5) {
            
        }
        
    }
    
    
    
    return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    if (indexPath.row == 0) {
        FTPropertySetingViewController *VC = [[FTPropertySetingViewController alloc] init];
        VC.propertyTextField.text = localUser.username;
        VC.title = @"修改姓名";
        [self.navigationController pushViewController:VC animated:YES];
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
