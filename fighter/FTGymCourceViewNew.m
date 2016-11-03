//
//  FTGymSourceView.m
//  fighter
//
//  Created by 李懿哲 on 22/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTGymCourceViewNew.h"
#import "FTGymSourceTableView.h"
#import "FTBaseTableViewCell.h"
#import "FTCourseTableHeaderView.h"

@interface FTGymCourceViewNew()<UITableViewDelegate, UITableViewDataSource, FTCourseTableHeaderViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *seperatorView1;
@property (strong, nonatomic) IBOutlet UIView *seperatorView2;
@property (strong, nonatomic) IBOutlet UIView *seperatorView3;
//@property (strong, nonatomic) IBOutlet UIView *seperatorView4;
//@property (strong, nonatomic) IBOutlet UIView *seperatorView5;
//@property (strong, nonatomic) IBOutlet UIView *seperatorView6;
//@property (strong, nonatomic) IBOutlet UIView *seperatorView7;

@property (strong, nonatomic) IBOutlet UIView *dateView;//表头中周几、日期

//@property (weak, nonatomic) IBOutlet FTGymSourceTableView *t0;
@property (weak, nonatomic) IBOutlet FTGymSourceTableView *t1;
//@property (weak, nonatomic) IBOutlet FTGymSourceTableView *t2;
//@property (weak, nonatomic) IBOutlet FTGymSourceTableView *t3;
//@property (weak, nonatomic) IBOutlet FTGymSourceTableView *t4;
//@property (weak, nonatomic) IBOutlet FTGymSourceTableView *t5;
//@property (weak, nonatomic) IBOutlet FTGymSourceTableView *t6;

@property (nonatomic, strong) NSMutableArray *dateArray;//存储日期的字符串数组eg：7月8日
@property (nonatomic, strong) NSMutableArray *dateTimeStampArray;//存储每天时间戳的字符串数组

@property (nonatomic, assign) NSInteger curWeekDay;//当前展示的哪一天
@property (nonatomic, copy) NSString *curDateString;//选中的那天的展示日期
@property (nonatomic, copy) NSString *curTimeStampString;//选中的那天的时间戳
@property (strong, nonatomic) IBOutlet UIView *noCourserInfoView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *noCourserInfoViewHeight;

@property (nonatomic, assign) BOOL isBlanOfSelectedDay;//当前选中的日期是否有课程信息
@property (strong, nonatomic) IBOutlet UILabel *blankInfoLabel;

@end

@implementation FTGymCourceViewNew

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSubViews];
}

- (void)initSubViews{
    //设置label等的颜色
    [self setColor];
    
    //设置日期、初始化周几、日期数组
    [self setDateLabels];
    
    //默认周几为今天
    _curWeekDay = [FTTools getWeekdayOfTodayAfterToday:0];
    
    //tableViews高度
    _tableViewsHeight.constant = 0;
    
    [self initTableViews];
    
    //初始显示“暂无课程”view
    _noCourserInfoView.backgroundColor = [UIColor colorWithHex:0x191919];
    _noCourserInfoViewHeight.constant = 50;
    _noCourserInfoView.hidden = NO;
    
    _blankInfoLabel.textColor = [UIColor colorWithHex:0x505050];
}

- (void)setColor{
    _seperatorView1.backgroundColor = Cell_Space_Color;
    _seperatorView2.backgroundColor = Cell_Space_Color;
    _seperatorView3.backgroundColor = Cell_Space_Color;
//    _seperatorView4.backgroundColor = Cell_Space_Color;
//    _seperatorView5.backgroundColor = Cell_Space_Color;
//    _seperatorView6.backgroundColor = Cell_Space_Color;
//    _seperatorView7.backgroundColor = Cell_Space_Color;
}

- (void)setDateLabels{
    _dateArray = [NSMutableArray new];
    _dateTimeStampArray = [NSMutableArray new];
    
    for (int i = 0; i < 7; i++) {
        NSString *dateTimeStamp = [NSString stringWithFormat:@"%.0lf",  ([[NSDate date]timeIntervalSince1970] + (24 * 60 * 60 * i)) * 1000];
        [_dateTimeStampArray addObject:dateTimeStamp];
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
        
        
        CGFloat lableWidth = SCREEN_WIDTH / 7;//label宽度
        NSString *dateString = [NSString stringWithFormat:@"%d月%d日", [monthString intValue], day];
        [_dateArray addObject:dateString];

        

        //添加透明按钮响应点击事件

        FTCourseTableHeaderView *view = [[FTCourseTableHeaderView alloc]initWithFrame:CGRectMake(i * lableWidth, 0, lableWidth, 45)];
        view.backgroundColor = [UIColor clearColor];
        
        view.delegate = self;
        [view initSubViewsWithIndex:i];
        
        view.tag = 30000 + i;
        
        //默认选中第一个
        if (i == 0) {
            [view setSelected];
        }else{
            [view setDisSelected];
        }
        
        [_dateView addSubview:view];
        
    }
    
    _curDateString = _dateArray[0];
    _curTimeStampString = _dateTimeStampArray[0];
    
    
}

- (void)buttonClickedWith:(NSInteger)index{
    
    //设置选中项
    for(UIView *view in [_dateView subviews]){
        if ([view isKindOfClass:[FTCourseTableHeaderView class]]) {
            FTCourseTableHeaderView *headerView = (FTCourseTableHeaderView *)view;
            if (view.tag == 30000 + index) {
                [headerView setSelected];
            } else {
                [headerView setDisSelected];
            }
        }
    }
    
    NSLog(@"button index : %ld", index);
    NSLog(@"week day : %ld", [FTTools getWeekdayOfTodayAfterToday:index]);
    
    _curWeekDay = [FTTools getWeekdayOfTodayAfterToday:index];
    _curDateString = _dateArray[index];
    _curTimeStampString = _dateTimeStampArray[index];
    
    [_t1 reloadData];
    
//    [self updateBlankView];
    NSArray *courseArray = _placesUsingInfoDic[[NSString stringWithFormat:@"%ld", _curWeekDay ]];
    if (courseArray) {
        _tableViewsHeight.constant = 50 * courseArray.count;

        _isBlanOfSelectedDay = NO;
        [self updateBlankView];
        
        [_scrollDelegate scrollToBottom];
    }else{
        _tableViewsHeight.constant = 0;
        
        _isBlanOfSelectedDay = YES;
        [self updateBlankView];
        
        
        [_scrollDelegate scrollToBottom];
    }
    
}

//更新“暂无课程”view的显示状态
- (void)updateBlankView{
    
    if (_isBlanOfSelectedDay) {
        _noCourserInfoViewHeight.constant = 50;
        _noCourserInfoView.hidden = NO;
    }else{
        _noCourserInfoViewHeight.constant = 0;
        _noCourserInfoView.hidden = YES;
    }
}

- (void)initTableViews{
    
    //设置tableivew的星期几，0为第一列，只显示时间段，其他index对应周几（1、2、3等）

    _t1.index = [FTTools getWeekdayOfTodayAfterToday:0];

    
    //日期string
    _t1.dateString = _dateArray [0];

    
    //日期时间戳string
    _t1.timeStampString = _dateTimeStampArray [0];

    
    
    //注册cell用于复用
    [_t1 registerNib:[UINib nibWithNibName:@"FTGymSourceTableViewCellNew" bundle:nil] forCellReuseIdentifier:@"sourceCell"];
   
    //设置代理

    _t1.delegate = self;
    _t1.dataSource = self;

}

- (void)reloadTableViews{
    
    [_t1 reloadData];
    NSArray *courseArray = _placesUsingInfoDic[[NSString stringWithFormat:@"%ld", _curWeekDay ]];

    if (courseArray) {
        _tableViewsHeight.constant = 50 * courseArray.count;
        
        _isBlanOfSelectedDay = NO;
        [self updateBlankView];
        
//        [_scrollDelegate scrollToBottom];
    }else{
        _tableViewsHeight.constant = 0;
        
        _isBlanOfSelectedDay = YES;
        [self updateBlankView];
        
        
//        [_scrollDelegate scrollToBottom];
    }
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        if (_timeSectionsArray && _timeSectionsArray.count > 0) {
            return _timeSectionsArray.count;
        } else {
            return 0;
        }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = _curWeekDay;
    NSString *theDateKey = [NSString stringWithFormat:@"%ld", index];
    NSArray *courseArray = _placesUsingInfoDic[theDateKey];
    NSDictionary *dic;
    NSString *timeSection2 = _timeSectionsArray[indexPath.row][@"timeSection"];//cell代表的固定时间段
    for(NSDictionary *dict in courseArray){
        if ([timeSection2 isEqualToString:dict[@"timeSection"]]) {
            dic = dict;
            break;
        }
    }
    if (dic) {
        return 50;
    } else {
        return 0;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    FTGymSourceTableView *theTableView = (FTGymSourceTableView *)tableView;
 //其他显示课程的tableView
        FTGymSourceTableViewCellNew *cell = [tableView dequeueReusableCellWithIdentifier:@"sourceCell"];
//    [cell.statusButton addTarget:self action:@selector(description) forControlEvents:UIControlEventTouchUpInside];
        cell.tag = 10000 + indexPath.row;
        NSInteger index = _curWeekDay;
        NSString *theDateKey = [NSString stringWithFormat:@"%ld", index];
        NSArray *courseArray = _placesUsingInfoDic[theDateKey];
        NSDictionary *dic;
        NSString *timeSection2 = _timeSectionsArray[indexPath.row][@"timeSection"];//cell代表的固定时间段
        for(NSDictionary *dict in courseArray){
            if ([timeSection2 isEqualToString:dict[@"timeSection"]]) {
                dic = dict;
                break;
            }
        }
        
        
        //        判断是不是过去的时间**********START*************
        
        BOOL isPastTime = false;
        NSInteger today = (int)[FTTools getWeekdayOfToday];//今天是周几
        NSInteger theDay = _curWeekDay;//当前要显示的时间段是周几
        
        if (theDay != today) {//如果不是当天，那一定是未来的天
            isPastTime = NO;
        }else{//当天
            NSTimeInterval theTimeInterval = [FTTools getTimeIntervalWithAnyTimeIntervalOfDay:[[NSDate date] timeIntervalSince1970] andTimeString:[[timeSection2 componentsSeparatedByString:@"~"] firstObject]];//cell表示的时间段的起始时间戳
            NSTimeInterval nowTimeInterval = [[NSDate date] timeIntervalSince1970];//此刻的时间戳
            if (theTimeInterval < nowTimeInterval) {//过去
                isPastTime = true;
            } else {
                isPastTime = false;
            }
        }
        //        判断是不是过去的时间**********END*************
        cell.isPast = isPastTime;
        
    
            if (dic) {
                cell.hasCourseData = YES;
                [cell setwithDic:dic andCourseType:_courseType];
                cell.courserCellDic = dic;
            }else{//暂无课程
                [cell setBlank];
                cell.hasCourseData = NO;
            }
    
        
        return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"row : %ld", indexPath.row);
    FTGymSourceTableViewCellNew *cell = [tableView viewWithTag:(10000 + indexPath.row)];
    
    if (cell.hasCourseData && !cell.isPast) {//如果有课程数据，而且是未来可以预约的
        NSString *timeSection = _timeSectionsArray[indexPath.row][@"timeSection"];
        [_delegate courseClickedWithCell:cell andDay:_curWeekDay andTimeSection:timeSection andDateString:_curDateString andTimeStamp:_curTimeStampString];
    }
}

@end
