//
//  WXSingleton.h
//  fighter
//
//  Created by kang on 16/7/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

//微信请求类型
typedef NS_ENUM(NSInteger, WXRequestType) {
    WXRequestTypeLogin,                 //微信跨界登录
    WXRequestTypeHeader,                //请求微信头像
    WXRequestTypeName,                  //请求微信昵称
    WXRequestTypeNameAndHeader,         //请求微信昵称和头像
    WXRequestTypeAll,                   //请求所有数据
};


@interface WXSingleton : NSObject <WXApiDelegate>

+(instancetype) shareInstance;

@property (nonatomic,assign) WXRequestType wxRequestType;

@end
