//
//  FTTaskRemindCell.m
//  fighter
//
//  Created by kang on 16/8/19.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTaskRemindCell.h"
#import "FTLocalNotification.h"

@implementation FTTaskRemindCell {

    NSInteger h;
    NSInteger m;
    NSInteger s;
    
    NSTimer *timer;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    //    self.contentView.alpha = 0.5;
    //    self.contentView.opaque = NO;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setRemindBtn];
    [self setTimeLabel];
    [self setTimer];
    
}

- (void) dealloc {
    
    [timer invalidate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - 初始化

- (void) setRemindBtn {

    NSString  *nonificationName = [[NSUserDefaults standardUserDefaults] objectForKey:@"taskNotification"];
    if (nonificationName) {
        self.remindBtn.selected = YES;
    }
}

- (void) setTimeLabel {

    //获取系统当前时间
    NSDate *currentDate = [NSDate date];
    
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
   
    
    NSString *dateString = [NSString stringWithFormat:@"%@ 6:10:00",currentDateString];
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date = [formatter dateFromString:dateString];
    
    NSLog(@"%@",[formatter stringFromDate:currentDate]);
    NSLog(@"%@",[formatter stringFromDate:date]);
    
    NSInteger taskTime = [date timeIntervalSince1970];
    NSInteger currentTime = [currentDate timeIntervalSince1970];
    
    
    
    if (taskTime < currentTime) {
        
        NSLog(@"taskTime:%ld",taskTime);
        NSLog(@"currentTime:%ld",currentTime);
        
        NSInteger shicha =  taskTime - currentTime + 24*60*60;
        
        h = shicha/(60*60);
        m = (shicha %3600)/60;
        s = (shicha %60);
        
        [self.timeLabel setText:[NSString stringWithFormat:@"%ld小时 %ld分钟 %ld秒",h,m,s]];
    }else {
    
        NSLog(@"currentTime:%ld",currentTime);
        NSLog(@"taskTime:%ld",taskTime);
        
        NSInteger shicha =  taskTime - currentTime;
        
        h = shicha/(60*60);
        m = (shicha %3600)/60;
        s = (shicha %60);
        [self.timeLabel setText:[NSString stringWithFormat:@"%ld小时 %ld分钟 %ld秒",h,m,s]];
    }

}

- (void) setTimer {
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeLabel:) userInfo:nil repeats:YES];
    
}


- (void) updateTimeLabel:(id) time {
    
    s--;
    if (s < 0) {
        s = 59;
        m--;
        if (m <0) {
            m = 59;
            h--;
            if (h < 0) {
                
                [self setTimeLabel];
            }
        }
    }
    
    [self.timeLabel setText:[NSString stringWithFormat:@"%ld小时 %ld分钟 %ld秒",h,m,s]];
    
}

#pragma mark - remindButton response

- (IBAction)remindBtnAction:(id)sender {
    
    if (self.remindBtn.selected) {
        self.remindBtn.selected = NO;
        [FTLocalNotification cancelTaskNotification];
    }else {
        
        self.remindBtn.selected = YES;
        [FTLocalNotification registTaskNotification];
    }
    
}

@end
