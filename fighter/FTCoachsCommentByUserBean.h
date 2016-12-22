//
//  FTCoachsCommentByUser.h
//  fighter
//
//  Created by 李懿哲 on 21/12/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseBean.h"

@interface FTCoachsCommentByUserBean : FTBaseBean

@property (nonatomic, copy) NSString *studentName;
@property (nonatomic, copy) NSString *studentId;
@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, copy) NSString *coachName;
@property (nonatomic, copy) NSString *coachId;
@property (nonatomic, copy) NSString *evaluation;//评价内容
@property (nonatomic, assign) float score;
@property (nonatomic, copy) NSString *type;//上课的类型：团课、私教（目前只有私教用到）
@property (nonatomic, copy) NSString *headUrl;//用户头像

@end
