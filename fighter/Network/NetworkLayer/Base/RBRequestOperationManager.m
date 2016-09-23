//
//  RBRequestOperationManager.m
//  rzzNetwork
//
//  Created by liushuai on 16/3/24.
//  Copyright © 2016年 Liuonion. All rights reserved.
//

#import "RBRequestOperationManager.h"

@implementation RBRequestOperationManager

+ (RBRequestOperationManager *)manager
{
    return [[self alloc] initWithBaseURL:nil];
}

- (void)postToPath:(NSString *)path
            params:(NSDictionary *)params
           success:(void (^)(NSDictionary *responseJson))success
         dataError:(void (^)(NSString *errorCode, NSString *errorMessage))responseDataError
           failure:(void (^)(NSURLSessionTask *task, NSError *error))failure
{
    [self postToPath:path params:params timeoutInterval:-1 success:success dataError:responseDataError failure:failure];
}

- (void)getToPath:(NSString *)path
           params:(NSDictionary *)params
          success:(void (^)(NSDictionary *responseJson))success
        dataError:(void (^)(NSString *errorCode, NSString *errorMessage))responseDataError
          failure:(void (^)(NSURLSessionTask *task, NSError *error))failure
{
    [self getToPath:path params:params success:success dataError:responseDataError failure:failure];
}

- (void)postToPath:(NSString *)path
            params:(NSDictionary *)params
   timeoutInterval:(NSInteger)timeoutInterval
           success:(void (^)(NSDictionary *responseJson))success
         dataError:(void (^)(NSString *errorCode, NSString *errorMessage))responseDataError
           failure:(void (^)(NSURLSessionTask *task, NSError *error))failure
{
    // 调整3840
    self.requestSerializer = [ AFHTTPRequestSerializer serializer];
    
    self.responseSerializer = [ AFHTTPResponseSerializer serializer];
    
    if (timeoutInterval != -1) {
        self.requestSerializer.timeoutInterval = timeoutInterval;
    }else{
        self.requestSerializer.timeoutInterval = 30;
    }
    
    NSMutableSet *macceptableContentTypes = [self.responseSerializer.acceptableContentTypes mutableCopy];
    [macceptableContentTypes addObjectsFromArray:@[@"text/html",@"text/plain"]];
    self.responseSerializer.acceptableContentTypes = macceptableContentTypes;
    
    [self POST:path parameters:params progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        if (jsonDict) {
            
            success(jsonDict);
            
        }else{
            NSLog(@"服务器数据异常");
            responseDataError(@"-1",@"服务器数据异常");
        }
        
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
        failure(task,error);
        
    }];
}

- (void)getToPath:(NSString *)path
           params:(NSDictionary *)params
  timeoutInterval:(NSInteger)timeoutInterval
          success:(void (^)(NSDictionary *responseJson))success
        dataError:(void (^)(NSString *errorCode, NSString *errorMessage))responseDataError
          failure:(void (^)(NSURLSessionTask *task, NSError *error))failure
{
    // 调整3840
    self.requestSerializer = [ AFHTTPRequestSerializer serializer];
    
    self.responseSerializer = [ AFHTTPResponseSerializer serializer];
    
    if (timeoutInterval != -1) {
        self.requestSerializer.timeoutInterval = timeoutInterval;
    }else{
        self.requestSerializer.timeoutInterval = 30;
    }
    
    NSMutableSet *macceptableContentTypes = [self.responseSerializer.acceptableContentTypes mutableCopy];
    [macceptableContentTypes addObjectsFromArray:@[@"text/html",@"text/plain"]];
    self.responseSerializer.acceptableContentTypes = macceptableContentTypes;
    
    [self GET:path parameters:params progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        if (jsonDict) {
            
            success(jsonDict);
            
        }else{
            responseDataError(@"-1",@"服务器数据异常");
        }
        
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
    
}
@end
