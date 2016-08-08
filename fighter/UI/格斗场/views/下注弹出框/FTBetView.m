//
//  FTBetView.m
//  fighter
//
//  Created by mapbar on 16/8/8.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBetView.h"

@interface FTBetView()<UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainViewCenterY;
//可选的几个注数按钮
@property (strong, nonatomic) IBOutlet UIButton *betValueButton1;
@property (strong, nonatomic) IBOutlet UIButton *betValueButton2;
@property (strong, nonatomic) IBOutlet UIButton *betValueButton3;
//当前选择的按钮下标

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation FTBetView

- (void)awakeFromNib {
    [super awakeFromNib];
    _textField.delegate = self;
    
    //设置标题间距
    [UILabel setRowGapOfLabel:_titleLabel withValue:8];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initSubview];
        return self;
    }
    return nil;
}

- (void)initSubview{
    //设置textField的代理
    _textField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
//    //注册键盘弹出的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)tapClick{
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
}
- (IBAction)confirmButtonClicked:(id)sender {
    NSLog(@"确定参与");
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(betWithBetValues:)]) {
        [_delegate betWithBetValues:_betValue];
    }else{
        NSLog(@"betView无法回掉");
    }
}
- (IBAction)cancelButtonClicked:(id)sender {
    NSLog(@"取消");
    [self removeFromSuperview]; 
}

- (IBAction)betValueButton1Clicked:(id)sender {
    _betValueButton1.selected = YES;
    _betValueButton2.selected = NO;
    _betValueButton3.selected = NO;
    
    _betValue = 5;
    
    //清空输入框的内容
    _textField.text = @"";
}
- (IBAction)betValueButton2Clicked:(id)sender {
    _betValueButton1.selected = NO;
    _betValueButton2.selected = YES;
    _betValueButton3.selected = NO;
    
    _betValue = 10;
    
    //清空输入框的内容
    _textField.text = @"";
}
- (IBAction)betValueButton3Clicked:(id)sender {
    _betValueButton1.selected = NO;
    _betValueButton2.selected = NO;
    _betValueButton3.selected = YES;
    _betValue = 15;
    
    //清空输入框的内容
    _textField.text = @"";
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    _betValue = [textField.text intValue];
    
    //清除按钮的选中状态
    _betValueButton1.selected = NO;
    _betValueButton2.selected = NO;
    _betValueButton3.selected = NO;
    
    
    return YES;
}

- (void)updateDisplay{
    //初始化NSMutableAttributedString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];
    
    NSString *str0 = @"支持 ";
    NSDictionary *dictAttr0 = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    NSAttributedString *attr0 = [[NSAttributedString alloc]initWithString:str0 attributes:dictAttr0];
    [attributedString appendAttributedString:attr0];
    
    NSString *str1 = _player1Name;
    NSDictionary *dictAttr1 = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSAttributedString *attr1 = [[NSAttributedString alloc]initWithString:str1 attributes:dictAttr1];
    [attributedString appendAttributedString:attr1];
    
    NSString *str2 = @" ，在这场比赛中，战胜 ";
    NSDictionary *dictAttr2 = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    NSAttributedString *attr2 = [[NSAttributedString alloc]initWithString:str2 attributes:dictAttr2];
    [attributedString appendAttributedString:attr2];
    
    NSString *str3 = _player2Name;
    NSDictionary *dictAttr3 = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSAttributedString *attr3 = [[NSAttributedString alloc]initWithString:str3 attributes:dictAttr3];
    [attributedString appendAttributedString:attr3];
    
    NSString *str4 = @" ？";
    NSDictionary *dictAttr4 = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    NSAttributedString *attr4 = [[NSAttributedString alloc]initWithString:str4 attributes:dictAttr4];
    [attributedString appendAttributedString:attr4];
    
    _titleLabel.attributedText = attributedString;
}
@end
