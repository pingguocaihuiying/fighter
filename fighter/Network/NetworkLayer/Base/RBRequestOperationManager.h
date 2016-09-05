//
//  RBRequestOperationManager.h
//  rzzNetwork
//
//  Created by liushuai on 16/3/24.
//  Copyright © 2016年 Liuonion. All rights reserved.
//

//#import "AFHTTPRequestOperationManager.h"

@interface RBRequestOperationManager : AFHTTPSessionManager

+ (RBRequestOperationManager *)manager;

- (void)postToPath:(NSString *)path
            params:(NSDictionary *)params
           success:(void (^)(NSDictionary *responseJson))success
         dataError:(void (^)(NSString *errorCode, NSString *errorMessage))responseDataError
           failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;

- (void)getToPath:(NSString *)path
           params:(NSDictionary *)params
          success:(void (^)(NSDictionary *responseJson))success
        dataError:(void (^)(NSString *errorCode, NSString *errorMessage))responseDataError
          failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;

- (void)postToPath:(NSString *)path
            params:(NSDictionary *)params
   timeoutInterval:(NSInteger)timeoutInterval
           success:(void (^)(NSDictionary *responseJson))success
         dataError:(void (^)(NSString *errorCode, NSString *errorMessage))responseDataError
           failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;

- (void)getToPath:(NSString *)path
           params:(NSDictionary *)params
  timeoutInterval:(NSInteger)timeoutInterval
          success:(void (^)(NSDictionary *responseJson))success
        dataError:(void (^)(NSString *errorCode, NSString *errorMessage))responseDataError
          failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;
@end
