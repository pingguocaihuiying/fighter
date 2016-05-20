//
//  FTArenaNetwork.m
//  fighter
//
//  Created by Liyz on 5/18/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTArenaNetwork.h"

@implementation FTArenaNetwork
- (void)newPostWithDic:(NSDictionary *)dic andOption:(void (^)(NSDictionary *))option{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *getCategoryUrlString = [FTNetConfig host:Domain path:NewPostURL];
    NSLog(@"getCategoryUrlString : %@", getCategoryUrlString);
    
    [manager POST:getCategoryUrlString parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (option) {
            option(responseDic);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (option) {
            option(nil);
        }
    }];
}
@end
