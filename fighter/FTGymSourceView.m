//
//  FTGymSourceView.m
//  fighter
//
//  Created by 李懿哲 on 22/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTGymSourceView.h"
#import "FTGymSourceTableView.h"
#import "FTGymTimeSectionTableViewCell.h"
#import "FTGymSourceTableViewCell.h"
#import "FTBaseTableViewCell.h"

@interface FTGymSourceView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *seperatorView1;
@property (strong, nonatomic) IBOutlet UIView *seperatorView2;
@property (strong, nonatomic) IBOutlet UIView *seperatorView3;
@property (strong, nonatomic) IBOutlet UIView *seperatorView4;
@property (strong, nonatomic) IBOutlet UIView *seperatorView5;
@property (strong, nonatomic) IBOutlet UIView *seperatorView6;
@property (strong, nonatomic) IBOutlet UIView *seperatorView7;

@property (strong, nonatomic) IBOutlet UIView *dateView;//表头中周几、日期
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewsHeight;//tableViews的高度

@property (weak, nonatomic) IBOutlet FTGymSourceTableView *t0;
@property (weak, nonatomic) IBOutlet FTGymSourceTableView *t1;
@property (weak, nonatomic) IBOutlet FTGymSourceTableView *t2;
@property (weak, nonatomic) IBOutlet FTGymSourceTableView *t3;
@property (weak, nonatomic) IBOutlet FTGymSourceTableView *t4;
@property (weak, nonatomic) IBOutlet FTGymSourceTableView *t5;
@property (weak, nonatomic) IBOutlet FTGymSourceTableView *t6;


@end

@implementation FTGymSourceView

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
    
    //设置日期
    [self setDateLabels];
    
    //tableViews高度
    _tableViewsHeight.constant = 600;
    
    [self initTableViews];
}



- (void)setColor{
    _seperatorView1.backgroundColor = Cell_Space_Color;
    _seperatorView2.backgroundColor = Cell_Space_Color;
    _seperatorView3.backgroundColor = Cell_Space_Color;
    _seperatorView4.backgroundColor = Cell_Space_Color;
    _seperatorView5.backgroundColor = Cell_Space_Color;
    _seperatorView6.backgroundColor = Cell_Space_Color;
    _seperatorView7.backgroundColor = Cell_Space_Color;
}

- (void)setDateLabels{
    
    for (int i = 0; i < 6; i++) {
        NSDate *  senddate=[NSDate dateWithTimeIntervalSinceNow: (24 * 60 * 60) * (i + 1)];
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
        CGFloat lableWidth = SCREEN_WIDTH / 7;//label宽度
        UILabel *dateLabel = [_dateView viewWithTag:10000 + i];
        if (!dateLabel) {
            dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * lableWidth, 7, lableWidth, 11)];
            dateLabel.tag = 10000+i;
        }
        dateLabel.text = [NSString stringWithFormat:@"%d.%d", [monthString intValue], day];
        dateLabel.font = [UIFont systemFontOfSize:11];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = [UIColor whiteColor];
        [_dateView addSubview:dateLabel];
        
        //添加周几label
        UILabel *dayLabel = [_dateView viewWithTag:20000 + i];
        if (!dayLabel) {
            dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * lableWidth, 7 + 11 + 8, lableWidth, 12)];
            dayLabel.tag = 20000+i;
        }
        dayLabel.text = [[weekString componentsSeparatedByString:@"周"] lastObject];;
        dayLabel.font = [UIFont systemFontOfSize:12];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.textColor = [UIColor whiteColor];
        [_dateView addSubview:dayLabel];
    }
}

- (void)initTableViews{
    //设置tableivew的星期几，0为第一列，只显示时间段，其他index对应周几（1、2、3等）
    _t0.index = 0;
    _t1.index = [FTTools getWeekdayOfTodayAfterToday:0];
    _t2.index = [FTTools getWeekdayOfTodayAfterToday:1];
    _t3.index = [FTTools getWeekdayOfTodayAfterToday:2];
    _t4.index = [FTTools getWeekdayOfTodayAfterToday:3];
    _t5.index = [FTTools getWeekdayOfTodayAfterToday:4];
    _t6.index = [FTTools getWeekdayOfTodayAfterToday:5];
    //注册cell用于复用
    [_t0 registerNib:[UINib nibWithNibName:@"FTGymTimeSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"timeSectionCell"];
    [_t1 registerNib:[UINib nibWithNibName:@"FTGymSourceTableViewCell" bundle:nil] forCellReuseIdentifier:@"sourceCell"];
    [_t2 registerNib:[UINib nibWithNibName:@"FTGymSourceTableViewCell" bundle:nil] forCellReuseIdentifier:@"sourceCell"];
    [_t3 registerNib:[UINib nibWithNibName:@"FTGymSourceTableViewCell" bundle:nil] forCellReuseIdentifier:@"sourceCell"];
    [_t4 registerNib:[UINib nibWithNibName:@"FTGymSourceTableViewCell" bundle:nil] forCellReuseIdentifier:@"sourceCell"];
    [_t5 registerNib:[UINib nibWithNibName:@"FTGymSourceTableViewCell" bundle:nil] forCellReuseIdentifier:@"sourceCell"];
    [_t6 registerNib:[UINib nibWithNibName:@"FTGymSourceTableViewCell" bundle:nil] forCellReuseIdentifier:@"sourceCell"];
    
    //设置代理
    _t0.delegate = self;
    _t0.dataSource = self;
    _t1.delegate = self;
    _t1.dataSource = self;
    _t2.delegate = self;
    _t2.dataSource = self;
    _t3.delegate = self;
    _t3.dataSource = self;
    _t4.delegate = self;
    _t4.dataSource = self;
    _t5.delegate = self;
    _t5.dataSource = self;
    _t6.delegate = self;
    _t6.dataSource = self;
}

- (void)setTableViewHeight{
    _tableViewsHeight.constant = _timeSectionsArray.count * 42;
}

- (void)reloadTableViews{
    [_t0 reloadData];
    [_t1 reloadData];
    [_t2 reloadData];
    [_t3 reloadData];
    [_t4 reloadData];
    [_t5 reloadData];
    [_t6 reloadData];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_timeSectionsArray && _timeSectionsArray.count > 0) {
        return _timeSectionsArray.count;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FTGymSourceTableView *theTableView = (FTGymSourceTableView *)tableView;
    if (theTableView.index == 0) {//第一列的时间段
         FTGymTimeSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeSectionCell"];
        [cell setTimeLabelWithTimeSectionString:_timeSectionsArray[indexPath.row][@"timeSection"]];
        [cell setWhiteColor];//更新标签颜色的显示
        return cell;
    } else {//其他显示课程的tableView
        FTGymSourceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sourceCell"];
        cell.tag = 10000 + indexPath.row;
        NSString *theDateKey = [NSString stringWithFormat:@"%ld", theTableView.index];
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
            //        判断是不是过去的时间**********START*************
            cell.hasCourseData = YES;
            BOOL isPastTime = false;
            
            NSInteger today = (int)[FTTools getWeekdayOfToday];//今天是周几
            NSInteger theDay = theTableView.index;//当前要显示的时间段是周几
            
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
            
            if (isPastTime) {
                cell.isPast = YES;
            } else {
                cell.isPast = NO;
            }
            [cell setwithDic:dic];
        }

        return cell;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FTGymSourceTableView *theTableView = (FTGymSourceTableView *)tableView;
    NSLog(@"周几：%ld,row : %ld", theTableView.index, indexPath.row);
    FTGymSourceTableViewCell *cell = [tableView viewWithTag:(10000 + indexPath.row)];
    if (cell.hasCourseData && !cell.isPast) {//如果有课程数据，而且是未来可以预约的
        NSString *timeSection = _timeSectionsArray[indexPath.row][@"timeSection"];
        [_delegate courseClickedWithCell:cell andDay:theTableView.index andTimeSection:timeSection];
    }
    
}

@end