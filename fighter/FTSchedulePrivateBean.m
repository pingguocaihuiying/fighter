//
//  FTCourseBean
//  fighter
//
//  Created by kang on 2016/11/10.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTSchedulePrivateBean.h"

@implementation FTSchedulePrivateBean 

- (instancetype)initWithFTCourseBeanDic:(NSDictionary *)infoDic {
	self = [super init];
	if (self) {
		if (infoDic) {
			_myIsOrd = [[infoDic objectForKey:@"myIsOrd"] integerValue];
			_updateTime = [[infoDic objectForKey:@"updateTime"] integerValue];
			_timeSection = [infoDic objectForKey:@"timeSection"];
			_corporationid = [[infoDic objectForKey:@"corporationid"] integerValue];
			_courseId = [[infoDic objectForKey:@"courseId"] integerValue];
			_coachUserId = [infoDic objectForKey:@"coachUserId"];
			_userId = [infoDic objectForKey:@"userId"];
			_timeId = [[infoDic objectForKey:@"timeId"] integerValue];
			_createTime = [[infoDic objectForKey:@"createTime"] integerValue];
			_createTimeTamp = [infoDic objectForKey:@"createTimeTamp"];
			_date = [[infoDic objectForKey:@"date"] integerValue];
			_theDate = [[infoDic objectForKey:@"theDate"] integerValue];
			_placeId = [[infoDic objectForKey:@"placeId"] integerValue];
			_updateName = [infoDic objectForKey:@"updateName"];
			_updateTimeTamp = [infoDic objectForKey:@"updateTimeTamp"];
			_coachName = [infoDic objectForKey:@"coachName"];
			_label = [infoDic objectForKey:@"label"];
			_type = [infoDic objectForKey:@"type"];
			_id = [[infoDic objectForKey:@"id"] integerValue];
			_createName = [infoDic objectForKey:@"createName"];

		}
	}
	return self;
} 

@end


