//
//  NetWorking.m
//  fighter
//
//  Created by Liyz on 4/13/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "NetWorking.h"
#import "UUID.h"

@implementation NetWorking


//获取短信验证码
- (void) getCheckCodeWithPhoneNumber:(NSString *)phoneNum option:(void (^)(NSDictionary *dict))option{
    
    NSString *urlString = [FTNetConfig host:Domain path:GetPhoneCodeURL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:phoneNum forKey:@"phone"];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"GetPhoneCodeURL url : %@", urlString);
    [manager POST:urlString
       parameters:dic
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
              NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              NSLog(@"responsedic:%@",responseDic);
            
              if (option) {
                  option(responseDic);
              }
          }
          failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
              NSLog(@"error:%@",error);
              
          }];
}

//手机号注册用户
- (void) registUserWithPhoneNumber:(NSString *)phoneNum
                          password:(NSString *)password
                         checkCode:(NSString *)checkcode
                            option:(void (^)(NSDictionary *dict))option{
    
//
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
    
    NSString *registURLString = [FTNetConfig host:Domain path:RegisterUserURL];
    NSLog(@"完成注册按钮clicked");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *username = phoneNum;
    NSString *checkCode = checkcode;
    NSString *imei= [UUID getUUID];
//    NSString *password = password;
//    NSString *checkCode = checkCode;
    
    NSString *appendedPassword = [NSString stringWithFormat:@"%@%@", password, @"**#qwe"];
    NSString *md5String = [MD5 md5:appendedPassword];
    
    NSDictionary *dic = @{@"userId" : username,
                      @"imei" : imei,
                      @"sequenceId" : imei,
                      @"password" : md5String,
                      @"checkCode" : checkCode,
                      @"city" : @"-1",
                      @"recommCode" : @"-1",
                      };
    NSLog(@"dic : %@", dic);
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"RegisterUserURL url : %@", registURLString);
    [manager POST:registURLString
       parameters:dic
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
              NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              NSLog(@"responsedic:%@",responseDic);
              
              if (option) {
                  option(responseDic);
              }
          }
          failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
              NSLog(@"error:%@",error);
              
          }];
}

//手机号登录
- (void) loginWithPhoneNumber:(NSString *)phoneNum
                          password:(NSString *)password
                            option:(void (^)(NSDictionary *dict))option{
    
    
    
    NSString *loginURLString = [FTNetConfig host:Domain path:UserLoginURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *username = phoneNum;
    NSString *appendedPassword = [NSString stringWithFormat:@"%@%@", password, @"**#qwe"];
    NSString *md5String = [MD5 md5:appendedPassword];
    
    NSDictionary *dic = @{@"phone" : username,
                          @"password" : md5String,
                          @"city" : @"-1",
                          };
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"UserLoginURL url : %@", loginURLString);
    [manager POST:loginURLString
       parameters:dic
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
              NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              NSLog(@"responsedic:%@",responseDic);
              
              if (option) {
                  option(responseDic);
              }
          }
          failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
              NSLog(@"error:%@",error);
              
          }];
    }

@end
