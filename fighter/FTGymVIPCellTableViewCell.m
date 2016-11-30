//
//  FTGymVIPCellTableViewCell.m
//  fighter
//
//  Created by kang on 2016/9/28.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymVIPCellTableViewCell.h"
#import "NSString+Tool.h"

@implementation FTGymVIPCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setBalanceLabelPosition];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBalance:) name:RechargeMoneytNoti object:nil];
}

- (void) dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) setBalanceLabelPosition {

    if (SCALE < 1) {
        self.balanceTextLabel.text = @"余额：";
        self.yuanLabel.hidden = YES;
        
        self.courseDateLeadConstraint.constant = 10;
        self.orderDateLeadConstraint.constant = 10;
    }
}


- (void) setValueWithBean:(FTGymBean *)bean {

    self.bean = bean;
    
    if (bean.surplusCourse.length > 0) {
        self.surplusCourse.text = bean.surplusCourse;
    }else {
        self.surplusCourse.text = @"0";
    }
    
    self.deadline.text = bean.deadline;
    self.balanceLabel.text = bean.userMoney;
    
    self.gymName.text = bean.gymName;
    self.gymAddress.text = bean.gymLocation;
    self.gymPhone.text = bean.gymTel;
    
    self.courseDate.text = bean.courseDate;
    self.courseTime.text = bean.courseTime;
    self.course.text = [NSString gymNameAdapter:bean.course];//[bean.course removeString:@"(MMA)"];
    
    self.orderDate.text = bean.orderDate;
    self.orderTime.text = bean.orderTime;
    self.order.text = [NSString gymNameAdapter:bean.order];//[bean.order removeString:@"(MMA)"];;
    
    
    NSString *imgStr = bean.gymShowImg;// dic[@"gymShowImg"];
    if (imgStr && imgStr.length > 0) {
        NSArray *tempArray = [imgStr componentsSeparatedByString:@","];
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/%@",bean.urlPrefix,[tempArray objectAtIndex:0]];
        
        [self.gymImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"拳馆占位图"]];
    }else {
        
        [self.gymImageView setImage:[UIImage imageNamed:@"拳馆占位图"]];
    }
}

- (void) refreshBalance:(NSNotification *)noti {
    
    NSString *object = [noti object];
    if ([object isEqualToString:@"SUCCESS"]) {
        NSDictionary *dic = [noti userInfo];
        if ([dic[@"corporationId"] integerValue] ==  self.bean.corporationid) {
            self.balanceLabel.text = dic[@"balance"];
        }
    }
    
}
@end
