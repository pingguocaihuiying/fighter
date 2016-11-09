//
//  FTUserCourseHistoryTableViewCell.m
//  fighter
//
//  Created by 李懿哲 on 08/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTUserCourseHistoryTableViewCell.h"
#import "FTUserCourseHistoryBean.h"
#import "NSDate+Tool.h"

@interface FTUserCourseHistoryTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeSectionLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (strong, nonatomic) IBOutlet UIView *bottomDividingLine;
@property (strong, nonatomic) IBOutlet UILabel *coachNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *personalCoachImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *personalCoachImageViewWidth;

@end

@implementation FTUserCourseHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _dateLabel.textColor = [UIColor whiteColor];
    _timeSectionLabel.textColor = [UIColor whiteColor];
    _courseNameLabel.textColor = [UIColor whiteColor];
    _bottomDividingLine.backgroundColor = Cell_Space_Color;
    _coachNameLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithBean:(FTBaseBean *)bean{
    FTUserCourseHistoryBean *courseBean = (FTUserCourseHistoryBean *)bean;
    _dateLabel.text = [NSDate monthDayStringWithWordSpace:courseBean.date];
    _timeSectionLabel.text = courseBean.timeSection;
    _coachNameLabel.text = [NSString stringWithFormat:@"教练:%@", courseBean.coachName];
    
    //私教的徽章:0-团课，2-私教
    if ([courseBean.courseType isEqualToString:@"2"]) {
        _personalCoachImageView.hidden = NO;//显示徽章
        _courseNameLabel.text = @"私教";//显示“私教”
        _personalCoachImageViewWidth.constant = 8;
    } else {
        _personalCoachImageView.hidden = YES;//隐藏徽章
        _personalCoachImageViewWidth.constant = 0;
        _courseNameLabel.text = courseBean.courseName;//显示课程名字
    }
    
    //是否显示红点
    
    NSString *version = courseBean.version;
    if (version) {
        NSMutableDictionary *versionDic = [[NSUserDefaults standardUserDefaults]valueForKey:COURSE_VERSION];//从本地读取记录版本号已读、未读的字典
        NSString *value = versionDic[version];
        if (value && [value isEqualToString:READ]) {//如果已读
            _redPoint.hidden = YES;//不显示红点
        }else{
            _redPoint.hidden = NO;//显示红点
        }
    }
}

@end
