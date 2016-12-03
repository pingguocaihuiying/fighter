//
//  FTTraineeBean.m
//  fighter
//
//  Created by kang on 2016/11/9.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeBean.h"

@implementation FTTraineeBean 

- (instancetype)initWithFTTraineeBeanDic:(NSDictionary *)infoDic {
	self = [super init];
	if (self) {
		if (infoDic) {
			_updateTime = [[infoDic objectForKey:@"updateTime"] longValue];
			_timeSection = [infoDic objectForKey:@"timeSection"];
			_corporationid = [[infoDic objectForKey:@"corporationid"] integerValue];
			_courseId = [[infoDic objectForKey:@"courseId"] integerValue];
			_userId = [infoDic objectForKey:@"userId"];
			_sex = [infoDic objectForKey:@"sex"];
			_newMember = [[infoDic objectForKey:@"newMember"] integerValue];
			_timeId = [[infoDic objectForKey:@"timeId"] integerValue];
			_updateTimeTamp = [infoDic objectForKey:@"updateTimeTamp"];
			_label = [infoDic objectForKey:@"label"];
			_id = [[infoDic objectForKey:@"id"] integerValue];
			_createTimeTamp = [infoDic objectForKey:@"createTimeTamp"];
			_coachName = [infoDic objectForKey:@"coachName"];
			_signStatus = [[infoDic objectForKey:@"signStatus"] integerValue];
			_type = [infoDic objectForKey:@"type"];
			_hasGrade = [[infoDic objectForKey:@"hasGrade"] integerValue];
			_updateName = [infoDic objectForKey:@"updateName"];
			_date = [[infoDic objectForKey:@"date"] integerValue];
			_createTime = [[infoDic objectForKey:@"createTime"] longValue];
			_headUrl = [infoDic objectForKey:@"headUrl"];
			_createName = [infoDic objectForKey:@"createName"];
			_coachUserId = [infoDic objectForKey:@"coachUserId"];
			_placeId = [[infoDic objectForKey:@"placeId"] integerValue];
			_theDate = [[infoDic objectForKey:@"theDate"] integerValue];

		}
	}
	return self;
} 

@end


