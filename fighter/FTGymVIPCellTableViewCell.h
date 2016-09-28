//
//  FTGymVIPCellTableViewCell.h
//  fighter
//
//  Created by kang on 2016/9/28.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTGymVIPCellTableViewCell : UITableViewCell


// top view 余额等信息
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *surplusCourse; //剩余课时
@property (weak, nonatomic) IBOutlet UILabel *deadline;// 截止日期
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;// 账户余额label

// gym view 拳馆信息
@property (weak, nonatomic) IBOutlet UIView *gymView;
@property (weak, nonatomic) IBOutlet UIImageView *gymImageView;
@property (weak, nonatomic) IBOutlet UILabel *gymName;
@property (weak, nonatomic) IBOutlet UILabel *gymAddress;
@property (weak, nonatomic) IBOutlet UILabel *gymPhone;

// course view 课程信息
@property (weak, nonatomic) IBOutlet UIView *courseView;
@property (weak, nonatomic) IBOutlet UILabel *courseDate;//课时日期
@property (weak, nonatomic) IBOutlet UILabel *courseTime;//课时时间
@property (weak, nonatomic) IBOutlet UILabel *course;// 课程

// order view 约课记录
@property (weak, nonatomic) IBOutlet UIView *orderView;
@property (weak, nonatomic) IBOutlet UILabel *orderDate;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *order;

// bottom view 进入拳馆按钮
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *gymAccessButton;




@end
