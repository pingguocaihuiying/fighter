//
//  FTPhotoPickerView.m
//  fighter
//
//  Created by kang on 16/5/6.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPhotoPickerView.h"
#import "Masonry.h"
#import "NetWorking.h"
#import "FTUserBean.h"
#import "MBProgressHUD.h"
#import "UIWindow+MBProgressHUD.h"

@interface FTPhotoPickerView () <UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSInteger selectNum;
    
    CGFloat pickerH;//选择器可见宽度
    CGFloat selectedRowH;//选择器选中行宽度
}

@property (nonatomic ,strong) UIView *panelView;
@property (nonatomic ,strong) UIView *separatView;
@property (nonatomic ,strong) UIImageView *backImgView;
@property (nonatomic, strong) UIPickerView *pickerView;



@end


@implementation FTPhotoPickerView

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
    [_panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-10);
        make.right.equalTo(weakSelf.mas_right).with.offset(0);
        make.left.equalTo(weakSelf.mas_left).with.offset(0);
        make.height.equalTo(@250);
        
    }];
    
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
    
    
    //显示label
    _resultLabel = [[UILabel alloc]init];
    _resultLabel.font=[UIFont systemFontOfSize:16];
    _resultLabel.textAlignment = NSTextAlignmentCenter;
    _resultLabel.textColor = [UIColor colorWithHex:0x828287];;
    _resultLabel.text = @"修改头像";
    [_panelView addSubview:_resultLabel];
    
    [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakPanel.mas_top).with.offset(20);
        make.right.equalTo(weakPanel.mas_right).with.offset(-40);
        make.left.equalTo(weakPanel.mas_left).with.offset(40);
        make.height.equalTo(@20);
    }];
    
    
    //    //分隔线
    //    _separatView = [[UIView alloc] init];
    //    _separatView.backgroundColor = Cell_Space_Color;
    //    [_panelView addSubview:_separatView];
    //
    //    //分割线
    __weak UILabel *weakLabel= _resultLabel;
    //    [_separatView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(weakLabel.mas_bottom).with.offset(10);
    //        make.right.equalTo(weakPanel.mas_right).with.offset(-40);
    //        make.left.equalTo(weakPanel.mas_left).with.offset(40);
    //        make.height.equalTo(@1.5);
    //    }];
    
    
    self.cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.maleBtn setBackgroundColor:[UIColor greenColor]];
    [self.cameraBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.cameraBtn setImage:[UIImage imageNamed:@"拍照"] forState:UIControlStateNormal];
    [self.cameraBtn setImage:[UIImage imageNamed:@"拍照pre"] forState:UIControlStateHighlighted];
    [self.cameraBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [self.panelView addSubview:self.cameraBtn];
    
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakPanel.mas_centerX).with.offset(0);
        make.left.equalTo(weakPanel.mas_left).with.offset(40);
        make.top.equalTo(weakLabel.mas_bottom).with.offset(20);
        make.height.equalTo(@80);
        
    }];
    
    self.albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.femaleBtn setBackgroundColor:[UIColor blueColor]];
    [self.albumBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.albumBtn setImage:[UIImage imageNamed:@"相册"] forState:UIControlStateNormal];
    [self.albumBtn setImage:[UIImage imageNamed:@"相册pre"] forState:UIControlStateHighlighted];
    [self.albumBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [self.panelView addSubview:self.albumBtn];
    
    [self.albumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakPanel.mas_right).with.offset(-40);
        make.left.equalTo(weakPanel.mas_centerX ).with.offset(0);
        make.top.equalTo(weakLabel.mas_bottom).with.offset(20);
        make.height.equalTo(@80);
        
    }];
    
   
    //完成按钮
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneBtn setTitle:@"取   消" forState:UIControlStateNormal];
    [_doneBtn setBackgroundImage:[UIImage imageNamed:@"主要按钮背景ios"] forState:UIControlStateNormal];
    [_doneBtn setBackgroundImage:[UIImage imageNamed:@"主要按钮背景ios-pre"] forState:UIControlStateHighlighted];
    [_doneBtn addTarget:self  action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [_panelView addSubview:_doneBtn];
    
    //picker
    __weak UIImageView *weakBackImg= _backImgView;
    [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakBackImg.mas_bottom).with.offset(-20);
        make.right.equalTo(weakBackImg.mas_right).with.offset(-15);
        make.left.equalTo(weakBackImg.mas_left).with.offset(15);
        make.height.equalTo(@45);
    }];
}



- (void) setTouchEvent {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self addGestureRecognizer:tap];
    
}

#pragma mark - UIPickerViewDatasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 350;
    }else {
        return 1;
    }
}


#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return selectedRowH;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    
    if (component==0) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 25)];
        label.textAlignment=NSTextAlignmentRight;
        label.font=[UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text= [NSString stringWithFormat:@"%lu",row +1 ];
        
        return label;
    }else {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 25)];
        label.textAlignment=NSTextAlignmentRight;
        label.textAlignment = NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:20];
        label.text= @"kg";
        label.textColor = [UIColor whiteColor];
        return label;
    }//if-else cycle end
    
}

//选中picker
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"selected");
    
    if (component == 0) {
        selectNum = row +1;
    }
    
    //将选择器结果显示到label
    _resultLabel.text = [NSString stringWithFormat:@"%ldkg",selectNum];
    
}

#pragma mark - response methods



- (void) confirmAction:(id) sender {
    
    NSString *propertValue;
//    if (self.maleBtn.selected) {
//        propertValue = [@"男" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    }else {
//        propertValue = [@"女" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    }
    //    propertValue = [NSString stringWithFormat:@"%ld",selectW];
    
//    NetWorking *net = [NetWorking new];
//    [net updateUserWithValue:propertValue
//                         Key:@"sex"
//                      option:^(NSDictionary *dict) {
//                          NSLog(@"dict:%@",dict);
//                          if (dict != nil) {
//                              
//                              bool status = [dict[@"status"] boolValue];
//                              NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
//                              
//                              if (status == true) {
//                                  
//                                  //                                  [[UIApplication sharedApplication].keyWindow showHUDWithMessage:message];
//                                  [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//                                  
//                                  //从本地读取存储的用户信息
//                                  NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
//                                  FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
//                                  localUser.sex = propertValue;
//                                  
//                                  //将用户信息保存在本地
//                                  NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:localUser];
//                                  [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"loginUser"];
//                                  [[NSUserDefaults standardUserDefaults]synchronize];
//                                  
//                                  
//                                  if ([self.delegate respondsToSelector:@selector(didSelectedDate: type:)]) {
//                                      [self.delegate didSelectedDate:propertValue type:FTPickerTypeWeight];
//                                  }
//                                  
//                              }else {
//                                  NSLog(@"message : %@", [dict[@"message"] class]);
//                                  [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//                                  
//                                  if ([self.delegate respondsToSelector:@selector(didSelectedDate: type:)]) {
//                                      [self.delegate didSelectedDate:nil type:FTPickerTypeWeight];
//                                  }
//                                  
//                              }
//                          }else {
//                              
//                              [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@" 性别修改失败，请稍后再试"];
//                              
//                              if ([self.delegate respondsToSelector:@selector(didSelectedDate: type:)]) {
//                                  [self.delegate didSelectedDate:nil type:FTPickerTypeWeight];
//                              }
//                          }
//                      }];
    
    [self removeFromSuperview];
}


- (void) tapAction:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self];
    CGRect frame = [self convertRect:_panelView.frame toView:self];
    if (!CGRectContainsPoint(frame, point)) {
        [self removeFromSuperview];
    }
    
}

@end
