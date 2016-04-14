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
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self postToPath:path params:params timeoutInterval:-1 success:success dataError:responseDataError failure:failure];
}

- (void)getToPath:(NSString *)path
           params:(NSDictionary *)params
          success:(void (^)(NSDictionary *responseJson))success
        dataError:(void (^)(NSString *errorCode, NSString *errorMessage))responseDataError
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getToPath:path params:params success:success dataError:responseDataError failure:failure];
}

- (void)postToPath:(NSString *)path
            params:(NSDictionary *)params
   timeoutInterval:(NSInteger)timeoutInterval
           success:(void (^)(NSDictionary *responseJson))success
         dataError:(void (^)(NSString *errorCode, NSString *errorMessage))responseDataError
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
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
    
    [self POST:path parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *responseString = [operation responseString];
        NSLog(@"\n---------------请求-----------\n%@\n\n----------响应-----------\n\n返回的json:\n\n%@\n------------------\n",operation.response.URL.absoluteString,responseString);
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        if (jsonDict) {
            
            success(jsonDict);
            
        }else{
            NSLog(@"服务器数据异常");
            responseDataError(@"-1",@"服务器数据异常");
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
        failure(operation,error);
        
    }];
}

- (void)getToPath:(NSString *)path
           params:(NSDictionary *)params
  timeoutInterval:(NSInteger)timeoutInterval
          success:(void (^)(NSDictionary *responseJson))success
        dataError:(void (^)(NSString *errorCode, NSString *errorMessage))responseDataError
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
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
    
    [self GET:path parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *responseString = [operation responseString];
        NSLog(@"\n---------------请求-----------\n%@\n\n----------响应-----------\n\n返回的json:\n\n%@\n------------------\n",operation.response.URL.absoluteString,responseString);
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        if (jsonDict) {
            
            success(jsonDict);
            
        }else{
            responseDataError(@"-1",@"服务器数据异常");
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(operation,error);
    }];
    
}
@end
