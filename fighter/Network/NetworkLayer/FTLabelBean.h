//
//  FTLabelBean.h
//  fighter
//
//  Created by Liyz on 5/16/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTLabelBean : NSObject<NSCoding>
//"},{"nameEn":"label","itemValue":"空手道","itemValueEn":"Karate","item":5,"id":2,"name":"标签
@property (nonatomic, copy)NSString *nameEn;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *itemValue;
@property (nonatomic, copy)NSString *item;
@property (nonatomic, copy)NSString *itemValueEn;
@property (nonatomic, copy)NSString *labelId;
- (instancetype)initWithName:(NSString *)name andNameEn:(NSString *)nameEn;

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;
@end
