//
//  FTSetPassWordViewController.h
//  fighter
//
//  Created by kang on 16/5/3.
//  Copyright © 2016年 Mapbar. All rights reserved.

#import <UIKit/UIKit.h>
#import "FTUserViewController.h"

@interface FTSetPassWordViewController : FTUserViewController

@property (weak, nonatomic) IBOutlet UIView *seperaterView1;

@property (weak, nonatomic) IBOutlet UIView *seperaterView2;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField2;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *checkCode;

@end
