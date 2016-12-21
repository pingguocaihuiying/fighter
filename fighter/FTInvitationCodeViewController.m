//
//  FTInvitationCodeViewController.m
//  fighter
//
//  Created by kang on 2016/12/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTInvitationCodeViewController.h"
#import "FTInvitationCodePopUpView.h"

@interface FTInvitationCodeViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *invitationCodeTextField;

@end

@implementation FTInvitationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init


- (void) setNotification {

    
}


- (void) setNavigationBar {

    self.title = @"输入邀请码";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 22, 22);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-取消"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-取消pre"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
}

- (void) setSubviewws {

    self.invitationCodeTextField.delegate = self;
    
}

#pragma mark - response


- (void) backBtnAction:(id) sender {

    [self.invitationCodeTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)submitButton:(id)sender {
    
    [self popUpView];
}


- (void) popUpView {

    FTInvitationCodePopUpView * popUpView = [[FTInvitationCodePopUpView alloc] initWithFrame:self.view.bounds];
    popUpView.dismissBlock = ^{
        
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    [self.view addSubview:popUpView];
}

#pragma mark - delegate

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//    NSString *text = [textField text];
//    
//    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
//    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
//        return NO;
//    }
//    
//    text = [text stringByReplacingCharactersInRange:range withString:string];
//    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    NSString *newString = @"";
//    while (text.length > 0) {
//        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
//        newString = [newString stringByAppendingString:subString];
//        if (subString.length == 4) {
//            newString = [newString stringByAppendingString:@" "];
//        }
//        text = [text substringFromIndex:MIN(text.length, 4)];
//    }
//    
//    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
//    
//    if (newString.length >= 20) {
//        return NO;
//    }
//    
//    [textField setText:newString];
//    
//    return NO;
//}




@end
