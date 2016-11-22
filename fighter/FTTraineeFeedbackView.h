//
//  FTTraineeFeedbackView.h
//  fighter
//
//  Created by kang on 2016/11/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTTraineeFeedbackView : UIView

@property (nonatomic, copy) NSString *coachName; // 教练名
@property (nonatomic, copy) NSString *coachHeaderUrl; //教练头像路径
@property (nonatomic, copy) NSString *courseDate; // 课程日期
@property (nonatomic, copy) NSString *courseName; // 课程名

@property (nonatomic,assign) NSInteger rate; // 打分星级

@end
