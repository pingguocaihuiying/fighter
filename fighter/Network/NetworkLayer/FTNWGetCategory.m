//
//  FTNWGetCategory.m
//  fighter
//
//  Created by Liyz on 5/16/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTNWGetCategory.h"
#import "FTNetConfig.h"
#import "FTLabelBean.h"

@implementation FTNWGetCategory

+ (NSArray *)sharedCategories{
    NSArray *resultArray = [[NSUserDefaults standardUserDefaults]objectForKey:CATEGORIES];
    if (resultArray == nil) {//如果是第一次安装，先给一个默认的标签显示
        NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:@[
                                                                           @{@"itemValue":@"综合格斗(UFC)", @"itemValueEn":@"MMA"},
                                                                           @{@"itemValue":@"拳击", @"itemValueEn":@"Boxing"},
                                                                           @{@"itemValue":@"摔跤(WWE)", @"itemValueEn":@"Wrestling"},
                                                                           @{@"itemValue":@"女子格斗", @"itemValueEn":@"FemaleWrestling"},
                                                                           @{@"itemValue":@"街斗", @"itemValueEn":@"StreetFight"},
                                                                           @{@"itemValue":@"泰拳", @"itemValueEn":@"ThaiBoxing"},
                                                                           @{@"itemValue":@"跆拳道", @"itemValueEn":@"Taekwondo"},
                                                                           @{@"itemValue":@"相扑", @"itemValueEn":@"Sumo"},
                                                                           @{@"itemValue":@"柔道", @"itemValueEn":@"Judo"},
                                                                           @{@"itemValue":@"其他", @"itemValueEn":@"Others"},
                                                                           ]];
        resultArray = tempArray;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [FTNWGetCategory getCategoryWithOption:^(NSArray *array) {
            [[NSUserDefaults standardUserDefaults]setObject:array forKey:CATEGORIES];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }];
    });
    return resultArray;
}



+ (void)getCategoryWithOption:(void (^)(NSArray *array))option{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *getCategoryUrlString = [FTNetConfig host:Domain path:GetCategoryURL];
//    NSLog(@"getCategoryUrlString : %@", getCategoryUrlString);
    
    [manager POST:getCategoryUrlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableArray *resultArray;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([responseDic[@"status"] isEqualToString:@"success"]) {
            resultArray = [[NSMutableArray alloc]init];
            for(NSDictionary *dic in responseDic[@"data"]){
                if ([dic[@"name"] isEqualToString:@"标签"]) {
                    if ([dic[@"itemValue"] isEqualToString:@"其它"] ) {
//                        continue;
                    }
                    [resultArray addObject:dic];
                }
            }
        }
        if (option) {
            option(resultArray);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (option) {
            option(nil);
        }
    }];
}

@end
