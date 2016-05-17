//
//  FTLabelBean.m
//  fighter
//
//  Created by Liyz on 5/16/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTLabelBean.h"

@implementation FTLabelBean
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.labelId = [NSString stringWithFormat:@"%@", value];
    }
}
- (instancetype)initWithName:(NSString *)name andNameEn:(NSString *)nameEn{
    if (self = [super init]) {
        self.name = name;
        self.nameEn = nameEn;
    }
    return self;
}
- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues{
    @try {
            [super setValuesForKeysWithDictionary:keyedValues];
    } @catch (NSException *exception) {
        NSLog(@"错误原因：服务器类别的字断可能有改动");
        NSLog(@"exception : %@", exception);
    } @finally {
        
    }
    
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    //    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.labelId forKey:@"labelId"];
    [aCoder encodeObject:self.nameEn forKey:@"nameEn"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.itemValue forKey:@"itemValue"];
    [aCoder encodeObject:self.item forKey:@"item"];
    [aCoder encodeObject:self.itemValueEn forKey:@"itemValueEn"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.labelId = [aDecoder decodeObjectForKey:@"labelId"];
        self.nameEn = [aDecoder decodeObjectForKey:@"nameEn"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.itemValue = [aDecoder decodeObjectForKey:@"itemValue"];
        self.item = [aDecoder decodeObjectForKey:@"item"];
        self.itemValueEn = [aDecoder decodeObjectForKey:@"itemValueEn"]; 
    }
    return self;
}
@end
