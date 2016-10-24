//
//  FTCourseTableHeaderView.m
//  fighter
//
//  Created by 李懿哲 on 22/10/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTCourseTableHeaderView.h"

@interface FTCourseTableHeaderView()

@property (nonatomic, strong) UIView *bgView;//背景
@property (nonatomic, strong) UIView *topBorder;
@property (nonatomic, strong) UIView *leftBorder;
@property (nonatomic, strong) UIView *rightBorder;
@property (nonatomic, strong) UIView *bottomBorder;

@end


@implementation FTCourseTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        return self;
    }
    return nil;
}

- (void)initSubViewsWithIndex:(NSInteger)i{
    
        NSString *dateTimeStamp = [NSString stringWithFormat:@"%.0lf",  ([[NSDate date]timeIntervalSince1970] + (24 * 60 * 60 * i)) * 1000];
//        [_dateTimeStampArray addObject:dateTimeStamp];
        NSDate *  senddate=[NSDate dateWithTimeIntervalSinceNow: (24 * 60 * 60) * i];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyy"];
        NSString *  yearString = [dateformatter stringFromDate:senddate];
        [dateformatter setDateFormat:@"MM"];
        NSString *  monthString = [dateformatter stringFromDate:senddate];
        [dateformatter setDateFormat:@"dd"];
        NSString *  dayString = [dateformatter stringFromDate:senddate];
        [dateformatter setDateFormat:@"EEE"];
        
        NSString *  weekString = [dateformatter stringFromDate:senddate];
        NSLog(@"-%@",weekString);
        int year = [yearString intValue];
        NSLog(@"-%d", year);
        int month = [monthString intValue];
        NSLog(@"--%d", month);
        int day = [dayString intValue];
        NSLog(@"---%d", day);
        
        //添加月·日label
        CGFloat lableWidth = SCREEN_WIDTH / 6;//label宽度
//        UILabel *dateLabel = [_dateView viewWithTag:10000 + i];
        UILabel *dateLabel = [UILabel new];
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, lableWidth, 11)];
        if (!dateLabel) {
            dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, lableWidth, 11)];
            dateLabel.tag = 10000+i;
        }
        dateLabel.text = [NSString stringWithFormat:@"%d.%d", [monthString intValue], day];
        
//        NSString *dateString = [NSString stringWithFormat:@"%d月%d日", [monthString intValue], day];
//        [_dateArray addObject:dateString];
    
        if (i == 0) {
            dateLabel.text = @"今天";
        }
        dateLabel.font = [UIFont systemFontOfSize:11];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = [UIColor whiteColor];
        if (i == 0) {
            //            dateLabel.textColor = [UIColor colorWithHex:0x22b33c];
        }
        
        
        //添加周几label
//        UILabel *dayLabel = [_dateView viewWithTag:20000 + i];
    UILabel *dayLabel = [UILabel new];
    dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7 + 11 + 8, lableWidth, 12)];
        if (!dayLabel) {
            dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7 + 11 + 8, lableWidth, 12)];
            dayLabel.tag = 20000+i;
        }
        //        dayLabel.text = [[weekString componentsSeparatedByString:@"周"] lastObject];
        dayLabel.text = weekString;
        dayLabel.font = [UIFont systemFontOfSize:12];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.textColor = [UIColor whiteColor];
        if (i == 0) {
            //            dayLabel.textColor = [UIColor colorWithHex:0x22b33c];//如果是今天，改成绿色
        }
        
        
        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i * lableWidth, 0, lableWidth - 2, 45)];
//        view.backgroundColor = [UIColor clearColor];
    
        //添加透明按钮响应点击事件
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, lableWidth, 45)];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClicke:) forControlEvents:UIControlEventTouchUpInside];
        
    
        
        [self addSubview:dateLabel];
        
        [self addSubview:dayLabel];
        [self addSubview:button];
//        [self addSubview:view];
    
    
        //画边框和背景
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, lableWidth, 45)];
    _bgView.backgroundColor = [UIColor colorWithHex:0x191919];
    
    [self addSubview:_bgView];
    [self sendSubviewToBack:_bgView];
    
    //上
    _topBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, lableWidth, 2)];
    _topBorder.backgroundColor = [UIColor colorWithHex:0xbe1e1e];
    [self addSubview:_topBorder];

    //左
    _leftBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 45)];
    _leftBorder.backgroundColor = Cell_Space_Color;
    [self addSubview:_leftBorder];
    //右
    _rightBorder = [[UIView alloc]initWithFrame:CGRectMake(lableWidth - 1, 0, 1, 45)];
    _rightBorder.backgroundColor = Cell_Space_Color;
    [self addSubview:_rightBorder];
//    //下
    _bottomBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 44, lableWidth, 1)];
    _bottomBorder.backgroundColor = Cell_Space_Color;
    [self addSubview:_bottomBorder];
}

- (void)buttonClicke:(UIButton *)button{
    if ([_delegate respondsToSelector:@selector(buttonClickedWith:)]) {
        [_delegate buttonClickedWith:button.tag];
    }
}
- (void)setSelected{
    _bgView.hidden = NO;
    _topBorder.hidden = NO;
    _leftBorder.hidden = NO;
    _rightBorder.hidden = NO;
    _bottomBorder.hidden = YES;
}
- (void)setDisSelected{
    _bgView.hidden = YES;
    _topBorder.hidden = YES;
    _leftBorder.hidden = YES;
    _rightBorder.hidden = YES;
    _bottomBorder.hidden = NO;
}
@end
