//
//  FTHeightPickerView.m
//  fighter
//
//  Created by kang on 16/5/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTIncomePercentView.h"
#import "Masonry.h"
#import "NetWorking.h"
#import "FTUserBean.h"
#import "MBProgressHUD.h"
#import "UIWindow+MBProgressHUD.h"

@interface FTIncomePercentView () <UIPickerViewDataSource,UIPickerViewDelegate>

{
    
    NSInteger height;
    NSInteger selectH;
    
    
    CGFloat pickerH;//选择器可见宽度
    CGFloat selectedRowH;//选择器选中行宽度
    
    BOOL addSeprater;
}

@property (nonatomic ,strong) UIView *panelView;
@property (nonatomic ,strong) UIView *separatView;
@property (nonatomic ,strong) UIImageView *backImgView;

@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation FTIncomePercentView


- (id) init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0x191919 alpha:0.5];
        self.opaque = NO;
        [self setFrame:[UIScreen mainScreen].bounds];
        
        [self setCurrentData];
        [self setSubviews];
        [self setTouchEvent];
    }
    
    return self;
}

- (instancetype)initWithAvailablePoint:(NSInteger)availablePoint andCurPoint:(NSInteger)curPoint{
    
    self = [super init];
    
    if (self) {
        
        _availablePoint = availablePoint;
        _curPoint = curPoint;
        
        self.backgroundColor = [UIColor colorWithHex:0x191919 alpha:0.5];
        self.opaque = NO;
        [self setFrame:[UIScreen mainScreen].bounds];
        
        [self setCurrentData];
        [self setSubviews];
        [self setTouchEvent];
    }
    
    return self;
}

// 获取当前日期
-(void) setCurrentData {
    
    height = 175;
    selectH = 175;
    
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
    [_panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-10);
        make.right.equalTo(weakSelf.mas_right).with.offset(0);
        make.left.equalTo(weakSelf.mas_left).with.offset(0);
        make.height.equalTo(@280);
        
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
    _resultLabel.font=[UIFont systemFontOfSize:20];
    _resultLabel.textAlignment = NSTextAlignmentCenter;
    _resultLabel.textColor = [UIColor colorWithHex:0x828287];
//    _resultLabel.text = [NSString stringWithFormat:@"%ldcm",height];
    _resultLabel.text = _pickerTopLabelString;
    [_panelView addSubview:_resultLabel];
    
    [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakPanel.mas_top).with.offset(20);
        make.right.equalTo(weakPanel.mas_right).with.offset(-40);
        make.left.equalTo(weakPanel.mas_left).with.offset(40);
        make.height.equalTo(@20);
    }];
    
    
    //分隔线
    _separatView = [[UIView alloc] init];
    _separatView.backgroundColor = Cell_Space_Color;
    [_panelView addSubview:_separatView];
    
    //分割线
    __weak UILabel *weakLabel= _resultLabel;
    [_separatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakLabel.mas_bottom).with.offset(10);
        make.right.equalTo(weakPanel.mas_right).with.offset(-40);
        make.left.equalTo(weakPanel.mas_left).with.offset(40);
        make.height.equalTo(@1.5);
    }];
    
    //WithFrame:CGRectMake(10, self.frame.size.height/4*3, self.frame.size.width-20, self.frame.size.height/4)
    //选择器
    _pickerView = [[UIPickerView alloc]init];
    _pickerView.backgroundColor = [UIColor clearColor];
    _pickerView.showsSelectionIndicator = NO;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_panelView addSubview:_pickerView];
    [_pickerView selectRow:_curPoint - 1 inComponent:0 animated:YES];
    [_pickerView selectRow:0 inComponent:1 animated:YES];
    
    
    //picker
    pickerH = 162;
    selectedRowH = 35.0;
    __weak UIView *weakSeparat= _separatView;
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSeparat.mas_bottom).with.offset(0);
        make.right.equalTo(weakPanel.mas_right).with.offset(-60);
        make.left.equalTo(weakPanel.mas_left).with.offset(60);
        make.height.equalTo(@(pickerH));
    }];
    
    
    
    
    //完成按钮
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneBtn setTitle:@"确    认" forState:UIControlStateNormal];
    [_doneBtn setBackgroundImage:[UIImage imageNamed:@"主要按钮背景ios"] forState:UIControlStateNormal];
    [_doneBtn setBackgroundImage:[UIImage imageNamed:@"主要按钮背景ios-pre"] forState:UIControlStateHighlighted];
    [_doneBtn addTarget:self  action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [_panelView addSubview:_doneBtn];
    
    //picker
    __weak UIImageView *weakBackImg= _backImgView;
    [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakBackImg.mas_bottom).with.offset(-20);
        make.right.equalTo(weakBackImg.mas_right).with.offset(-40);
        make.left.equalTo(weakBackImg.mas_left).with.offset(40);
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
        return _availablePoint == 0 ? 1 : _availablePoint;//如果没有可用点数，则显示一个0
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
    
    if (! addSeprater) {
        
        //删掉上下的黑线
        [[self.pickerView.subviews objectAtIndex:1] setHidden:TRUE];
        [[self.pickerView.subviews objectAtIndex:2] setHidden:TRUE];
        
        
        CGFloat with = (_pickerView.frame.size.width - 60)/2 ;
        CGFloat dividerW = _pickerView.frame.size.width/2;
        CGFloat lineH1 = (pickerH - selectedRowH)/2-1.5;
        CGFloat lineH2 = (pickerH - selectedRowH)/2-1.5 + selectedRowH;
        
        for (int i = 0; i < 2; i++) {
            
            UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(dividerW *i +10,  lineH1, with, 1.5)];
            [upView setBackgroundColor:[UIColor redColor]];
            [self.pickerView addSubview:upView];
            
            UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(dividerW *i +10,  lineH2, with, 1.5)];
            [downView setBackgroundColor:[UIColor redColor]];
            [self.pickerView addSubview:downView];
        }
        
        addSeprater = YES;
    }
    
    if (component==0) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 25)];
        label.textAlignment=NSTextAlignmentRight;
        label.font=[UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        if (_availablePoint == 0) {//如果没有可用点数，则显示为0
            label.text= @"0";
        }else{
            label.text= [NSString stringWithFormat:@"%lu",(row + 1)  * 5 ];
        }
        
        return label;
    }else {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 25)];
        label.textAlignment=NSTextAlignmentRight;
        label.textAlignment = NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:20];
        label.text= @"%";
        label.textColor = [UIColor whiteColor];
        return label;
    }//if-else cycle end
}

//选中picker
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"selected");
    
    if (component == 0) {
        selectH = (row + 1) * 5;
    }
    if (_availablePoint == 0) {
        _curPoint = 0;
    } else {
        _curPoint = row + 1;
    }
    //将选择器结果显示到label
//    _resultLabel.text = [NSString stringWithFormat:@"%ld %%",selectH];
    
}


#pragma mark - response methods

- (void) confirmAction:(id) sender {
    [_delegate pickerView:self didSelectedIncomeValuePercent:_curPoint];
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
