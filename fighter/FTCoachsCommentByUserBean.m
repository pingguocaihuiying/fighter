//
//  FTCoachsCommentByUser.m
//  fighter
//
//  Created by 李懿哲 on 21/12/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTCoachsCommentByUserBean.h"

@implementation FTCoachsCommentByUserBean

- (void)setValuesWithDic:(NSDictionary *)dic{
    _studentName = dic[@"createName"];
    _studentId = dic[@"createTimeTamp"];
    _coachName = dic[@"coach"];
    _coachId = dic[@"coachUserId"];
    _evaluation = dic[@"evaluation"];
    _headUrl = dic[@"headUrl"];
    _type = dic[@"type"];
    _score = [dic[@"score"] floatValue];
    NSTimeInterval ts = [dic[@"createTimeTamp"] doubleValue];
    if (ts) {
        _timeString = [FTTools fixStringForDate:[NSString stringWithFormat:@"%.0lf", ts]];
    }
}

@end
