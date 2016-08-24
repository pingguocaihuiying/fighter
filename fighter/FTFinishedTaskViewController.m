//
//  FTFinishedTaskViewController.m
//  fighter
//
//  Created by kang on 16/8/19.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTFinishedTaskViewController.h"
#import "FTPayViewController.h"
#import "FTBaseNavigationViewController.h"
#import "NSDate+TaskDate.h"
#import "FTLocalNotification.h"

@interface FTFinishedTaskViewController ()
{
    NSInteger h;
    NSInteger m;
    NSInteger s;
    
    NSTimer *timer;

}

@property (weak, nonatomic) IBOutlet UIButton *remindBtn;//提醒按钮

@property (weak, nonatomic) IBOutlet UILabel *hLabel;//时

@property (weak, nonatomic) IBOutlet UILabel *mLabel;//分

@property (weak, nonatomic) IBOutlet UILabel *sLabel;//秒

@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;//充值按钮

@property (weak, nonatomic) IBOutlet UIView *taskView;// 任务展示view



@end

@implementation FTFinishedTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    
    [self setSubviews];
}


- (void) dealloc {

    [timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化
- (void) setNavigationBar {
    
    self.title = @"东西任务";
    
    //设置左侧按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(backBtnAction:)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}


- (void) setSubviews {

    self.taskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self setRemindBtn];
    
    [self setTimeLabel];
    
    [self setTimer];
}

#pragma mark - button response

- (void) backBtnAction:(id) sender {

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)remindBtnAction:(id)sender {
    
    if (self.remindBtn.selected) {
        self.remindBtn.selected = NO;
        [FTLocalNotification cancelTaskNotification];
    }else {
        
        self.remindBtn.selected = YES;
        [FTLocalNotification registTaskNotification];
    }
    
}

- (IBAction)rechargeBtnAction:(id)sender {
    
    FTPayViewController *payVC = [[FTPayViewController alloc]init];
    FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:payVC];
    baseNav.navigationBarHidden = NO;
    [self presentViewController:baseNav animated:YES completion:nil];
    
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
    }else {
        
        NSLog(@"currentTime:%ld",currentTime);
        NSLog(@"taskTime:%ld",taskTime);
        
        NSInteger shicha =  taskTime - currentTime;
        
        h = shicha/(60*60);
        m = (shicha %3600)/60;
        s = (shicha %60);
    }
    
    [self.hLabel setText:[NSString stringWithFormat:@"%ld",h]];
    [self.mLabel setText:[NSString stringWithFormat:@"%ld",m]];
    [self.sLabel setText:[NSString stringWithFormat:@"%ld",s]];
    
}

#pragma mark - timer

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
//                [self.navigationController popToRootViewControllerAnimated:YES];
                [self setTimeLabel];
            }
        }
    }
    
    [self.hLabel setText:[NSString stringWithFormat:@"%ld",h]];
    [self.mLabel setText:[NSString stringWithFormat:@"%ld",m]];
    [self.sLabel setText:[NSString stringWithFormat:@"%ld",s]];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
