//
//  User.h
//  renzhenzhuan
//
//  Created by Liyz on 4/1/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTBaseBean.h"

@interface FTUserBean : FTBaseBean<NSCoding>
//@property (nonatomic, copy)NSString *uid;
//@property (nonatomic, copy)NSString *tel;
//@property (nonatomic, copy)NSString *username;
//@property (nonatomic, copy)NSString *realname;
//@property (nonatomic, copy)NSString *token;
//@property (nonatomic, copy)NSString *password;
//@property (nonatomic, copy)NSString *headpic;
//@property (nonatomic, copy)NSString *stemfrom;
//@property (nonatomic, copy)NSString *olduserid;
//@property (nonatomic, copy)NSString *telmodel;
//@property (nonatomic, copy)NSString *email;
//@property (nonatomic, copy)NSString *remorks;
//@property (nonatomic, copy)NSString *lastlogintime;
//@property (nonatomic, copy)NSString *imei;

//@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *unionId;
@property (nonatomic,copy) NSString *openId;
@property (nonatomic,copy) NSString *olduserid;
@property (nonatomic,copy) NSString *registertime;
@property (nonatomic,copy) NSString *tel;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *imei;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *cardType;
@property (nonatomic,copy) NSString *stemfrom;
@property (nonatomic,copy) NSString *wxopenId;

@property (nonatomic,copy) NSString *telmodel;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *lastModifyName;
@property (nonatomic,copy) NSString *effect;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *remorks;
@property (nonatomic,copy) NSString *unionuserid;
@property (nonatomic,copy) NSString *cardNo;
@property (nonatomic,copy) NSString *headpic;//头像
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *lastlogintime;
@property (nonatomic,copy) NSString *username;


//更新字段
@property (nonatomic,copy) NSString *height;//身高
@property (nonatomic,copy) NSString *weight;//体重
@property (nonatomic,copy) NSString *address;//地址，归属地

//微信
@property (nonatomic, copy) NSString *wxHeaderPic;//微信头像
@property (nonatomic, copy) NSString *wxName;//微信昵称
//@property (nonatomic, copy) NSString *wxToken;//



//计算年龄
- (NSString *) age;
//格式化生日
- (NSString *) formaterBirthday;


@end
