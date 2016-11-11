//
//  FTTraineeSkillBean
//  fighter
//
//  Created by kang on 2016/11/10.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeSkillBean.h"

@implementation FTTraineeSkillBean 

- (instancetype)initWithFTTraineeSkillBeanDic:(NSDictionary *)infoDic {
	self = [super init];
	if (self) {
		if (infoDic) {
			_score = [[infoDic objectForKey:@"score"] integerValue];
			_name = [infoDic objectForKey:@"name"];
			_parent = [[infoDic objectForKey:@"parent"] integerValue];
			_id = [[infoDic objectForKey:@"id"] integerValue];

		}
	}
	return self;
} 

@end


