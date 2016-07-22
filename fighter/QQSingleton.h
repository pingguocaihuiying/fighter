//
//  QQShare.h
//  fighter
//
//  Created by kang on 16/7/21.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface QQSingleton : NSObject <QQApiInterfaceDelegate>

+(instancetype) shareInstance;

-(void)prepareToShare;

-(void)doOAuthLogin;

@end
