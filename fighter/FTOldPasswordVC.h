//
//  FTOldPasswordVC.h
//  fighter
//
//  Created by kang on 16/5/9.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTUserViewController.h"

@interface FTOldPasswordVC : FTUserViewController


@property (weak, nonatomic) IBOutlet UIView *seperaterView1;

@property (weak, nonatomic) IBOutlet UIView *seperaterView2;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField2;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *checkCode;
@end
