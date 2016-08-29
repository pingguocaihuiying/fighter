//
//  FTSexPickeView.m
//  fighter
//
//  Created by kang on 16/5/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTSexPickerView.h"
#import "Masonry.h"
#import "NetWorking.h"
#import "FTUserBean.h"
#import "MBProgressHUD.h"
#import "UIWindow+MBProgressHUD.h"

@interface FTSexPickerView ()
{
    
    CGFloat pickerH;//选择器可见宽度
    CGFloat selectedRowH;//选择器选中行宽度
}

@property (nonatomic ,strong) UIView *panelView;
@property (nonatomic ,strong) UIView *separatView;
@property (nonatomic ,strong) UIImageView *backImgView;


@property (nonatomic, strong) UIButton *maleBtn;
@property (nonatomic, strong) UIButton *femaleBtn;

@end


@implementation FTSexPickerView

- (id) init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0x191919 alpha:0.5];
        self.opaque = NO;
        [self setFrame:[UIScreen mainScreen].bounds];
        
        [self setSubviews];
        [self setTouchEvent];
    }
    
    return self;
}



- (void) setSubviews {
    
    //面板
    _panelView = [[UIView alloc] init];
    _panelView.backgroundColor = [UIColor clearColor];
    _panelView.opaque = NO;
    [self addSubview:_panelView];
    
    CGRect frame = self.frame;
    __weak __typeof(self) weakSelf = self;
    
    //边框
    _backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width-20, frame.size.height/3)];
    [_backImgView setImage:[UIImage imageNamed:@"金属边框-改进ios"]];
    [_backImgView setBackgroundColor:[UIColor colorWithHex:0x191919]];
    [_panelView addSubview:_backImgView];
    
    __weak UIView *weakPanel= _panelView;
    [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakPanel.mas_bottom).with.offset(0);
        make.right.equalTo(weakPanel.mas_right).with.offset(0);
        make.left.equalTo(weakPanel.mas_left).with.offset(0);
        make.top.equalTo(weakPanel).with.offset(5);;
        
    }];
    
    
    //完成按钮
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneBtn setTitle:@"保    存" forState:UIControlStateNormal];
    [_doneBtn setBackgroundImage:[UIImage imageNamed:@"主要按钮背景ios"] forState:UIControlStateNormal];
    [_doneBtn setBackgroundImage:[UIImage imageNamed:@"主要按钮背景ios-pre"] forState:UIControlStateHighlighted];
    [_doneBtn addTarget:self  action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [_panelView addSubview:_doneBtn];
    
    __weak UIImageView *weakBackImg= _backImgView;
    [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakBackImg.mas_bottom).with.offset(-20);
        make.right.equalTo(weakBackImg.mas_right).with.offset(-40);
        make.left.equalTo(weakBackImg.mas_left).with.offset(40);
        make.height.equalTo(@45);
    }];
    
    
    self.maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.maleBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.maleBtn setImage:[UIImage imageNamed:@"单选-空"] forState:UIControlStateNormal];
    [self.maleBtn setImage:[UIImage imageNamed:@"单选-选中"] forState:UIControlStateSelected];
    [self.maleBtn setTitle:@"男性" forState:UIControlStateNormal];
    [self.maleBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [self.maleBtn addTarget:self action:@selector(maleBtnAction:) forControlEvents:UIControlEventTouchDown];
    self.maleBtn.selected = YES;
    [self.panelView addSubview:self.maleBtn];
    
    __weak UIButton *weakButton= _doneBtn;
    [self.maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakPanel.mas_centerX).with.offset(0);
        make.left.equalTo(weakPanel.mas_left).with.offset(40);
        make.bottom.equalTo(weakButton.mas_top).with.offset(-20);
        make.height.equalTo(@30);
        
    }];
    
    self.femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.femaleBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.femaleBtn setImage:[UIImage imageNamed:@"单选-空"] forState:UIControlStateNormal];
    [self.femaleBtn setImage:[UIImage imageNamed:@"单选-选中"] forState:UIControlStateSelected];
    [self.femaleBtn setTitle:@"女性" forState:UIControlStateNormal];
    [self.femaleBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [self.femaleBtn addTarget:self action:@selector(femaleBtnAction:) forControlEvents:UIControlEventTouchDown];
    [self.panelView addSubview:self.femaleBtn];
    
    [self.femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakPanel.mas_right).with.offset(-40);
        make.left.equalTo(weakPanel.mas_centerX ).with.offset(0);
        make.bottom.equalTo(weakButton.mas_top).with.offset(-20);
        make.height.equalTo(@30);
        
    }];
    
    CGFloat width = self.maleBtn.frame.size.width;
    
    self.maleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0 , 0, (width/2 +4));
    // 设置titleEdgeInsets
    self.maleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, (width/2 +4), 0, 0);
    
    self.femaleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0 , 0, (width/2 +4));
    // 设置titleEdgeInsets
    self.femaleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, (width/2 +4), 0, 0);
    
    
    //显示label
    _resultLabel = [[UILabel alloc]init];
    _resultLabel.font=[UIFont systemFontOfSize:16];
    _resultLabel.textAlignment = NSTextAlignmentCenter;
    _resultLabel.textColor = [UIColor colorWithHex:0x828287];;
    _resultLabel.text = @"请设置性别";
    [_panelView addSubview:_resultLabel];
    
    __weak UIButton *weakMaleBtn= _maleBtn;
    [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakMaleBtn.mas_top).with.offset(-20);
        make.right.equalTo(weakBackImg.mas_right).with.offset(-40);
        make.left.equalTo(weakBackImg.mas_left).with.offset(40);
        make.height.equalTo(@20);
    }];
    
    //添加_panelView 约束
    __weak UILabel *weakLabel= _resultLabel;
    [_panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-64);
        make.right.equalTo(weakSelf.mas_right).with.offset(-6);
        make.left.equalTo(weakSelf.mas_left).with.offset(6);
        make.top.equalTo(weakLabel.mas_top).with.offset(-15);
        
    }];

}



- (void) setTouchEvent {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self addGestureRecognizer:tap];
    
}


#pragma mark - response methods

- (void) maleBtnAction:(id) sender {

    if (!self.maleBtn.selected) {
        
        self.maleBtn.selected = YES;
        self.femaleBtn.selected = NO;
    }
}

- (void) femaleBtnAction:(id) sender {
    
    if (!self.femaleBtn.selected) {
        
        self.femaleBtn.selected = YES;
        self.maleBtn.selected = NO;
    }
}

- (void) confirmAction:(id) sender {
    
    NSString *propertValue;
    if (self.maleBtn.selected) {
//        propertValue = [@"男性" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        propertValue = [@"男性" stringByReplacingPercentEscapesUsingEncoding:NSISOLatin2StringEncoding];
//        propertValue = [@"男性" stringByAddingPercentEscapesUsingEncoding:NSISOLatin2StringEncoding];
        
         propertValue = @"男性";
        
    }else {
//        propertValue = [@"女性" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        propertValue = [@"女性" stringByReplacingPercentEscapesUsingEncoding:NSISOLatin2StringEncoding];
//         propertValue = [@"女性" stringByAddingPercentEscapesUsingEncoding:NSISOLatin2StringEncoding];
        propertValue = @"女性";
    }
    
    NSStringEncoding enc =     CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    [propertValue stringByAddingPercentEscapesUsingEncoding:enc];
    NSLog(@"sex:%@",propertValue);
    
    


//    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    NSStringEncoding enc =     CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
//    [propertValue stringByRemovingPercentEncoding];
//    [propertValue stringByAddingPercentEscapesUsingEncoding:enc];
//    [propertValue stringByReplacingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
    
    
    if (propertValue == nil) {
        return;
    }
    NetWorking *net = [NetWorking new];
    [net updateUserByGet:propertValue Key:@"sex" option:^(NSDictionary *dict) {
        NSLog(@"dict:%@",dict);
        if (dict != nil) {
            
            bool status = [dict[@"status"] boolValue];
            NSLog(@" sever sex:%@",dict[@"data"]);
            
            if (status == true) {
                
                //                                  [[UIApplication sharedApplication].keyWindow showHUDWithMessage:message];
                [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                //从本地读取存储的用户信息
                NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
                FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
                localUser.sex = [propertValue stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                //将用户信息保存在本地
                NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:localUser];
                [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"loginUser"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                if ([self.delegate respondsToSelector:@selector(didSelectedDate: type:)]) {
                    [self.delegate didSelectedDate:propertValue type:FTPickerTypeWeight];
                }
                
            }else {
                NSLog(@"message : %@", [dict[@"message"] class]);
                [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                if ([self.delegate respondsToSelector:@selector(didSelectedDate: type:)]) {
                    [self.delegate didSelectedDate:nil type:FTPickerTypeWeight];
                }
                
            }
        }else {
            
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@" 性别修改失败，请稍后再试"];
            
            if ([self.delegate respondsToSelector:@selector(didSelectedDate: type:)]) {
                [self.delegate didSelectedDate:nil type:FTPickerTypeWeight];
            }
        }

    }];
    
    
    [self removeFromSuperview];
}


- (void) tapAction:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self];
    CGRect frame = [self convertRect:_panelView.frame toView:self];
    if (!CGRectContainsPoint(frame, point)) {
        [self removeFromSuperview];
    }
    
}
- (void) setButton {

    
    self.maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.maleBtn setCenter:CGPointMake(160, 160)];
//    [self.maleBtn setBounds:CGRectMake(0, 0, buttonWidth, buttonHeight)];
    [self.maleBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];

    [self.maleBtn setImage:[UIImage imageNamed:@"单选-空"] forState:UIControlStateNormal];
    [self.maleBtn setImage:[UIImage imageNamed:@"单选-选中"] forState:UIControlStateSelected];
    
    [self.maleBtn setTitle:@"男性" forState:UIControlStateNormal];
    [self.maleBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [self.panelView addSubview:self.maleBtn];
    
    CGFloat width = self.maleBtn.frame.size.width;
    CGFloat imageWidth = 16.0;
    CGFloat titleWidth =  [self.maleBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    // 设置imageEdgeInsets
    CGFloat top = 0;
    CGFloat left = (width - imageWidth - titleWidth - 8)/2;
    CGFloat bottom = 0;
    CGFloat right = (8+titleWidth + left);
    
    self.maleBtn.imageEdgeInsets = UIEdgeInsetsMake(top, left , bottom, right);
    // 设置titleEdgeInsets
    self.maleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, (8+imageWidth + left), 0, -left);
    
}
@end
