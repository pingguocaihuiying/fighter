//
//  FTBetView.m
//  fighter
//
//  Created by mapbar on 16/8/8.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBetView.h"
#import "FTPaySingleton.h"
#import "NetWorking.h"
#import "FTMatchDetailBean.h"

@interface FTBetView()<UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainViewCenterY;
//可选的几个注数按钮
@property (strong, nonatomic) IBOutlet UIButton *betValueButton1;
@property (strong, nonatomic) IBOutlet UIButton *betValueButton2;
@property (strong, nonatomic) IBOutlet UIButton *betValueButton3;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;//余额标签

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) FTPaySingleton *paySingleton;
@end

@implementation FTBetView

- (void)awakeFromNib {
    [super awakeFromNib];
    _textField.delegate = self;
    
    //设置标题间距
    [UILabel setRowGapOfLabel:_titleLabel withValue:8];
    
    //显示余额
    _balanceLabel.text = [NSString stringWithFormat:@"%ldP", (long)_paySingleton.balance];
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
    
    //查询余额
     _paySingleton = [FTPaySingleton shareInstance];
    
}

- (void)tapClick{
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
}

#pragma mark 确认下注
- (IBAction)confirmButtonClicked:(id)sender {
    NSLog(@"确定参与");
    
    if (_betValue <= 0) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"下注数不能为0"];
        return;
    }
    
    if (_paySingleton.balance < _betValue) {//如果余额不足，跳转去充值
        if ([_delegate respondsToSelector:@selector(pushToRechargeVC)]){
            [_delegate pushToRechargeVC];
        }
        
    } else {//否则，向服务器提交下注请求
            
//            [MBProgressHUD hideHUDForView:self animated:YES];
            [NetWorking betWithMatchBean:_matchBean andIsPlayer1Win:_isbetPlayer1Win andBetValue:_betValue andOption:^(BOOL result) {
                if (result) {
                    NSLog(@"下注成功");
                    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"下注成功"];
                    [self removeFromSuperview];
                    if ([_delegate respondsToSelector:@selector(betWithBetValues:andIsPlayer1Win:)] ) {
                        [_delegate betWithBetValues:_betValue andIsPlayer1Win:_isbetPlayer1Win];    
                    }
                    [_paySingleton fetchBalanceFromWeb:^{
                    _balanceLabel.text = [NSString stringWithFormat:@"%ldP", _paySingleton.balance];
                    }];//获取最新余额
                }else{
                    NSLog(@"下注失败");
                    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"下注失败"];
                }
            }];
        
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
    _betValue = 50;
    
    //清空输入框的内容
    _textField.text = @"";
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"string : %@", string);
    BOOL result = [FTTools isNumText:string];
    if (result) {
        //清除按钮的选中状态
        _betValueButton1.selected = NO;
        _betValueButton2.selected = NO;
        _betValueButton3.selected = NO;
        
        _betValue = [[textField.text stringByReplacingCharactersInRange:range withString:string] intValue];
        //限制额外价格的长度，不能大于1000000
        if (_betValue > 1000000) {
            return false;
        }
    }
    return result;
}



- (void)updateDisplay{
    //下注数
    if (_betValue == 5) {
        _betValueButton1.selected = YES;
    } else if(_betValue == 10){
        _betValueButton2.selected = YES;
    }else if(_betValue == 50){
        _betValueButton3.selected = YES;
    }else{
        _textField.text = [NSString stringWithFormat:@"%d", _betValue];
    }
    
    
    //初始化NSMutableAttributedString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];
    
    NSString *str0 = @"支持 ";
    NSDictionary *dictAttr0 = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    NSAttributedString *attr0 = [[NSAttributedString alloc]initWithString:str0 attributes:dictAttr0];
    [attributedString appendAttributedString:attr0];
    
    NSString *str1 = _isbetPlayer1Win ? _matchBean.userName : _matchBean.against;
    NSDictionary *dictAttr1 = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]};
    NSAttributedString *attr1 = [[NSAttributedString alloc]initWithString:str1 attributes:dictAttr1];
    [attributedString appendAttributedString:attr1];
    
    NSString *str2 = @" 在这场比赛中，战胜 ";
    NSDictionary *dictAttr2 = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    NSAttributedString *attr2 = [[NSAttributedString alloc]initWithString:str2 attributes:dictAttr2];
    [attributedString appendAttributedString:attr2];
    
    NSString *str3 = _isbetPlayer1Win ? _matchBean.against : _matchBean.userName;
    NSDictionary *dictAttr3 = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]};
    NSAttributedString *attr3 = [[NSAttributedString alloc]initWithString:str3 attributes:dictAttr3];
    [attributedString appendAttributedString:attr3];
    
    NSString *str4 = @" ？";
    NSDictionary *dictAttr4 = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    NSAttributedString *attr4 = [[NSAttributedString alloc]initWithString:str4 attributes:dictAttr4];
    [attributedString appendAttributedString:attr4];
    
    _titleLabel.attributedText = attributedString;
}
//充值按钮被点击
- (IBAction)rechargeButtonClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(pushToRechargeVC)]) {
        [_delegate pushToRechargeVC];
    }
}

@end
