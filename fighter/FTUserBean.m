//
//  User.m
//  renzhenzhuan
//
//  Created by Liyz on 4/1/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTUserBean.h"

@implementation FTUserBean
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.uid = [NSString stringWithFormat:@"%@", value];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.tel forKey:@"tel"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.realname forKey:@"realname"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.headpic forKey:@"headpic"];
    [aCoder encodeObject:self.stemfrom forKey:@"stemfrom"];
    [aCoder encodeObject:self.olduserid forKey:@"olduserid"];
    [aCoder encodeObject:self.telmodel forKey:@"telmodel"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.remorks forKey:@"remorks"];
    [aCoder encodeObject:self.lastlogintime forKey:@"lastlogintime"];
    [aCoder encodeObject:self.imei forKey:@"imei"];
    
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.cardType forKey:@"cardType"];
    [aCoder encodeObject:self.cardNo forKey:@"cardNo"];
    [aCoder encodeObject:self.lastModifyName forKey:@"lastModifyName"];
    [aCoder encodeObject:self.openId forKey:@"openId"];
    [aCoder encodeObject:self.unionId forKey:@"unionId"];
    [aCoder encodeObject:self.registertime forKey:@"registertime"];
    [aCoder encodeObject:self.unionuserid forKey:@"unionuserid"];
    [aCoder encodeObject:self.wxopenId forKey:@"wxopenId"];
    [aCoder encodeObject:self.effect forKey:@"effect"];
    
    //更新字段
    [aCoder encodeObject:self.height forKey:@"height"];
    [aCoder encodeObject:self.weight forKey:@"weight"];
    [aCoder encodeObject:self.address forKey:@"address"];
    
    //微信
    [aCoder encodeObject:self.wxHeaderPic forKey:@"wxHeader"];
    [aCoder encodeObject:self.wxName forKey:@"wxName"];
    [aCoder encodeObject:self.identity forKey:@"identity"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
//        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.tel = [aDecoder decodeObjectForKey:@"tel"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.realname = [aDecoder decodeObjectForKey:@"realname"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.headpic = [aDecoder decodeObjectForKey:@"headpic"];
        self.stemfrom = [aDecoder decodeObjectForKey:@"stemfrom"];
        self.olduserid = [aDecoder decodeObjectForKey:@"olduserid"];
        self.imei = [aDecoder decodeObjectForKey:@"imei"];
        self.telmodel = [aDecoder decodeObjectForKey:@"telmodel"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.remorks = [aDecoder decodeObjectForKey:@"remorks"];
        self.lastlogintime = [aDecoder decodeObjectForKey:@"lastlogintime"];
        
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.cardType = [aDecoder decodeObjectForKey:@"cardType"];
        self.cardNo = [aDecoder decodeObjectForKey:@"cardNo"];
        self.lastModifyName = [aDecoder decodeObjectForKey:@"lastModifyName"];
        self.openId = [aDecoder decodeObjectForKey:@"openId"];
        self.unionId = [aDecoder decodeObjectForKey:@"unionId"];
        self.registertime = [aDecoder decodeObjectForKey:@"registertime"];
        self.unionuserid = [aDecoder decodeObjectForKey:@"unionuserid"];
        self.wxopenId = [aDecoder decodeObjectForKey:@"wxopenId"];
        self.effect = [aDecoder decodeObjectForKey:@"effect"];
        
        //更新字段
        self.height = [aDecoder decodeObjectForKey:@"height"];
        self.weight = [aDecoder decodeObjectForKey:@"weight"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        //微信
        self.wxHeaderPic = [aDecoder decodeObjectForKey:@"wxHeader"];
        self.wxName = [aDecoder decodeObjectForKey:@"wxName"];
        self.identity = [aDecoder decodeObjectForKey:@"identity"];
    }
    return self;
}



//根据生日计算年龄 默认存储格式为yyyy-MM-dd
- (NSString *) age {
    
    if (self.birthday && self.birthday.length > 0) {
        
        NSString *birth = self.formaterBirthday;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //生日
        NSDate *birthDay = [dateFormatter dateFromString:birth];
        //当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
        NSLog(@"currentDate %@ birthDay %@",currentDateStr,birth);
        NSTimeInterval time=[currentDate timeIntervalSinceDate:birthDay];
        int age = ((int)time)/(3600*24*365);
        NSLog(@"year %d",age);
        
        if (age < 0) {
            age = 0;
        }
        return [NSString stringWithFormat:@"%i",age];
    }
    return nil;
}

- (NSString *) formaterBirthday {

    if (self.birthday && self.birthday.length > 0) {
        
        NSArray *array = [self.birthday componentsSeparatedByString:@" "];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date=[dateFormatter dateFromString:[array objectAtIndex:0]];
        NSLog(@"date:%@",date);
        NSLog(@"birth%@",self.birthday);
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        return [dateFormatter stringFromDate:date];
    }
    
    return nil;
    
}

- (void)setValuesWithDic:(NSDictionary *)dic{
    [super setValuesWithDic:dic];
    if (!self.query) {
        self.query = @"0";
    }
    if (!self.sex || [self.sex isEqualToString:@""]) {
        self.sex = @"男";
    }else if ([self.sex isEqualToString:@"0"]){
        self.sex = @"男";
    }else if ([self.sex isEqualToString:@"1"]){
        self.sex = @"女";
    }
    self.birthday = [NSString stringWithFormat:@"%@", self.birthday];
    
    if (!self.brief) {
        self.brief = @"";
    }
    _boxerRaceInfos = dic[@"boxerRaceInfos"];
    
}

@end
