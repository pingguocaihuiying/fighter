//
//  CoustemPickerView.m
//  PickerViewDemo
//
//  Created by kang on 16/4/28.
//  Copyright © 2016年 kang. All rights reserved.
//

#import "FTDatePickerView.h"
#import "Masonry.h"
#import "NetWorking.h"
#import "FTUserBean.h"
#import "MBProgressHUD.h"
#import "UIWindow+MBProgressHUD.h"

@interface FTDatePickerView () <UIPickerViewDataSource,UIPickerViewDelegate>
{
    
    NSInteger year;
    NSInteger month;
    NSInteger day;
    
    NSInteger selectY;
    NSInteger selectM;
    NSInteger selectD;
    
    CGFloat pickerH;//选择器可见宽度
    CGFloat selectedRowH;//选择器选中行宽度
    
    BOOL addSeprater;
}

@property (nonatomic ,strong) UIView *panelView;
@property (nonatomic ,strong) UIView *separatView;
@property (nonatomic ,strong) UIImageView *backImgView;

@property (nonatomic, strong) UIPickerView *pickerView;

@end
@implementation FTDatePickerView

- (id) init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0x191919 alpha:0.5];
        self.opaque = NO;
        [self setFrame:[UIScreen mainScreen].bounds];
        
        [self setCurrentDate];
        [self setSubviews];
        [self setTouchEvent];
    }
    
    return self;
}

// 获取当前日期
-(void) setCurrentDate {
    
//    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"YYYY"];
    selectY = year = [dateFormatter stringFromDate:currentDate].integerValue;
    NSLog(@"year:%lu",year);
    
    [dateFormatter setDateFormat:@"MM"];
    selectM = month = [dateFormatter stringFromDate:currentDate].integerValue;
    NSLog(@"month:%lu",month);

    [dateFormatter setDateFormat:@"dd"];
    selectD = day = [dateFormatter stringFromDate:currentDate].integerValue;
    NSLog(@"month:%lu",day);
    
    addSeprater = NO;
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

    __weak UIImageView *weakBackImg= _backImgView;
    //完成按钮
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneBtn setTitle:@"确    认" forState:UIControlStateNormal];
    [_doneBtn setBackgroundImage:[UIImage imageNamed:@"主要按钮背景ios"] forState:UIControlStateNormal];
    [_doneBtn setBackgroundImage:[UIImage imageNamed:@"主要按钮背景ios-pre"] forState:UIControlStateHighlighted];
    [_doneBtn addTarget:self  action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [_panelView addSubview:_doneBtn];
    
    //picker
    [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakBackImg.mas_bottom).with.offset(-20);
        make.right.equalTo(weakBackImg.mas_right).with.offset(-40);
        make.left.equalTo(weakBackImg.mas_left).with.offset(40);
        make.height.equalTo(@45);
    }];
    

    //选择器
    _pickerView = [[UIPickerView alloc]init];
    _pickerView.backgroundColor = [UIColor clearColor];
    _pickerView.showsSelectionIndicator = NO;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_panelView addSubview:_pickerView];
    
    [_pickerView selectRow:200 inComponent:0 animated:YES];
    [_pickerView selectRow:191+month inComponent:1 animated:YES];
    [_pickerView selectRow:185+day inComponent:2 animated:YES];
    
    
    //picker 高度和选中栏高度
    pickerH = 162;
    selectedRowH = 35.0;
    __weak UIButton *weakButton= _doneBtn;
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakButton.mas_top).with.offset(0);
        make.right.equalTo(weakPanel.mas_right).with.offset(-60);
        make.left.equalTo(weakPanel.mas_left).with.offset(60);
        make.height.equalTo(@(pickerH));
    }];
    
    
    //分隔线
    _separatView = [[UIView alloc] init];
    _separatView.backgroundColor = Cell_Space_Color;
    [_panelView addSubview:_separatView];
    
    //分割线
    __weak UIPickerView *weakPicker = _pickerView;
    [_separatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakPicker.mas_top).with.offset(0);
        make.right.equalTo(weakPanel.mas_right).with.offset(-40);
        make.left.equalTo(weakPanel.mas_left).with.offset(40);
        make.height.equalTo(@1.5);
    }];

       
    //显示label
    _resultLabel = [[UILabel alloc]init];
    _resultLabel.font=[UIFont systemFontOfSize:20];
    _resultLabel.textAlignment = NSTextAlignmentCenter;
    _resultLabel.textColor = [UIColor colorWithHex:0x828287];
    _resultLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,(long)month,(long)day];
    [_panelView addSubview:_resultLabel];
    
    __weak UIView *weakSeparat = _separatView;
    [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSeparat.mas_top).with.offset(-10);
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

#pragma mark - UIPickerViewDatasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    if (component == 0) {
//        return 200;
//    }else if (component == 1) {
//        return 12;
//    }else {
//        return 31;
//    }

    return 400;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return selectedRowH;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    
    
    if (!addSeprater) {
        
        //删掉上下的黑线
        [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
        [[pickerView.subviews objectAtIndex:2] setHidden:TRUE];
        
        
        CGFloat with = (_pickerView.frame.size.width - 60)/3 ;
        CGFloat dividerW = _pickerView.frame.size.width/3;
        CGFloat lineH1 = (pickerH - selectedRowH)/2-1.5;
        CGFloat lineH2 = (pickerH - selectedRowH)/2-1.5 + selectedRowH;
        
        for (int i = 0; i < 3; i++) {
            
            UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(dividerW *i +10,  lineH1, with, 1.5)];
            [upView setBackgroundColor:[UIColor redColor]];
            [pickerView addSubview:upView];
            
            UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(dividerW *i +10,  lineH2, with, 1.5)];
            [downView setBackgroundColor:[UIColor redColor]];
            [pickerView addSubview:downView];
        }
        
        addSeprater = YES;
    }
    
    
    if (component==0) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        label.textAlignment=NSTextAlignmentRight;
        label.font=[UIFont systemFontOfSize:24];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
//        label.backgroundColor = [UIColor blueColor];
        label.text= [NSString stringWithFormat:@"%lu",year -200+row];
        
        return label;
    }else if(component==1) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        label.textAlignment=NSTextAlignmentRight;
        label.textAlignment = NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:24];
        label.text=[NSString stringWithFormat:@"%lu",row%12 +1];
        label.textColor = [UIColor whiteColor];
//        label.backgroundColor = [UIColor blueColor];
        return label;
    }else {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        label.textAlignment=NSTextAlignmentRight;
        label.textAlignment = NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:24];
//        label.backgroundColor = [UIColor blueColor];
        label.text=[NSString stringWithFormat:@"%lu",row%31 +1];
        label.textColor = [UIColor whiteColor];
        
        return label;
    }//if-else cycle end
    
}

//选中picker
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"selected");
    
    if (component == 0) {
        selectY = year -200+row;
    }else if (component == 1) {
    
        selectM = row%12+1;
    }else {
        
        selectD = row %31 +1;
    }
    
    //判断大小月
    if ([@[@2,@4,@6,@9,@11] containsObject:@(selectM) ]) {
        
        //判断2月
        if (selectM != 2 && selectD == 31) {
            
           [_pickerView selectRow:[_pickerView selectedRowInComponent:2] - 1 inComponent:2 animated:YES];
            selectD = ([_pickerView selectedRowInComponent:2]) %31 +1;
            
        }else if (selectM == 2) {
            
            //判断闰年二月
            if (selectY %4 != 0 && selectD >28 ) {
                [_pickerView selectRow:[_pickerView selectedRowInComponent:2] - (selectD -28) inComponent:2 animated:YES];
                selectD = ([_pickerView selectedRowInComponent:2]) %31 +1;
            }else if (selectY %4 == 0 && selectD >29 ) {
                [_pickerView selectRow:[_pickerView selectedRowInComponent:2] - (selectD -29) inComponent:2 animated:YES];
                selectD = ([_pickerView selectedRowInComponent:2]) %31 +1;
            }
        }
        
    }
    
    //将选择器结果显示到label
    _resultLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)selectY,(long)selectM,(long)selectD];
    
}


#pragma mark - response methods

- (void) confirmAction:(id) sender {

    NSString *propertValue = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)selectY,(long)selectM,(long)selectD];
    
    NetWorking *net = [NetWorking new];
    [net updateUserWithValue:propertValue
                         Key:@"birthday"
                      option:^(NSDictionary *dict) {
                          NSLog(@"dict:%@",dict);
                          if (dict != nil) {
                              
                              bool status = [dict[@"status"] boolValue];
                              NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                              
                              if (status == true) {
                                  
//                                  [[UIApplication sharedApplication].keyWindow showHUDWithMessage:message];
                                  [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                  
                                  //从本地读取存储的用户信息
                                  NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
                                  FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
                                  localUser.birthday = propertValue;
                                  
                                  //将用户信息保存在本地
                                  NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:localUser];
                                  [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"loginUser"];
                                  [[NSUserDefaults standardUserDefaults]synchronize];
                                  
                                  
                                  if ([self.delegate respondsToSelector:@selector(didSelectedDate:type:)]) {
                                      [self.delegate didSelectedDate:propertValue type:FTPickerTypeDate];
                                  }

                              }else {
                                  NSLog(@"message : %@", [dict[@"message"] class]);
                                  [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                  
                                  if ([self.delegate respondsToSelector:@selector(didSelectedDate:type:)]) {
                                      [self.delegate didSelectedDate:nil type:FTPickerTypeDate];
                                  }

                              }
                          }else {
                              [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"生日修改失败，请稍后再试"];
                              
                              if ([self.delegate respondsToSelector:@selector(didSelectedDate:type:)]) {
                                  [self.delegate didSelectedDate:nil type:FTPickerTypeDate];
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


@end
