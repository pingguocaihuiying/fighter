//
//  FTBaseBean.h
//  fighter
//
//  Created by Liyz on 5/4/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTBaseBean : NSObject
- (void)setValuesWithDic:(NSDictionary *)dic;
- (NSString *)replaceImageURLToHttpsDomain:(NSString *)urlOriginal;
@end
