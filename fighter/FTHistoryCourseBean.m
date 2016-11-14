//
//  FTHistoryCourseBean.m
//  fighter
//
//  Created by kang on 2016/10/10.
//  Copyright © 2016年 Mapbar. All rights reserved.
//
#import "FTHistoryCourseBean.h"

@implementation FTHistoryCourseBean 

- (instancetype)initWithFTHistoryCourseBeanDic:(NSDictionary *)infoDic {
	self = [super init];
	if (self) {
		if (infoDic) {
			_hasOrderCount = [[infoDic objectForKey:@"hasOrderCount"] integerValue];
			_updateTime = [[infoDic objectForKey:@"updateTime"] integerValue];
			_corporationid = [[infoDic objectForKey:@"corporationid"] integerValue];
			_name = [infoDic objectForKey:@"name"];
			_statu = [[infoDic objectForKey:@"statu"] integerValue];
			_courseId = [[infoDic objectForKey:@"courseId"] integerValue];
			_topLimit = [[infoDic objectForKey:@"topLimit"] integerValue];
			_coachUserId = [infoDic objectForKey:@"coachUserId"];
			_placeId = [[infoDic objectForKey:@"placeId"] integerValue];
			_attendCount = [[infoDic objectForKey:@"attendCount"] integerValue];
			_createTime = [[infoDic objectForKey:@"createTime"] integerValue];
			_date = [[infoDic objectForKey:@"date"] integerValue];
			_timeId = [[infoDic objectForKey:@"timeId"] integerValue];
			_updateName = [infoDic objectForKey:@"updateName"];
			_label = [infoDic objectForKey:@"label"];
			_updateTimeTamp = [infoDic objectForKey:@"updateTimeTamp"];
			_createTimeTamp = [infoDic objectForKey:@"createTimeTamp"];
			_type = [infoDic objectForKey:@"type"];
			_id = [[infoDic objectForKey:@"id"] integerValue];
			_hasGradeCount = [[infoDic objectForKey:@"hasGradeCount"] integerValue];
			_createName = [infoDic objectForKey:@"createName"];
            _memberUserId = [infoDic  objectForKey:@"memberUserId"];
            _timeSection = [infoDic  objectForKey:@"timeSection"];
            _bookId = [[infoDic objectForKey:@"bookId"] integerValue];
            
		}
	}
	return self;
} 


- (void)setValuesWithDic:(NSDictionary *)infoDic {

    if (infoDic) {
        _hasOrderCount = [[infoDic objectForKey:@"hasOrderCount"] integerValue];
        _updateTime = [[infoDic objectForKey:@"updateTime"] integerValue];
        _corporationid = [[infoDic objectForKey:@"corporationid"] integerValue];
        _name = [infoDic objectForKey:@"name"];
        _statu = [[infoDic objectForKey:@"statu"] integerValue];
        _courseId = [[infoDic objectForKey:@"courseId"] integerValue];
        _topLimit = [[infoDic objectForKey:@"topLimit"] integerValue];
        _coachUserId = [infoDic objectForKey:@"coachUserId"];
        _placeId = [[infoDic objectForKey:@"placeId"] integerValue];
        _attendCount = [[infoDic objectForKey:@"attendCount"] integerValue];
        _createTime = [[infoDic objectForKey:@"createTime"] integerValue];
        _date = [[infoDic objectForKey:@"date"] integerValue];
        _timeId = [[infoDic objectForKey:@"timeId"] integerValue];
        _updateName = [infoDic objectForKey:@"updateName"];
        _label = [infoDic objectForKey:@"label"];
        _updateTimeTamp = [infoDic objectForKey:@"updateTimeTamp"];
        _createTimeTamp = [infoDic objectForKey:@"createTimeTamp"];
        _type = [infoDic objectForKey:@"type"];
        _id = [[infoDic objectForKey:@"id"] integerValue];
        _hasGradeCount = [[infoDic objectForKey:@"hasGradeCount"] integerValue];
        _createName = [infoDic objectForKey:@"createName"];
        _memberUserId = [infoDic  objectForKey:@"memberUserId"];
        _timeSection = [infoDic  objectForKey:@"timeSection"];
        _bookId = [[infoDic objectForKey:@"bookId"] integerValue];
    }
}
@end


