//
//  FTQiniuNetwork.m
//  fighter
//
//  Created by Liyz on 5/19/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTQiniuNetwork.h"

@implementation FTQiniuNetwork
+ (NSString *)getQiniuTokenWithMediaType:(NSString *)mediaType andKey:(NSString *)key andOption:(void (^)(NSString *token))option{
    NSString *qiniuToken = @"";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *getQiniuTokenUrlString = @"";
    if ([mediaType isEqualToString:@"image"]) {
        getQiniuTokenUrlString = [FTNetConfig host:Domain path:GetQiniuToken];
    }else if([mediaType isEqualToString:@"video"]){
        getQiniuTokenUrlString = [FTNetConfig host:Domain path:GetQiniuVideoToken];
    }
    
    FTUserBean *localUser = [FTUserTools getLocalUser];//获取本地用户
    
    NSString *userId = localUser.olduserid;
    
    NSString *loginToken = localUser.token;
    
    NSString *ts = [NSString stringWithFormat:@"%f", [[NSDate date]timeIntervalSince1970]];

    //文件名，获取视频token时，才传
    NSString *name = [NSString stringWithFormat:@"%@", key];
    //上传策略
//    NSString *strategy = @"s/640x360/vb/1.25m";
    NSString *strategy = @"";
    
    if ([mediaType isEqualToString:@"image"]) {
        NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@", loginToken,ts,userId, @"gedoujighfdsgdtfshdahfdhydasrs6"]];
        getQiniuTokenUrlString = [NSString stringWithFormat:@"%@?userId=%@&loginToken=%@&ts=%@&checkSign=%@",getQiniuTokenUrlString, userId,loginToken, ts, checkSign];
    }else if([mediaType isEqualToString:@"video"]){
        NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, name, strategy, ts,userId, @"gedoujighfdhfdshfdsadasrs2585226"]];
        getQiniuTokenUrlString = [NSString stringWithFormat:@"%@?userId=%@&loginToken=%@&ts=%@&checkSign=%@&name=%@&strategy=%@",getQiniuTokenUrlString, userId,loginToken, ts, checkSign, name, strategy];
    }
    
    
        NSLog(@"getQiniuTokenUrlString : %@", getQiniuTokenUrlString);
    
    [manager GET:getQiniuTokenUrlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"status : %@ message : %@",responseDic[@"status"],responseDic[@"message"]);
        if ([responseDic[@"status"] isEqualToString:@"success"]) {
            option(responseDic[@"data"]);
        }

    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(@"error");
    }];
    return qiniuToken;
}
@end
