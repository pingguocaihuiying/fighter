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
    
    [aCoder encodeObject:self.height forKey:@"height"];
    [aCoder encodeObject:self.weight forKey:@"weight"];

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
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
        
        self.height = [aDecoder decodeObjectForKey:@"height"];
        self.weight = [aDecoder decodeObjectForKey:@"weight"];
    }
    return self;
}
@end
