//
//  FTQiniuNetwork.m
//  fighter
//
//  Created by Liyz on 5/19/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTQiniuNetwork.h"

@implementation FTQiniuNetwork
+ (NSString *)getQiniuTokenWithMediaType:(NSString *)mediaType andOption:(void (^)(NSString *token))option{
    NSString *qiniuToken = @"";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *getQiniuTokenUrlString = [FTNetConfig host:Domain path:GetQiniuToken];
    
    FTUserBean *localUser = [FTUserTools getLocalUser];//获取本地用户
    
    NSString *userId = localUser.olduserid;
    //    NSString *userId = @"2345";
    
    
    NSString *loginToken = localUser.token;
    NSString *ts = [NSString stringWithFormat:@"%f", [[NSDate date]timeIntervalSince1970]];

    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@", loginToken,ts,userId, @"gedoujighfdsgdtfshdahfdhydasrs6"]];
    getQiniuTokenUrlString = [NSString stringWithFormat:@"%@?userId=%@&loginToken=%@&ts=%@&checkSign=%@",getQiniuTokenUrlString, userId,loginToken, ts, checkSign];
        NSLog(@"getQiniuTokenUrlString : %@", getQiniuTokenUrlString);
    
    [manager GET:getQiniuTokenUrlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"status : %@ message : %@",responseDic[@"status"],responseDic[@"message"]);
        if ([responseDic[@"status"] isEqualToString:@"success"]) {
            option(responseDic[@"data"]);
        }

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        option(@"error");
    }];
    return qiniuToken;
}
@end
