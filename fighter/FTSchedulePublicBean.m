/*!
 *	producted by oc_json_plugin.py
 *	auth: w6
 */
#import "FTSchedulePublicBean.h"

@implementation FTSchedulePublicBean 

- (instancetype)initWithFTSchedulePublicBeanDic:(NSDictionary *)infoDic {
	self = [super init];
	if (self) {
		if (infoDic) {
			_myIsOrd = [[infoDic objectForKey:@"myIsOrd"] integerValue];
			_timeSection = [infoDic objectForKey:@"timeSection"];
			_courseId = [[infoDic objectForKey:@"courseId"] integerValue];
			_topLimit = [[infoDic objectForKey:@"topLimit"] integerValue];
			_coachUserId = [infoDic objectForKey:@"coachUserId"];
			_theDate = [[infoDic objectForKey:@"theDate"] integerValue];
			_label = [infoDic objectForKey:@"label"];
			_courseName = [infoDic objectForKey:@"courseName"];
			_timeId = [[infoDic objectForKey:@"timeId"] integerValue];
			_coach = [infoDic objectForKey:@"coach"];
			_nonGradeNumber = [infoDic objectForKey:@"nonGradeNumber"];
			_hasOrderCount = [[infoDic objectForKey:@"hasOrderCount"] integerValue];
			_type = [infoDic objectForKey:@"type"];
			_id = [[infoDic objectForKey:@"id"] integerValue];
			_subject = [infoDic objectForKey:@"subject"];

		}
	}
	return self;
} 

@end


