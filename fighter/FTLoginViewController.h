//
//  FTLoginViewController.h
//  fighter
//
//  Created by kang on 16/5/3.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *seperaterView1;

@property (weak, nonatomic) IBOutlet UIView *seperaterView2;

@property (weak, nonatomic) IBOutlet UITextField *acountTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIButton *weichatLoginBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@end
