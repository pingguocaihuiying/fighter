//
//  FTBetView0.m
//  fighter
//
//  Created by 李懿哲 on 16/8/29.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBetView0.h"
#import "FTBetView.h"
#import "FTPaySingleton.h"
#import "NetWorking.h"

@interface FTBetView0()<UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainViewCenterY;
//可选的几个注数按钮
@property (strong, nonatomic) IBOutlet UIButton *betValueButton1;
@property (strong, nonatomic) IBOutlet UIButton *betValueButton2;
@property (strong, nonatomic) IBOutlet UIButton *betValueButton3;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;//余额标签

@property (nonatomic, strong) FTPaySingleton *paySingleton;

@property (strong, nonatomic) IBOutlet UIImageView *selectedPlayer1ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *selectedPlayer2ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *player1SelectedIndexImageView;
@property (strong, nonatomic) IBOutlet UIImageView *player2SelectedIndexImageView;

@property (nonatomic, assign)int selectedIndex;

//选手头像
@property (strong, nonatomic) IBOutlet UIImageView *player1HeaderImageView;
@property (strong, nonatomic) IBOutlet UIImageView *player2HeaderImageView;

//选手名字
@property (strong, nonatomic) IBOutlet UILabel *player1NameLabel;
@property (strong, nonatomic) IBOutlet UILabel *player2NameLabel;

//头像的灰圈
@property (strong, nonatomic) IBOutlet UIImageView *player1HeaderOutCircle;
@property (strong, nonatomic) IBOutlet UIImageView *player2HeaderOutCircle;

@end
@implementation FTBetView0


- (void)awakeFromNib {
    [super awakeFromNib];
    _textField.delegate = self;
    
    //显示余额
    _balanceLabel.text = [NSString stringWithFormat:@"%ldP", (long)_paySingleton.balance];
    
    _selectedIndex = -1;//选择第一个选手为0，选中第二个选手为1，默认为-1
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
- (IBAction)betPlayer1ButtonClicked:(id)sender {
    _selectedIndex = 0;
    [self updateSelectedUI];
}
- (IBAction)betPlayer2ButtonClicked:(id)sender {
    _selectedIndex = 1;
    [self updateSelectedUI];
}

- (void)updateSelectedUI{
    if (0 == _selectedIndex) {
        //设置头像右下角的选中状态
        _selectedPlayer1ImageView.image = [UIImage imageNamed:@"弹出框用-类别选择-选中"];
        _selectedPlayer2ImageView.image = [UIImage imageNamed:@"弹出框用-类别选择-空"];
        
        //设置名字下方的选中小箭头
        _player1SelectedIndexImageView.hidden = NO;
        _player2SelectedIndexImageView.hidden = YES;
        
    }else if(1 == _selectedIndex){
        //设置头像右下角的选中状态
        _selectedPlayer1ImageView.image = [UIImage imageNamed:@"弹出框用-类别选择-空"];
        _selectedPlayer2ImageView.image = [UIImage imageNamed:@"弹出框用-类别选择-选中"];
        
        //设置名字下方的选中小箭头
        _player1SelectedIndexImageView.hidden = YES;
        _player2SelectedIndexImageView.hidden = NO;
    }else if (-1 == _selectedIndex){
        //设置头像右下角的选中状态
        _selectedPlayer1ImageView.image = [UIImage imageNamed:@"弹出框用-类别选择-空"];
        _selectedPlayer2ImageView.image = [UIImage imageNamed:@"弹出框用-类别选择-空"];
        
        //设置名字下方的选中小箭头
        _player1SelectedIndexImageView.hidden = YES;
        _player2SelectedIndexImageView.hidden = YES;
    }
}

#pragma mark 确认下注
- (IBAction)confirmButtonClicked:(id)sender {
    NSLog(@"确定参与");
    if (_selectedIndex == -1) {
        NSLog(@"没有选择下注选手");
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"请先选择下注选手"];
        return;
    }
    
    if (_betValue <= 0) {
        NSLog(@"_betValue小于0");
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"下注数不能为0"];
        return;
    }
    
    if (_paySingleton.balance < _betValue) {//如果余额不足，跳转去充值
        if ([_delegate respondsToSelector:@selector(pushToRechargeVC)]){
            [_delegate pushToRechargeVC];
        }
        
    } else {//否则，跳转到下注确认页面

        if ([_delegate respondsToSelector:@selector(betWithBetValues:andIsPlayer1Win:)] ) {
            [self removeFromSuperview];
            if (_selectedIndex == 0) {
                _isbetPlayer1Win = YES;
            }else if(_selectedIndex == 1){
                _isbetPlayer1Win = NO;
            }
            
            [_delegate betStep1WithBetValues:_betValue andIsPlayer1Win:_isbetPlayer1Win andMatchBean:_matchBean];
        }
        
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
    if (_matchBean.headUrl1) {
        [_player1HeaderImageView sd_setImageWithURL:[NSURL URLWithString:_matchBean.headUrl1]];
        _player1HeaderOutCircle.image = [UIImage imageNamed:@"主页大头像-灰圈"];
    }
    
    if (_matchBean.headUrl2) {
        [_player2HeaderImageView sd_setImageWithURL:[NSURL URLWithString:_matchBean.headUrl2]];
        _player2HeaderOutCircle.image = [UIImage imageNamed:@"主页大头像-灰圈"];
    }
    
    _player1NameLabel.text = _matchBean.userName;
    _player2NameLabel.text = _matchBean.against;
}
//充值按钮被点击
- (IBAction)rechargeButtonClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(pushToRechargeVC)]) {
        [_delegate pushToRechargeVC];
    }
}

@end
