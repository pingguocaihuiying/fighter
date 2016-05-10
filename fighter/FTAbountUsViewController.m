//
//  FTAbountUsViewController.m
//  fighter
//
//  Created by kang on 16/5/9.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTAbountUsViewController.h"

@interface FTAbountUsViewController ()

@end

@implementation FTAbountUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self initSubviews];
}

- (void) initSubviews {

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 35, 35);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回pre"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    @try {
        self.contentLabel1.textColor = [UIColor colorWithHex:0xb4b4b4];
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.contentLabel1.text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:8];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.contentLabel1.text length])];
        [self.contentLabel1 setAttributedText:attributedString1];
        [self.contentLabel1 sizeToFit];
        
        self.contentLabel2.textColor = [UIColor colorWithHex:0xb4b4b4];
        NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:self.contentLabel2.text];
        NSMutableParagraphStyle * paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle2 setLineSpacing:8];
        [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [self. self.contentLabel2.text length])];
        [self. self.contentLabel2 setAttributedText:attributedString2];
        [self. self.contentLabel2 sizeToFit];
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@",exception);
    }
    @finally {
        
    }
   
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - response 

- (void) backBtnAction:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

@end
